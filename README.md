These are the instructions to use an M5Stack poesp32 running on ESPHOME with the econet package.
This was created with info from John Maton's repo: https://github.com/DrJohnM61/poesp32-esphome

Device: <https://shop.m5stack.com/products/esp32-ethernet-unit-with-poe>
EcoNet: <https://github.com/esphome-econet/esphome-econet>

I have edited `econet-hpwh-esp32.yaml` file to include the ethernet config.

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

Remove the hex bolt and clamshell to access the programming header:
![Image](https://github.com/user-attachments/assets/a66f53d7-eb5f-42a7-a4cd-45d1f95bd624)
Connect a USB ESP32 programmer
(I used a cheap one off Amazon: <https://www.amazon.com/gp/product/B0DKXW5WLT/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1>)

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

[^1]: These instructions are for macOS and require [Homebrew](https://brew.sh/).
