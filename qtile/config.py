from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from custom_widgets import MicrophoneStatus

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
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

groups = [Group(i) for i in ["dev", "browse", "msg", "misc", "bg"]]

for index, i in enumerate(groups):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                str(index + 1),
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                str(index + 1),
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"],
                   border_width=2,
                   border_focus='55AAAA'),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.CheckUpdates(custom_command="yay -S && yay -Qu",
                                    execute='lazy.widget["checkupdates"].force_update()',
                                    no_update_string='<span size="14pt">󰍕</span>',
                                    update_interval=3600),
                widget.Prompt(),
                widget.Spacer(bar.STRETCH),
                widget.MemoryGraph(type='linefill', line_width=1),
                widget.CPUGraph(type='linefill', line_width=1,
                                graph_color='FF8C00',
                                fill_color='FF8C00'),
                widget.ThermalZone(zone='/sys/class/thermal/thermal_zone5/temp',
                                   update_interval=5),
                widget.Spacer(bar.STRETCH),

                widget.Clock(format="%d/%m %H:%M",
                             mouse_callbacks={'Button1': lazy.spawn("coretime")}),
                widget.KeyboardLayout(configured_keyboards=['us', 'br']),
                widget.TextBox(fmt='',
                               fontsize=16,
                               padding=1.5,
                               mouse_callbacks={'Button1': lazy.spawn("blueman-manager")}),
                widget.Wlan(interface='wlp0s20f3',
                            format='󱚽',
                            disconnected_message='󰖪',
                            fontsize=22,
                            padding=1.5,
                            mouse_callbacks={'Button1': lazy.spawn("alacritty -e nmtui")}),
                widget.Volume(emoji="true",
                              emoji_list=['󰖁', '󰕿', '󰖀', '󰕾'],
                              fontsize=22,
                              mute_command=lazy.spawn('pavucontrol'),
                              padding=1.5,
                              mouse_callbacks={'Button1': lazy.spawn("pavucontrol")}),
                MicrophoneStatus(update_interval=0.5,
                                 mouse_callbacks={'Button1': lazy.spawn("pavucontrol")}),
                widget.TextBox(fmt='󰍺',
                               fontsize=16,
                               padding=1.5,
                               mouse_callbacks={'Button1': lazy.spawn("arandr")}),
                widget.Battery(format='<span size="14pt">{char}</span><span size="10pt">{percent:2.0%}</span>',
                               charge_char='󰂄',
                               discharge_char='󱟤',
                               padding=1.5,
                               fontsize=22),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
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
        # Run the utility of `xprop` to see the wm class and name of an X client.
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

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
