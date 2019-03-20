FROM thyrlian/android-sdk-vnc:latest

LABEL maintainer "mmcc007@gmail.com"

ADD avd.tar.gz /root/.android
ADD script /root/script