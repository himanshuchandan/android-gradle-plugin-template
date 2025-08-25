# ------------------------------
# Android Build Environment (RHEL UBI Base) with APK Signing Tools
# ------------------------------
FROM registry.redhat.io/ubi9/openjdk-21:1.23-6.1755674728

# Install required packages
USER root
RUN microdnf clean all

# Environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/35.0.0:$GRADLE_HOME/bin:$PATH

# Install Android command line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd $ANDROID_HOME/cmdline-tools \
    && curl -k -L -o tools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip \
    && jar xf tools.zip \
    && mv cmdline-tools latest \
    && chmod +x $ANDROID_HOME/cmdline-tools/latest/bin/* \
    && rm tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install Android SDK components (includes apksigner + zipalign in build-tools)
RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0"

# Install Gradle
RUN curl -k -L -o gradle.zip https://services.gradle.org/distributions/gradle-8.14.3-bin.zip \
    && jar xf gradle.zip \
    && mv gradle-8.14.3 $GRADLE_HOME \
    && chmod +x $GRADLE_HOME/bin/* \
    && rm gradle.zip

# Verify signing tools are available
RUN command -v apksigner && command -v zipalign && command -v jarsigner

WORKDIR /app
#COPY . .
#RUN chmod +x ./gradlew
#CMD ["./gradlew", "assembleRelease"]
