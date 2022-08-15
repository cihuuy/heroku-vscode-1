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
RUN pip install pyinstaller
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
RUN tar -zxvf ngrok-v3-stable-linux-amd64.tgz
RUN sudo mv ngrok /usr/local/bin
RUN sudo ngrok config add-authtoken 22MA8pMrUiJFCcIIOtwDaF5R1My_2VRmkw6sMizNPr8ZN9nEF
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN sudo chmod +x msfinstall
RUN sudo ./msfinstall
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
COPY deploy-container/hack.py /usr/bin/deploy-container-hack.py
COPY deploy-container/defense_on.sh /usr/bin/deploy-container-defense_on.sh
COPY deploy-container/defense_off.sh /usr/bin/deploy-container-defense_off.sh
RUN chmod +x /usr/bin/deploy-container-entrypoint.sh && chmod +x /usr/bin/deploy-container-defense_on.sh && chmod +x /usr/bin/deploy-container-defense_off.sh && chmod +x /usr/bin/deploy-container-hack.py && chmod +x /usr/bin/deploy-container-self-ping.py && python3 /usr/bin/deploy-container-self-ping.py
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
