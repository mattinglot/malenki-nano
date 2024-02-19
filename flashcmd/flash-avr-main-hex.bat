echo "UFuse2 0x01 means 10mhz, which is what Malenki firmware is hardcoded to use"
echo "UFuse5 EESave (save EEPROM on flash) on, Full CRC checks"
echo "Fuse6 8ms delay between power on and code execution"

C:\Users\Matt\AppData\Local\Arduino15\packages\DxCore\tools\avrdude\6.3.0-arduino17or18/bin/avrdude -CC:\Users\Matt\AppData\Local\Arduino15\packages\megaTinyCore\hardware\megaavr\2.6.10/avrdude.conf -v -pattiny1616 -cjtag2updi -PCOM12 -b115200 -Ufuse0:w:0b00000000:m -Ufuse2:w:0x01:m -Ufuse5:w:0b11000101:m -Ufuse6:w:0x04:m -U	fuse7:w:0x00:m -Ufuse8:w:0x00:m -D -Uflash:w:main.hex:i 