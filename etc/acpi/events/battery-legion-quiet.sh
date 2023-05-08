#!/bin/sh

ADP0_connected=$(cat /sys/class/power_supply/ADP0/online)

/bin/systemctl restart lenovo-fancurve.service

if [[ $ADP0_connected -eq 1 ]]; then
	/bin/echo balanced > /sys/firmware/acpi/platform_profile
else
	/bin/echo quiet > /sys/firmware/acpi/platform_profile
fi


