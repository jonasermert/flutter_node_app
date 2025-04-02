# Build stage
FROM debian:latest AS build-env

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop
RUN flutter doctor

# Copy app files
COPY . /app/
WORKDIR /app

# Get app dependencies
RUN flutter pub get

# Build the app for the target platform
RUN flutter build web --release

# Run stage
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 