#!/bin/sh
on_die () {  
   # kill all children  
   pkill -KILL -P $$  
}  
trap 'on_die' TERM  
libcamera-vid --width=320 --height=240 -t 0 -o - | ffmpeg -i - -f flv -rtmp_buffer 1000 -filter:v "setpts=1.75*PTS" rtmp://localhost/rtmp &
wait  

