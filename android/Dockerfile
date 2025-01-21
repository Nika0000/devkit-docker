FROM ubuntu:22.04

ARG TARGET_ARCH

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_NDK_VERSION=26.1.10909125
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_NDK_HOME="${ANDROID_SDK_ROOT}/ndk/${ANDROID_NDK_VERSION}"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    cmake \
    ninja-build \
    build-essential \
    pkg-config \
    zip \
    tar \
    unzip \
    tar \
    openjdk-17-jdk \
    wget \
    # clean up
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

#install Android SDK and NDK
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip commandlinetools-linux-*.zip -d android-sdk \
    && rm commandlinetools-linux-*.zip

# Install Android NDK and tools
RUN yes | /opt/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
    "ndk;${ANDROID_NDK_VERSION}" \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    && chmod +x $ANDROID_NDK_HOME

# Android environment variables for NDK cross-compilation
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_NDK_HOME}:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}"

# Install vcpkg
ARG VCPKG_BASELINE=1faad557cd7435901d7eac7b0b7f38e3e865701c
RUN git clone https://github.com/microsoft/vcpkg.git \
    && cd vcpkg \
    && git checkout $VCPKG_BASELINE \
    && ./bootstrap-vcpkg.sh \
    && ./vcpkg integrate install

# Set up vcpkg environment
ENV PATH="/opt/vcpkg:${PATH}"
ENV VCPKG_ROOT="/opt/vcpkg"

ENV VCPKG_DEFAULT_TRIPLET=${TARGET_ARCH}-android

RUN vcpkg install \
    curl[openssl] \
    openssl \
    ffmpeg \
    libpng \
    opus \
    expat \
    --triplet=${VCPKG_DEFAULT_TRIPLET}

WORKDIR /workspace

CMD ["/bin/bash"]