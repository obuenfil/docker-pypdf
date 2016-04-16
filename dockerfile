FROM debian:jessie
MAINTAINER Oswaldo Buenfil <oswaldob@shaw.ca>
LABEL version="1.0"

ENV SCAN_FOLDER=/data

RUN adduser ocr

# Base
RUN apt-get update
RUN apt-get install -y autoconf \
                          build-essential \
                          git \
                          liblept4 \
                          libleptonica-dev \
                          libgomp1 \
                          libtool

# Install Tesseract
RUN apt-get install -y tesseract-ocr tesseract-ocr-spa

# Install pypdfocr
RUN apt-get install -y libjpeg-dev zlib1g-dev
RUN apt-get install -y python-pip python-dev imagemagick poppler-utils
RUN pip install git+https://github.com/obuenfil/pypdfocr

# Make folder
RUN mkdir /data
RUN chown -R ocr:ocr /data

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      git \
                                      libleptonica-dev \
                                      libtool
RUN rm -rf /var/cache/apk/*
 

#ENTRYPOINT ["ls", "-l", "/data"]
ENTRYPOINT ["pypdfocr", "-w", "/data", "-f", "-c", "/data/config.yaml"]
