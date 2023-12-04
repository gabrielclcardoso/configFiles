import subprocess
from libqtile.widget import base


class MicrophoneStatus(base.InLoopPollText):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        super().__init__("", **config)
        self.text = self.get_microphone_status()

    def get_microphone_status(self):
        try:
            output = subprocess.check_output(
                ["pactl", "list", "sources"]).decode("utf-8")
            if "Mute: yes" in output:
                return ""
            elif "Mute: no" in output:
                return ""
            else:
                return "MIC: Unknown"
        except subprocess.CalledProcessError:
            return "MIC: N/A"

    def poll(self):
        return self.get_microphone_status()
