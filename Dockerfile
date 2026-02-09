FROM python:3.11-slim

# Set the working directory early to avoid accidental root directory modifications
WORKDIR /action

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y git curl jq && \
    pip install requests semver && \
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-lint/main/etc/install.sh | sh && \
    mv bin/arduino-lint /usr/local/bin/ && \
    rm -rf /action/bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the Python script and entrypoint shell script into the container
COPY action.py /action/action.py
COPY entrypoint.sh /action/entrypoint.sh

# Make sure the entrypoint script is executable
RUN chmod +x /action/entrypoint.sh

# Set the entrypoint to the shell script
ENTRYPOINT ["/action/entrypoint.sh"]
