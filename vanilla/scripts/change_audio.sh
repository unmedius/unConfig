set_audio_sink() {
    local sink_type=$1
    local sink=$(pactl list short sinks | grep "$sink_type" | awk '{print $1}')
    if [ -n "$sink" ]; then
        echo "Setting default audio sink to $sink_type"
        pactl set-default-sink "$sink"
    else
        echo "No audio sink found for $sink_type"
    fi
}

case $1 in
    "pc") 
        set_audio_sink "analog"
        ;;
    "hdmi")
        set_audio_sink "hdmi"
        ;;
    "usb")
        set_audio_sink "usb"
        ;;
    *)
        echo "Usage: $0 {pc|hdmi|usb}"
        exit 1
        ;;
esac
