FROM python:3.7-slim

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install apt-transport-https and wget
RUN apt-get install -y apt-transport-https wget 

# Add source for tesseract 5
RUN echo "deb https://notesalexp.org/tesseract-ocr-dev/buster/ buster main" >> /etc/apt/sources.list
# Add source for libleptonica-dev 1.79(sid)
RUN echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list

# Fetch and install the GnuPG key
RUN apt-get update -oAcquire::AllowInsecureRepositories=true
RUN apt-get install -y --allow-unauthenticated notesalexp-keyring -oAcquire::AllowInsecureRepositories=true
RUN apt-get update -y && apt-get -y upgrade

# install apt-get requirements
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    libice6 \
	tesseract-ocr \
    libleptonica-dev=1.79.0-1 \
    libtesseract-dev \
    pkg-config \
    python-skimage \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /usr/share/tesseract-ocr/5/tessdata/

RUN wget -q --show-progress --progress=bar:force:noscroll -O manga_jpn_vert.traineddata "https://github.com/zodiac3539/jpn_vert/raw/master/jpn_ver5.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O chi_tra.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/chi_tra.traineddata"  \
    && wget -q --show-progress --progress=bar:force:noscroll -O chi_tra_vert.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/chi_tra_vert.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O jpn.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/jpn.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O jpn_vert.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/jpn_vert.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O kor_vert.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/kor_vert.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O eng.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata" \
    && wget -q --show-progress --progress=bar:force:noscroll -O osd.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata"


WORKDIR /usr/share/tesseract-ocr/5/tessdata/script/

RUN wget -q --show-progress --progress=bar:force:noscroll -O Japanese.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/script/Japanese.traineddata"  \
    && wget -q --show-progress --progress=bar:force:noscroll -O Japanese_vert.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/script/Japanese_vert.traineddata"  \
    && wget -q --show-progress --progress=bar:force:noscroll -O Latin.traineddata "https://github.com/tesseract-ocr/tessdata/raw/master/script/Latin.traineddata" 

COPY requirements.txt /tmp
WORKDIR /tmp

# Install requirements
RUN pip3 --no-cache-dir install -r requirements.txt 