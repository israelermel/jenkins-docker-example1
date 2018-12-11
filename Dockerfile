FROM ubuntu:latest
USER root 
RUN cd /opt

RUN mkdir android-sdk-linux && cd android-sdk-linux/

RUN apt-get update -qq \
  && apt-get install -y openjdk-8-jdk \
  && apt-get install -y wget \
  && apt-get install -y expect \
  && apt-get install -y zip \
  && apt-get install -y unzip \
  && groupadd -g 999 docker \
  && usermod -aG docker Jenkins \
  && usermod -aG docker israelermel \
  && rm -rf /var/lib/apt/lists/*
  
    
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

RUN unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk-linux

RUN rm -rf sdk-tools-linux-4333796.zip

ENV ANDROID_HOME /opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'

# SDKs
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter android-28 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-27 | grep 'package installed'

# OR you can install everything like this
# RUN echo y | android update sdk --no-ui | grep 'package installed'

# build tools
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter build-tools-28.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-27.1.1 | grep 'package installed'

RUN android list sdk --all

# Update SDK
# This is very important. Without this, your builds wouldn't run. Your image would aways get this error:
# You have not accepted the license agreements of the following SDK components: 
# [Android SDK Build-Tools 24, Android SDK Platform 24]. Before building your project, 
# you need to accept the license agreements and complete the installation of the missing 
# components using the Android Studio SDK Manager. Alternatively, to learn how to transfer the license agreements 
# from one workstation to another, go to http://d.android.com/r/studio-ui/export-licenses.html

#So, we need to add the licenses here while it's still valid.
# The hashes are sha1s of the licence text, which I imagine will be periodically updated, so this code will 
# only work for so long.
RUN mkdir "$ANDROID_HOME/licenses" || true
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

RUN apt-get clean

RUN chown -R 1000:1000 $ANDROID_HOME

VOLUME ["/opt/android-sdk-linux"]

RUN mkdir -p /www

WORKDIR /www

ADD ./ /www