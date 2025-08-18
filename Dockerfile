# ------------------------------
# Android Build Environment (One Dockerfile)
# ------------------------------
FROM openjdk:21-jdk-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip git curl bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin:$PATH

RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd $ANDROID_HOME/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O tools.zip \
    && unzip tools.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm tools.zip

RUN yes | sdkmanager --licenses

RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0"

RUN wget https://services.gradle.org/distributions/gradle-8.6-bin.zip -O gradle.zip \
    && unzip gradle.zip -d /opt \
    && mv /opt/gradle-8.6 $GRADLE_HOME \
    && rm gradle.zip

WORKDIR /app
#COPY . .

#RUN chmod +x ./gradlew

#CMD ["./gradlew", "assembleRelease"]
