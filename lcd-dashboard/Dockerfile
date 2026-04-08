ARG BUILD_FROM=ghcr.io/hassio-addons/base:20.0.2
FROM $BUILD_FROM
# 1. Add make, g++, and unzip to compile the C library
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    gcc \
    g++ \
    make \
    python3-dev \
    musl-dev \
    linux-headers \
    jpeg-dev \
    zlib-dev \
    freetype-dev \
    swig \
    unzip

# 2. Build the core liblgpio C library from source
# We use PREFIX=/usr so Alpine's compiler knows exactly where to find it later
WORKDIR /tmp/lgpio-build
RUN wget https://github.com/joan2937/lg/archive/master.zip && \
    unzip master.zip && \
    cd lg-master && \
    make && \
    make install PREFIX=/usr

WORKDIR /app

# Copy your local add-on files
COPY . /app/

# 3. Install Python requirements (Ensure RPi.GPIO is removed from requirements.txt!)
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# MUST BE SEPARATE: Install spidev
RUN pip3 install --no-cache-dir --break-system-packages spidev

# 4. Install the Python bindings for the C library we just built
RUN wget https://github.com/Gadgetoid/PY_LGPIO/releases/download/0.2.2.0/lgpio-0.2.2.0.tar.gz && \
    CFLAGS="-Wno-error=incompatible-pointer-types -std=gnu89" pip3 install --no-cache-dir --break-system-packages lgpio-0.2.2.0.tar.gz

# Force gpiozero to bypass its Pi 5 bug and ALWAYS open chip 0 for HAOS
# RUN sed -i 's/lgpio.gpiochip_open(chip)/lgpio.gpiochip_open(0)/g' /usr/lib/python3.12/site-packages/gpiozero/pins/lgpio.py

# 5. Install the shim LAST. It will see lgpio is already installed and skip building it!
RUN pip3 install --no-cache-dir --break-system-packages rpi-lgpio

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]