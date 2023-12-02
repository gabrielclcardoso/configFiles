#!/bin/bash

bluetooth="bluez_sink.1C_52_16_D4_84_16.a2dp_sink"
bluetooth_with_mic="bluez_sink.1C_52_16_D4_84_16.handsfree_head_unit"
speaker="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"
hdmi1="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink"
hdmi2="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink"
hdmi3="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink"

pactl set-sink-mute ${bluetooth} toggle
pactl set-sink-mute ${bluetooth_with_mic} toggle
pactl set-sink-mute ${speaker} toggle
pactl set-sink-mute ${hdmi1} toggle
pactl set-sink-mute ${hdmi2} toggle
pactl set-sink-mute ${hdmi3} toggle
