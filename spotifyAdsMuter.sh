#!/bin/bash

# Verifica si Spotify está reproduciendo
if pgrep -x "spotify" > /dev/null; then
    # Obtiene el nombre del artista y la canción actual
    current_track=$(dbus-send --print-reply=literal --dest=org.mpris.MediaPlayer2.Player /org/mpris/MediaPlayer2/firefox org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep -E -o 'xesam:artist \"[^\"]+\"|xesam:title \"[^\"]+\"' | awk '{print $2}' | tr '\n' ' ')
    
    # Verifica si es publicidad
    echo $current_track;
    if [[ "$current_track" == *"Publicidad"* || "$current_track" == *"advertizing"* ]]; then
        # Silencia el sonido
        amixer set Master mute
        echo "Sonido silenciado"
    else
        # Restaura el sonido
        amixer set Master unmute
        echo "Sonido restaurado"
    fi
else
    echo "Spotify no está en ejecución"
fi
