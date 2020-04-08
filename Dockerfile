FROM ubuntu:18.04

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Python package management and basic dependencies
RUN apt-get install -y curl python3.7 python3.7-dev

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Set python 3 as the default python
RUN update-alternatives --set python /usr/bin/python3.7

# Upgrade pip to latest version
RUN apt-get install -y python3-pip 

# tzdata no interaction settings
ENV TZ=Europe/Minsk
ARG DEBIAN_FRONTEND=noninteractive

# get add-apt-repository
RUN apt-get update && apt-get install -y software-properties-common

# add tesseract 5 and python repositories
RUN add-apt-repository ppa:alex-p/tesseract-ocr-devel

# Check python version
# RUN python3 -V

# Check pip version
# RUN pip3 -V

# install apt-get requirements
RUN apt-get update && apt-get install -y \
    wget \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    libice6 \
    tesseract-ocr \
    libtesseract-dev \
    libleptonica-dev \
    pkg-config \
    python-skimage \
    && rm -rf /var/lib/apt/lists/*

# Get tessdata
WORKDIR /usr/share/tesseract-ocr/5/tessdata/
RUN wget -O jpn_vert.traineddata "https://github.com/zodiac3539/jpn_vert/raw/master/jpn_ver5.traineddata" 

# Install requirements
RUN pip3 --no-cache-dir install -r requirements.txt 