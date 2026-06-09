#!/usr/bin/env bash
# Combined network signal module for polybar
#   On phone hotspot SSID → show phone cellular (KDE Connect), or "📱 hotspot"
#   On any other WiFi     → show WiFi SSID + signal
#   No connection         → "offline"

WIFI_IFACE="wlan0"
# Set this to your phone's hotspot SSID
PHONE_SSID="${PHONE_SSID:-sir nothing}"

# ── Read current WiFi state ──
WIFI_INFO=$(iw dev "$WIFI_IFACE" link 2>/dev/null)
CURRENT_SSID=$(echo "$WIFI_INFO" | sed -n 's/.*SSID: \(.*\)/\1/p')
WIFI_SIGNAL=$(echo "$WIFI_INFO" | sed -n 's/.*signal: \(.*\) dBm/\1/p')

# ── Path 1: Connected to phone hotspot ──
if [ "$CURRENT_SSID" = "$PHONE_SSID" ]; then
    DEVICE_ID=$(kdeconnect-cli -a --id-only 2>/dev/null | head -1)

    if [ -n "$DEVICE_ID" ]; then
        STRENGTH=$(gdbus call --session \
            --dest org.kde.kdeconnect \
            --object-path "/modules/kdeconnect/devices/${DEVICE_ID}/connectivity_report" \
            --method org.freedesktop.DBus.Properties.Get \
            "org.kde.kdeconnect.device.connectivity_report" \
            "cellularNetworkStrength" 2>/dev/null \
            | sed -n 's/.*<\(.*\)>.*/\1/p')

        TYPE=$(gdbus call --session \
            --dest org.kde.kdeconnect \
            --object-path "/modules/kdeconnect/devices/${DEVICE_ID}/connectivity_report" \
            --method org.freedesktop.DBus.Properties.Get \
            "org.kde.kdeconnect.device.connectivity_report" \
            "cellularNetworkType" 2>/dev/null \
            | sed -n "s/.*<'\(.*\)'>.*/\1/p")

        if [ -n "$STRENGTH" ] && [ "$STRENGTH" != "-1" ]; then
            case "$STRENGTH" in
                0) BARS="▁___" ;;
                1) BARS="▁▄__" ;;
                2) BARS="▁▄▆_" ;;
                3|4) BARS="▁▄▆█" ;;
                *)   BARS="?" ;;
            esac
            echo "📶 ${TYPE} ${BARS}"
            exit 0
        fi
    fi

    # Phone hotspot detected but no cellular data available
    echo "📱 hotspot"
    exit 0
fi

# ── Path 2: Regular WiFi ──
if [ -n "$CURRENT_SSID" ]; then
    if [ -n "$WIFI_SIGNAL" ]; then
        echo "📶 ${CURRENT_SSID} ${WIFI_SIGNAL}dBm"
    else
        echo "📶 ${CURRENT_SSID}"
    fi
    exit 0
fi

# ── Path 3: Nothing ──
echo "📶 offline"
