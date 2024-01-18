from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from custom_widgets import MicrophoneStatus

mod = "mod4"
terminal = guess_terminal()

pc_widgets = [
    widget.TextBox(fmt=''),
    widget.GroupBox(
        highlight_method='line',
        block_highlight_text_color="5BB1CD",
        inactive='555555',
        border_width=2
    ),
    widget.CheckUpdates(custom_command="yay -S && yay -Qu",
                        execute='lazy.widget["checkupdates"].force_update()',
                        no_update_string="󰍕",
                        update_interval=3600),
    widget.Prompt(),
    widget.Spacer(bar.STRETCH),
    widget.MemoryGraph(type='linefill', line_width=1),
    widget.CPUGraph(type='linefill', line_width=1,
                    graph_color='FF8C00',
                    fill_color='FF8C00'),
    widget.ThermalZone(zone="/sys/class/hwmon/hwmon1/temp1_input",
                       update_interval=5,
                       high=65,
                       crit=80),
    widget.Spacer(bar.STRETCH),

    widget.Clock(format="%d/%m %H:%M",
                 mouse_callbacks={'Button1': lazy.spawn("coretime")}),
    widget.KeyboardLayout(configured_keyboards=['us', 'br']),
    widget.TextBox(fmt=''),
    widget.PulseVolume(
        mouse_callbacks={'Button1': lazy.spawn("pavucontrol")},
        emoji=True,
        emoji_list=['󰖁', '󰕿', '󰖀', '󰕾'],
    ),
    MicrophoneStatus(update_interval=0.5,
                     mouse_callbacks={'Button1': lazy.spawn("/home/gcorreia/.config/qtile/volume_scripts/mute_mic.sh")}),
    widget.TextBox(fmt='󰍺',
                   mouse_callbacks={'Button1': lazy.spawn("arandr")}),
    widget.TextBox(fmt=''),
]

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Volume Bindings
    Key([], "XF86AudioRaiseVolume", lazy.spawn(
        "/home/gcorreia/.config/qtile/volume_scripts/volup.sh")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(
        "/home/gcorreia/.config/qtile/volume_scripts/voldown.sh")),
    Key([], "XF86Audiomute", lazy.spawn(
        "/home/gcorreia/.config/qtile/volume_scripts/mute.sh")),

    # Brightness Bindings
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set 5%-")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%+")),

    # sys bindings
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout."),
    Key([mod], "q", lazy.spawn("dm-tool lock"), desc="Locks the screen"),
    Key([], "Print", lazy.spawn("coreshot"), desc="Takes Screenshot"),
    Key([], "XF86AudioMicMute", lazy.spawn(
        "/home/gcorreia/.config/qtile/volume_scripts/mute_mic.sh"), desc="mutes mic"),
]

groups = [Group(i) for i in ["dev", "browse", "msg", "personal", "misc", "bg"]]

for index, i in enumerate(groups):
    keys.extend(
        [
            Key(
                [mod],
                str(index + 1),
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                str(index + 1),
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),
        ]
    )

layout_theme = {
    "border_width": 3,
    "margin": 5,
    "border_focus": "5BB1CD",
    "border_normal": "555555"
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),
]

widget_defaults = dict(font="sans", fontsize=14, padding=3,)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(pc_widgets,
                       24,
                       margin=[0, 5, 5, 5]
                       # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
                       # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
                       ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
