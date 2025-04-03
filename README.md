# ESPHome-EcoNet-PoE

These are the instructions to use an M5Stack poesp32 running on ESPHome with the econet package.
This was created with info from John Maton's [repo] (https://github.com/DrJohnM61/poesp32-esphome). I have edited `econet-hpwh-esp32.yaml` file to include the ethernet config. The included yaml file will work with heat pump water heaters, but the same modifications can used for other econet products.

### Hareware
[POE ESP32](https://shop.m5stack.com/products/esp32-ethernet-unit-with-poe)

[UART to RS485](https://shop.m5stack.com/products/rs485-module)

### Packages
[EcoNet](https://github.com/esphome-econet/esphome-econet)


## Software Setup
Ensure that we have the latest version of ESPHome, Python, and other packages[^1]:

```shell-session
brew update
brew upgrade
```

Update `pip`:

```shell-session
python3 -m pip install --upgrade pip
```

Update ESPHome:

```shell-session
pip3 install -U esphome
```
## Hardware Setup
Remove the hex bolt and clamshell on the PoESP32 to access the programming header:
![Image](https://github.com/dewbot6/poesp32-econet/blob/main/ESP32%20POE%20Screw.png)
Connect a USB ESP32 programmer
![Image](https://github.com/dewbot6/poesp32-econet/blob/main/ESP32%20Programmer.png)
(I used a cheap one off [Amazon](https://www.amazon.com/gp/product/B0DKXW5WLT/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)

## Software Installation
Note the usb device that the M5Stack POESP32 is plugged into. If you see more than one device, unplug and re-run the command to see what the new device name is.

```shell-session
ls /dev/ | grep cu.usbserial
```
```shell-session
poesp32-econet % ls /dev/ | grep cu.usbserial
cu.usbserial-14330
```

To build the ESP device with the coded YAML template, run the following command:

```shell-session
esphome run econet-hpwh-esp32-poe.yaml
```

Select the correct USB interface found in the first step.

```shell-session
Found multiple options for uploading, please choose one:
  [1] /dev/cu.usbserial-14330 (USB Serial)
  [2] Over The Air (econet-hpwh.local)
(number): 1
```

> [!CAUTION]
> Don't wipe a wrong device plugged into the computer.

Flashing is complete once you see Successfully uploaded program

```shell-session
Leaving...
Hard resetting via RTS pin...
INFO Successfully uploaded program.
INFO Starting log output from /dev/cu.usbserial-14330 with baud rate 115200
```

Reassemble the ESP32POE and connect an ethernet cable. You should see the lights blinking. Go to Home Assistant and the device should be shown as a new device under the left-hand "settings" menu.

### Using Docker:

Find your USB device using lsusb. Change /dev/ttyUSB1 as necessary.

```shell-session
docker run --rm -v "${PWD}":/config --device=/dev/ttyUSB1 -it esphome/esphome run econet-hpwh-esp32.yaml
```

## Adding to Home Assistant
Open Home Assistant and add a new ESPHome Integration, inputting the hostname of your device (e.g. "econet-hpwh.local" by default for Heat Pump Water Heaters). The device may be discovered automatically, in which case just accept the new device and wait a few moments. Once added, you can visit the device's details page (via Settings -> Devices & Services) to see all of the provided sensors are working.


## OTA
Run the esphome run command without USB and withe device powered on over POE

```shell-session
poesp32-econet % esphome run econet-hpwh-esp32-poe.yaml
INFO ESPHome 2025.3.0
INFO Reading configuration econet-hpwh-esp32-poe.yaml...
WARNING GPIO5 is a strapping PIN and should only be used for I/O with care.
Attaching external pullup/down resistors to strapping pins can cause unexpected failures.
See https://esphome.io/guides/faq.html#why-am-i-getting-a-warning-about-strapping-pins
INFO Generating C++ source...
INFO Compiling app...
Processing econet-hpwh (board: m5stack-core-esp32; framework: arduino; platform: platformio/espressif32@5.4.0)
-----------------------------------------------------------------------------------------------------------------------------------------------
HARDWARE: ESP32 240MHz, 320KB RAM, 4MB Flash
 - toolchain-xtensa-esp32 @ 8.4.0+2021r2-patch5
Dependency Graph
|-- WiFi @ 2.0.0
|-- ESPmDNS @ 2.0.0
|-- Update @ 2.0.0
RAM:   [=         ]  10.6% (used 34888 bytes from 327680 bytes)
Flash: [===       ]  35.0% (used 641725 bytes from 1835008 bytes)
========================================================= [SUCCESS] Took 1.25 seconds =========================================================
INFO Successfully compiled program.
INFO Resolving IP address of econet-hpwh.local in mDNS
INFO Connecting to 192.168.1.XXX port 3232...
INFO Connected to 192.168.1.XXX
INFO Upload took 5.06 seconds, waiting for result...
INFO OTA successful
INFO Successfully uploaded program.
INFO Starting log output from econet-hpwh.local using esphome API
INFO Successfully connected to econet-hpwh @ 192.168.1.233 in 2.139s
INFO Successful handshake with econet-hpwh @ 192.168.1.233 in 0.016s

```

[^1]: These instructions are for macOS and require [Homebrew](https://brew.sh/).
