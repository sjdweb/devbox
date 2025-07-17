# Test environment for devbox setup
FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install sudo and create a non-root user (mimicking real environment)
RUN apt-get update && \
    apt-get install -y sudo && \
    useradd -m -s /bin/bash -G sudo testuser && \
    echo 'testuser:password' | chpasswd && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to testuser
USER testuser
WORKDIR /home/testuser

# Create expected directory structure
RUN mkdir -p ~/Code

# Copy the entire scriptsanddotfiles directory
COPY --chown=testuser:testuser . /home/testuser/Code/scriptsanddotfiles/

# Set working directory
WORKDIR /home/testuser/Code/scriptsanddotfiles/devbox

# Make scripts executable
RUN chmod +x bootstrap install/*.sh

# Start with bash
CMD ["/bin/bash"]