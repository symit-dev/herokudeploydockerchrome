# Use the official Python 3.11 image as base
FROM python:3.11-bookworm

# Set working directory
WORKDIR /usr/src/app

# Set appropriate permissions for the working directory
RUN chmod 777 /usr/src/app

# Update package list and install necessary utilities, now including Chrome
RUN apt-get update && apt-get install -y \
    wget \
    git \
    locales \
    sudo \
    zip \
    unzip \
    p7zip-full \
    unar \
    # Added curl and gnupg, which are needed to install Chrome
    curl \
    gnupg \
    # --- START: Added commands to install Google Chrome ---
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    # --- END: Added commands to install Google Chrome ---
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a new user 'appuser' and add it to the sudo group
RUN useradd -m -s /bin/bash appuser && \
    echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER appuser

# Copy requirements.txt to the working directory
COPY --chown=appuser:appuser requirements.txt .

# Install dependencies using pip
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application files to the working directory
COPY --chown=appuser:appuser . .

# Generate locale settings
RUN sudo locale-gen en_US.UTF-8

# Set environment variables for locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the default command to run start.sh script
CMD ["bash", "start.sh"]
