#!/bin/bash

bluetooth="bluez_source.1C_52_16_D4_84_16.handsfree_head_unit"
jack="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__source"
notebook="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_6__source"

pactl set-source-mute ${bluetooth} toggle
pactl set-source-mute ${jack} toggle
pactl set-source-mute ${notebook} toggle
