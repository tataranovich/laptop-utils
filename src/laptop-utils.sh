#!/bin/sh
# License: GPLv3
# Copyright 2015 Andrey Tataranovich <tataranovich@gmail.com>

TOUCHPAD='AlpsPS/2 ALPS DualPoint TouchPad'
STICK='DualPoint Stick'
LCDPANEL='LVDS1'

if [ -r /etc/default/laptop-utils ]; then
    . /etc/default/laptop-utils
fi

xinput_check() {
    local XINPUT_NAME
    XINPUT_NAME="$1"
    if [ ! -z "$XINPUT_NAME" ]; then
        xinput --list | grep -q "$XINPUT_NAME"
        return $?
    else
        return 1
    fi
}

xinput_ctl() {
    local XINPUT_NAME XINPUT_STATE
    XINPUT_NAME="$1"
    XINPUT_STATE="$2"
    xinput_check "$XINPUT_NAME" || return 1
    case "$XINPUT_STATE" in
        on) xinput --enable "$XINPUT_NAME" ;;
        off) xinput --disable "$XINPUT_NAME" ;;
        *) return 1;;
    esac
}

setup_input() {
    local XINPUT_POINTERS
    XINPUT_POINTERS=$(xinput --list | egrep -c 'slave\s+pointer')
    # Disable touchpad if pointers number greater than 3
    # On my Latitude E6430 pointer number is 3 when nothing is connected to it
    if [ "$XINPUT_POINTERS" -gt 3 ]; then
        xinput_ctl "$TOUCHPAD" off
    else
        xinput_ctl "$TOUCHPAD" on
    fi
    # Always disable stick
    xinput_ctl "$STICK" off
    if [ -f ~/.Xkbmap ]; then
        setxkbmap $(cat ~/.Xkbmap )
    fi
    xset b off
}

setup_displays() {
    # Disable disconnected outputs
    xrandr -q | awk '/disconnected/ {print $1}' | xargs -n1 -I{} -r xrandr --output {} --off

    # check if lid is closed
    if upower --dump | awk -F: '/lid-is-closed/ {print $2}' | grep -q yes$ ; then
        # check if any external monitor is connected
        if xrandr -q | awk '/ connected/ {print $1}' | grep -qv "$LCDPANEL"; then
            # if external monitor found then disable laptop display and enable all
            # external monitors
            for EXTDISP in $(xrandr -q | awk '/ connected/ {print $1}' | grep -v "$LCDPANEL")
            do
                xrandr --output $EXTDISP --auto
            done
            xrandr --output "$LCDPANEL" --off
        else
            # Enable laptop display anyway if no additional display connected
            xrandr --output "$LCDPANEL" --auto
            xbacklight -set 50
        fi
    else
        # Enable laptop display when lid is open
        xrandr --output "$LCDPANEL" --auto
        xbacklight -set 50
    fi

    if [ -x "`which openbox`" ]; then
        pidof openbox >/dev/null && openbox --reconfigure
    fi

}

setup_input
setup_displays

# Monitor system messages to catch resume event
dbus-monitor --system "type='signal',sender='org.freedesktop.UPower',path='/org/freedesktop/UPower',member='Resuming'" "type='signal',path='/org/freedesktop/login1',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" | while read EVENT
do
    if echo $EVENT | grep -Eq '(Resuming|false)'; then
        setup_input
        setup_displays
    fi
done
