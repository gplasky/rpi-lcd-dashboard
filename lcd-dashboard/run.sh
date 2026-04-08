#!/usr/bin/with-contenv bashio

# Extract user configuration from the HA Add-on UI
export SPI_BUS=$(bashio::config 'spi_bus')
export SPI_DEVICE=$(bashio::config 'spi_device')
export SPI_SPEED=$(bashio::config 'spi_speed')
export LGPIO_CHIP=$(bashio::config 'gpio_chip')
export DIGITAL_BACKLIGHT=$(bashio::config 'digital_backlight')
export LAYOUT=$(bashio::config 'layout')
export VERSION="1.4.0"
BOARD_MODEL=$(bashio::config 'board_model')
case $BOARD_MODEL in
  "Raspberry Pi 5") export RPI_LGPIO_REVISION="d04170" ;;
  "Raspberry Pi 4") export RPI_LGPIO_REVISION="c03111" ;;
  "Raspberry Pi 3") export RPI_LGPIO_REVISION="a02082" ;;
  *) export RPI_LGPIO_REVISION="d04170" ;; # Default to Pi 5
esac

export PIN_RST=$(bashio::config 'pin_rst')
export PIN_DC=$(bashio::config 'pin_dc')
export PIN_BL=$(bashio::config 'pin_bl')

bashio::log.info "========================================="
bashio::log.info "STARTING RPI LCD DASHBOARD"
bashio::log.info "Configured for: ${BOARD_MODEL} (Revision: ${RPI_LGPIO_REVISION})"
bashio::log.info "SPI_BUS: ${SPI_BUS}"
bashio::log.info "SPI_DEVICE: ${SPI_DEVICE}"
bashio::log.info "SPI_SPEED: ${SPI_SPEED}"
bashio::log.info "LGPIO_CHIP: ${LGPIO_CHIP}"
bashio::log.info "DIGITAL_BACKLIGHT: ${DIGITAL_BACKLIGHT}"
bashio::log.info "LAYOUT: ${LAYOUT}"
bashio::log.info "VERSION: ${VERSION}"
bashio::log.info "========================================="

cd /app
python3 dashboard.py