# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    tigervnc-standalone-server \
    tigervnc-common \
    xfce4 \
    xfce4-goodies \
    novnc \
    websockify \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Create a user for running the VNC server
RUN useradd -m vncuser
USER vncuser
WORKDIR /home/vncuser

# Setup VNC server with password
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Create a script to start the VNC server
RUN echo '#!/bin/bash\n\
export DISPLAY=:1\n\
vncserver :1 -geometry 1280x1024 -depth 24 && tail -f /dev/null' > start-vnc.sh
RUN chmod +x start-vnc.sh

# Expose ports for VNC and noVNC
EXPOSE 5901 6080

# Run the VNC server and noVNC on container startup
CMD ./start-vnc.sh & websockify --web /usr/share/novnc 6080 localhost:5901
