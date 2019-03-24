FROM thyrlian/android-sdk-vnc:3.0

LABEL maintainer "mmcc007@gmail.com"

ADD avd.tar.gz /root/.android
ADD script /root/script
