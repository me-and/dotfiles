if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/man" ]; then
    MANPATH="$HOME/man:$MANPATH"
fi

if [ -d "$HOME/info" ]; then
    INFOPATH="$HOME/info:$INFOPATH"
fi

if [ -d "$HOME/lib/python3" ]; then
    PYTHONPATH="$HOME/lib/python3/dist-packages:$PYTHONPATH"
fi

LANG=en_GB.UTF-8
LANGUAGE=en_GB:en

if [ "$(hostname)" = northrend.tastycake.net ]; then
    exec screen -xRR
fi
