# Start from the code-server Debian base image
FROM codercom/code-server:latest
ENV DEBIAN_FRONTEND=noninteractive
# Port
ENV PORT=8080
# User
USER root
RUN echo "root:root" | sudo chpasswd

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json
# Use bash shell
ENV SHELL=/bin/bash
# Install applications
RUN sudo apt update && sudo apt-get update
RUN apt-get install -y ssh git nano screenfetch curl wget zip unzip gzip docker.io docker python python3-pip python-setuptools iputils-ping 
RUN curl https://rclone.org/install.sh | sudo bash
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && sudo bash nodesource_setup.sh && sudo apt install nodejs

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json
# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local


# Use our custom entrypoint script first
USER root
COPY deploy-container/self-ping.py /usr/bin/deploy-container-self-ping.py
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
COPY deploy-container/ducko.sh /usr/bin/deploy-container-ducko.sh
COPY deploy-container/hack.py /usr/bin/deploy-container-hack.py
RUN chmod +x /usr/bin/deploy-container-entrypoint.sh && chmod +x /usr/bin/deploy-container-ducko.sh && chmod +x /usr/bin/deploy-container-hack.py && chmod +x /usr/bin/deploy-container-self-ping.py && python3 /usr/bin/deploy-container-self-ping.py
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
