# Test environment for devbox setup
FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install sudo and create a non-root user (mimicking real environment)
RUN apt-get update && \
    apt-get install -y sudo git && \
    useradd -m -s /bin/bash sean && \
    echo 'sean:password' | chpasswd && \
    echo 'sean ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to sean
USER sean
WORKDIR /home/sean

# Create expected directory structure
RUN mkdir -p ~/Code

# Copy the devbox repo
COPY --chown=sean:sean . /home/sean/devbox/

# Make scripts executable
RUN chmod +x ~/devbox/bootstrap ~/devbox/install/*.sh ~/devbox/verify-setup.sh

# Start with bash
CMD ["/bin/bash"]
