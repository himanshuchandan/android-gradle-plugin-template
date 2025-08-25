# ------------------------------
# Android Build Environment (RHEL UBI Base) with APK Signing Tools
# ------------------------------
FROM registry.redhat.io/ubi9/openjdk-21:1.23-6.1755674728

# Install required packages
USER root
RUN microdnf install -y \
    wget unzip git bash ca-certificates \
    && microdnf clean all

# Environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/35.0.0:$GRADLE_HOME/bin:$PATH

# Install Android command line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd $ANDROID_HOME/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O tools.zip \
    && unzip tools.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install Android SDK components (includes apksigner + zipalign in build-tools)
RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0"

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-8.14.3-bin.zip -O gradle.zip \
    && unzip gradle.zip -d /opt \
    && mv /opt/gradle-8.14.3 $GRADLE_HOME \
    && rm gradle.zip

# Verify signing tools are available
RUN which apksigner && which zipalign && which jarsigner

WORKDIR /app
#COPY . .
#RUN chmod +x ./gradlew
#CMD ["./gradlew", "assembleRelease"]
