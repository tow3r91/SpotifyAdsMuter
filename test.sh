#!/bin/bash

# Filtra los mensajes relevantes del bus D-Bus
dbus-monitor --pcap "interface='org.freedesktop.DBus.Properties',path=/org/mpris/MediaPlayer2,member=PropertiesChanged" | while read -r line; do
    # Verifica si el mensaje contiene información de título y artista
 if [[ $line == *"Publicidad"* ]]; then
        title=$(echo "$line" | grep -oP '(?<=title: ")[^"]+')
        artist=$(echo "$line" | grep -oP '(?<=artist: ")[^"]+')
	sink_id=$(pactl info | grep 'Destino por defecto:*' | awk '{print $4}')
	pactl set-sink-mute "$sink_id" true
        echo "Sonido silenciado"
 else
        sink_id=$(pactl info | grep 'Destino por defecto:*' | awk '{print $4}')
        pactl set-sink-mute "$sink_id" false
	echo "Sonido restaurado"
    fi
done
