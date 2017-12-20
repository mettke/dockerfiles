# Supported tags and respective `Dockerfile` links

-	[`27`, `latest` (*Dockerfile-27*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-27)
-	[`26` (*Dockerfile-26*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-26)
-	[`25` (*Dockerfile-25*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-25)
-	[`24` (*Dockerfile-24*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-24)
-	[`23` (*Dockerfile-23*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-23)
-	[`22` (*Dockerfile-22*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-22)
-	[`21` (*Dockerfile-21*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-21)
-	[`20` (*Dockerfile-20*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-20)
-	[`19` (*Dockerfile-19*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-19)
-	[`18` (*Dockerfile-18*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-18)
-	[`17` (*Dockerfile-17*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-17)
-	[`16` (*Dockerfile-16*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-16)
-	[`15` (*Dockerfile-15*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-15)
-	[`14` (*Dockerfile-14*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-14)
-	[`13` (*Dockerfile-13*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-13)
-	[`12` (*Dockerfile-12*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-12)
-	[`11` (*Dockerfile-11*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-11)
-	[`10` (*Dockerfile-10*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-10)
-	[`9` (*Dockerfile-9*)](https://github.com/mettke/dockerfiles/blob/androidsdk-alpine/androidsdk-alpine/Dockerfile-9)

# What is the Android SDK?

The Android SDK is used to build Android Applications in combination with Gradle and Java. 

> [developer.android.com](https://developer.android.com/studio/index.html)

# How to use this image

## Build locally

The Image may be used to build a local Android App.

```console
docker run --rm --name AndroidSDK \
           --volume ${PWD}:/data \
           -it toendeavour/androidsdk-alpine \
           ./gradlew assemble
```

It requires to mount the Android Project Root to the */data* folder. Afterwards the build can be started using the *./gradlew* file in the repository with its corresponding parameters like *build*

## gitlab

If you want to use the image with gitlab-ci using the docker executor, you only need to add something like the following to the *.gitlab-ci.yml*:

```yml
assemble:
  image: toendeavour/androidsdk-alpine
  script:
    - ./gradlew assemble
  tags:
    - docker
```

## Using specific SDK Version

If your Application does not use the most recent sdk, you may want to specify a specific SDK Version to prevent downloading it for each build (which might happen for example in an gitlab ci environment). To specify a SDK version, simple add it to the end of the image like

```
toendeavour/androidsdk-alpine:26
```