# Start from the code-server Debian base image
FROM codercom/code-server:lastest
ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN echo "root:root" | sudo chpasswd
RUN chmod u+s /bin/su

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install applications
RUN sudo apt update
RUN sudo apt-get update
RUN curl https://rclone.org/install.sh | sudo bash
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh 
RUN sudo bash nodesource_setup.sh
RUN sudo apt install nodejs
RUN apt-get install -y ssh git nano curl wget zip unzip docker.io docker python
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh


# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local


# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension vscode-icons-team.vscode-icons

#Install apt packages:



# Copy files: 
COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
