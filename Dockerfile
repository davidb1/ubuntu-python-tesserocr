FROM python:3.8-slim

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install apt-transport-https, wget and tesseract requirements
RUN apt-get install -y apt-transport-https \
    wget \
    automake \
    ca-certificates \
    g++ \
    git \
    libtool \
    libleptonica-dev \
    libtesseract-dev \
    python-skimage \
    make \
    pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN git clone https://github.com/tesseract-ocr/tesseract.git /usr/share/tesseract-ocr/5/ && chmod +x /usr/share/tesseract-ocr/5/

WORKDIR /usr/share/tesseract-ocr/5/

RUN ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig

# Get tessdata
WORKDIR /usr/share/tesseract-ocr/5/tessdata/

RUN wget -q --show-progress --progress=bar:force:noscroll -O jpn_vert.traineddata "https://github.com/zodiac3539/jpn_vert/raw/master/jpn_ver5.traineddata"  \
    && wget -q --show-progress --progress=bar:force:noscroll -O jpn.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/jpn.traineddata"

# install requirements
COPY requirements.txt /tmp
WORKDIR /tmp

# Install requirements
RUN pip3 --no-cache-dir install -r requirements.txt 