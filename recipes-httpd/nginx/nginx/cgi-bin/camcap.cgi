#!/usr/bin/env bash
echo "Content-type: text/html"
echo
echo "<html><head><title>CAMCTRL-CGI</title>"
echo "<style>a { padding: 0px 1em; border: 3px outset buttonborder; border-radius: 3px; color: buttontext; background-color: buttonface; text-decoration: none; }</style>"
echo "</head><body>"
echo "<hr />"
echo "<strong>** DEBUG INFO **</strong><br />"
printf "<i>Who am i?</i> $(whoami)<br />"
printf "<i>Uname?</i> $(uname -a)<br />"
printf "<i>Date?</i> $(date)<br />"
printf "<i>Uptime?</i> $(uptime)<br />"
echo "<hr /><br />"
echo "<strong>** CAMERA CONTROL CGI **</strong><br /><br />"
chmod 0777 /usr/local/nginx/html/camctrl
printf "<pre>Cleaning up..."
rm -f /usr/local/nginx/camctrl/cap.jpg
printf " done.</pre><br />"
printf "<pre>Capturing in background..."
nohup libcamera-jpeg -o /usr/local/nginx/html/camctrl/cap.jpg 1>/dev/null 2>/dev/null &
PID=$!
disown $PID
printf " process (PID=$PID) started, detached and disowned.</pre><br />"
echo "<strong>Please Navigate Back!</strong><br /><br /><br />"
echo "<a href=\"javascript:history.back()\">Go Back</a> if your browser supports javascript:history.back()<br /><br />" 
echo "<a href=\"http://192.168.1.1/camctrl\">Go to Camera Capture Ctl</a> if your browser does not support javascript"
echo "</body></html>"
exit 0
