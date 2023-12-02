#!/bin/bash

bluetooth="bluez_sink.1C_52_16_D4_84_16.a2dp_sink"
bluetooth_with_mic="bluez_sink.1C_52_16_D4_84_16.handsfree_head_unit"
speaker="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"
hdmi1="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink"
hdmi2="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink"
hdmi3="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink"

pactl set-sink-volume ${bluetooth} +5%
pactl set-sink-volume ${bluetooth_with_mic} +5%
pactl set-sink-volume ${speaker} +5%
pactl set-sink-volume ${hdmi1} +5%
pactl set-sink-volume ${hdmi2} +5%
pactl set-sink-volume ${hdmi3} +5%
