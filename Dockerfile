FROM python:3.7-slim

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install apt-transport-https and wget
RUN apt-get install -y apt-transport-https wget 

# Add source for tesseract 5
RUN echo "deb https://notesalexp.org/tesseract-ocr-dev/buster/ buster main" >> /etc/apt/sources.list

# Fetch and install the GnuPG key
RUN apt-get update -oAcquire::AllowInsecureRepositories=true
RUN apt-get install -y --allow-unauthenticated notesalexp-keyring -oAcquire::AllowInsecureRepositories=true
RUN apt-get update -y && apt-get -y upgrade

# Install tesseract 5 
RUN apt-get install -y tesseract-ocr

# install apt-get requirements
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    libice6 \
    tesseract-ocr \
    libtesseract-dev \
    libleptonica-dev \
    pkg-config \
    python-skimage \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Get tessdata
WORKDIR /usr/share/tesseract-ocr/5/tessdata/
RUN wget -O jpn_vert.traineddata "https://github.com/zodiac3539/jpn_vert/raw/master/jpn_ver5.traineddata" 

COPY requirements.txt /tmp
WORKDIR /tmp

# Install requirements
RUN pip3 --no-cache-dir install -r requirements.txt 