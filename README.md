# ESPHome-EcoNet-PoE

These are the instructions to use an M5Stack poesp32 running on ESPHome with the econet package.
This was created with info from John Maton's [repo] (https://github.com/DrJohnM61/poesp32-esphome). I have edited `econet-hpwh-esp32.yaml` file to include the ethernet config. The included yaml file will work with heat pump water heaters, but the same modifications can used for other econet products.

### Hareware
[POE ESP32] (https://shop.m5stack.com/products/esp32-ethernet-unit-with-poe)

[UART to RS485] (https://shop.m5stack.com/products/rs485-module)

### Packages
[EcoNet] (https://github.com/esphome-econet/esphome-econet)


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
(I used a cheap one off [Amazon] (https://www.amazon.com/gp/product/B0DKXW5WLT/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)

## Software Installation
Note the usb device that the M5Stack POESP32 is plugged into. If you see more than one device, unplug and re-run the command to see what the new device name is.

```shell-session
ls /dev/ | grep cu.usbserial
```

To build the ESP device with the coded YAML template, run the following command:

```shell-session
esphome run econet-hpwh-esp32.yaml
```

Select the correct USB interface found in the first step.

> [!CAUTION]
> Don't wipe a wrong device plugged into the computer.

You should see progress: compile followed by writing the data to the device. If the device is not connected properly, then the load will fail. Check the connection and try again.

Make note of the encryption password for adding the device to home assistant.

Unplug the USB and plug in the POE ethernet cable. You should see the lights blinking. Go to Home Assistant and the device should be shown as a new device under the left-hand "settings" menu.

### Using Docker:

Find your USB device using lsusb. Change /dev/ttyUSB1 as necessary.

```shell-session
docker run --rm -v "${PWD}":/config --device=/dev/ttyUSB1 -it esphome/esphome run econet-hpwh-esp32.yaml
```

## Adding to Home Assistant
Open Home Assistant and add a new ESPHome Integration, inputting the hostname of your device (e.g. "econet-hpwh.local" by default for Heat Pump Water Heaters). The device may be discovered automatically, in which case just accept the new device and wait a few moments. Once added, you can visit the device's details page (via Settings -> Devices & Services) to see all of the provided sensors are working.

[^1]: These instructions are for macOS and require [Homebrew](https://brew.sh/).
