#!/bin/sh

sudo openocd \
   -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg \
   -c "init" \
   -c "reset halt" \
   -c "sleep 100" \
   -c "wait_halt 2" \
   -c "echo \"--- Writing LogicDiscovery-r12.bin\"" \
   -c "flash write_image erase LogicDiscovery-r12.bin 0x08000000" \
   -c "sleep 100" \
   -c "echo \"--- Verifying\"" \
   -c "verify_image LogicDiscovery-r12.bin 0x08000000" \
   -c "sleep 100" \
   -c "echo \"--- Done\"" \
   -c "resume" \
   -c "shutdown"