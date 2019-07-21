#!/usr/bin/env ash

EASY_RSA="/usr/share/easy-rsa/easyrsa \
    --pki-dir=/etc/openvpn/config/keys \
    --batch"

if [ ! -d "/etc/openvpn/config/keys" ]; then
    if [ -z "${DOMAIN}" ]; then
        echo "Environment Variable DOMAIN is required to automatically generate keys"
        exit 1
    fi
    echo "Generating keys"
    ${EASY_RSA} init-pki
    ${EASY_RSA} gen-dh
    ${EASY_RSA} build-ca nopass
    ${EASY_RSA} build-server-full "${DOMAIN}" nopass
    export CA_PASSWORD=$(tr -cd 'a-zA-Z0-9' < /dev/urandom | head -c 20)
    openssl rsa -aes256 \
        -in /etc/openvpn/config/keys/private/ca.key \
        -out /etc/openvpn/config/keys/private/ca.key \
        -passout "env:CA_PASSWORD"
    echo "The CA private key password is: ${CA_PASSWORD}"
    unset CA_PASSWORD # SLK3LiZlftkbRuQCDLDB

    if [ ! -f "/etc/openvpn/config/openvpn.conf" ]; then
        echo "Missing openvpn configuration. Using example config."
        cat <<EOT >> /etc/openvpn/config/openvpn.conf
local ::
port 1194
proto udp
dev tun

tun-ipv6
push tun-ipv6

ca /etc/openvpn/config/keys/ca.crt 
cert /etc/openvpn/config/keys/issued/${DOMAIN}.crt
key /etc/openvpn/config/keys/private/${DOMAIN}.key
dh /etc/openvpn/config/keys/dh.pem

topology subnet
server 10.1.0.0 255.255.255.0
$(if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" == "0" ]; then \
    echo "server-ipv6 fc00:1:1:1::/64"; fi)
ifconfig-pool-persist ipp.txt

$(if [ "${FORWARD}" == "1" ]; then \
    echo 'push "redirect-gateway def1"'; \
    echo $(if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" == "0" ]; then \
        echo 'push "redirect-gateway ipv6"'; fi); \
    echo 'push "dhcp-option DNS 8.8.8.8"'; fi)

keepalive 10 120
compress lz4-v2
push "compress lz4-v2"
max-clients 100

user nobody
group nobody
persist-key
persist-tun

status /etc/openvpn/config/openvpn-status.log
verb 3
explicit-exit-notify 1
EOT
    cat <<EOT >> /etc/openvpn/config/openvpn-client.conf
client
dev tun
tun-ipv6
proto udp
remote ${DOMAIN} 1194
resolv-retry infinite
nobind

persist-key
persist-tun

ca ca.crt
cert client.crt
key client.key

remote-cert-tls server
compress lz4-v2
verb 3
EOT
    fi
fi

if [ "${1}" == "sign" ]; then
    if [ ! -d "/etc/openvpn/config/keys/reqs" ]; then
        echo "Missing request directory: /etc/openvpn/config/keys/reqs"
        exit 1
    fi
    for request in $(ls /etc/openvpn/config/keys/reqs); do
        if [ "${request%.req}" == "${request}" ]; then
            echo "Skipping ${request}. File must end with .req"
            continue
        fi
        FILENAME=$(basename ${request} .req)
        if [ -f "/etc/openvpn/config/keys/issued/${FILENAME}.crt" ]; then
            fingerprint_crt=$(openssl x509 -pubkey -noout -in \
                "/etc/openvpn/config/keys/issued/${FILENAME}.crt" | \
                openssl sha1)
            fingerprint_req=$(openssl req -pubkey -noout -in \
                "/etc/openvpn/config/keys/reqs/${request}" | \
                openssl sha1)
            if [ "${fingerprint_crt}" == "${fingerprint_req}" ]; then
                echo "Skipping ${request}. Certificate matches request"
                continue
            else
                echo "Renewing ${request}"
                rm "/etc/openvpn/config/keys/issued/${FILENAME}.crt"
            fi
        else
            echo "Creating new certificate for ${request}"
        fi
         ${EASY_RSA} sign-req client "${FILENAME}"
         echo ""
    done
    exit 0
fi

if [ "${1}" == "renew-server" ]; then
    if [ -z "${EASYRSA_CERT_RENEW}"]; then
        EASYRSA_CERT_RENEW=90
    fi
    if [ -z "${DOMAIN}"]; then
        echo "Environment Variable DOMAIN is required to renew key"
    fi
    ${EASY_RSA} renew "${DOMAIN}" nopass
    exit 0
fi

if [ "${FORWARD}" == "1" ]; then
    for entry in $(cat /etc/openvpn/config/openvpn.conf | \
            grep "server " | awk '{print $2"/"$3}'); do

        iptables -t nat -A POSTROUTING -s "${entry}" -o eth0 -j MASQUERADE
    done
    if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" == "0" ]; then \
        for entry in $(cat /etc/openvpn/config/openvpn.conf | \
                grep "server-ipv6 " | awk '{print $2}'); do

            ip6tables -t nat -A POSTROUTING -s "${entry}" -o eth0 -j MASQUERADE
        done
    fi
fi

openvpn --config /etc/openvpn/config/openvpn.conf
