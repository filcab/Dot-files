#source ~/.bashrc

# Put us in $HOME
cd ~

# It seems this is no longer needed
##quartz-wm --only-proxy &

# Start urxvt server, killing previous servers...
#killall urxvtd
#urxvtd &

exec sh /usr/X11/lib/X11/xinit/xinitrc

