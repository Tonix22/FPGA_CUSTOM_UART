#!/bin/sh


sudo docker run -it --mount src="$(pwd)",target=/home/esp/UART_uc,type=bind -p 3333:3333 --device=/dev/ttyUSB0 tonix22/esp8266-idf