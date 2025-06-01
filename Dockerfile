# Note: We use 20.04 since AppImage recommends building on the
# oldest configuration that you support

FROM swift:6.1.2-jammy

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    checkinstall \
    git \
    autoconf \
    automake \
    libtool-bin \
    libssl-dev \
    pkg-config \
    libxml2 \       
    curl libcurl4-openssl-dev \
    zip unzip \
    liblzma-dev zlib1g-dev \
    usbmuxd \
    libimobiledevice-utils \
    fuse \
    libfuse2 \
    && rm -rf /var/lib/apt/lists/*

# Build xtool and cleanup
RUN mkdir -p /xtool
COPY ./Xcode_16.4.xip /xtool/
WORKDIR /xtool
RUN curl -fL \
  "https://github.com/xtool-org/xtool/releases/latest/download/xtool-$(uname -m).AppImage" \
  -o xtool
RUN chmod +x xtool
RUN mv xtool /usr/local/bin/
# Extract the AppImage instead of trying to mount it
RUN cd /usr/local/bin && ./xtool --appimage-extract \
    && mv squashfs-root /usr/local/share/xtool \
    && ln -sf /usr/local/share/xtool/AppRun /usr/local/bin/xtool 
RUN xtool sdk install /xtool/Xcode_16.4.xip \
    && cd / \
    && rm -rf /xtool/Xcode_16.4.xip

# Docker doesn't support FUSE
ENV APPIMAGE_EXTRACT_AND_RUN=1

# Use the host's usbmuxd.
# You probably want to use socat on the host to forward this port to /var/run/usbmuxd:
# socat -dd TCP-LISTEN:27015,range=127.0.0.1/32,reuseaddr,fork UNIX-CLIENT:/var/run/usbmuxd
ENV USBMUXD_SOCKET_ADDRESS=host.docker.internal:27015

WORKDIR /xtool

ENTRYPOINT [ "/bin/bash" ]
