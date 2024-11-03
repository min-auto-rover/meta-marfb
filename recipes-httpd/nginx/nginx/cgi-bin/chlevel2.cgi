#!/usr/bin/env bash
echo "Content-type: text/html"
echo
echo "<html><head><title>CHLEVEL2-CGI</title>"
echo "<style>a { padding: 0px 1em; border: 3px outset buttonborder; border-radius: 3px; color: buttontext; background-color: buttonface; text-decoration: none; }</style>"
echo "</head><body>"
echo "<hr />"
echo "<strong>** DEBUG INFO **</strong><br />"
printf "<i>Who am i?</i> $(whoami)<br />"
printf "<i>Uname?</i> $(uname -a)<br />"
printf "<i>Date?</i> $(date)<br />"
printf "<i>Uptime?</i> $(uptime)<br />"
echo "<hr /><br />"
echo "<strong>** CHANGE RUNLEVEL TO 2 CGI **</strong><br /><br />"
printf "<pre>Capturing in background..."
exec /sbin/chlevel.sh 2 &
PID=$!
disown $PID
printf " process (PID=$PID) started, detached and disowned.</pre><br />"
echo "<strong>Runlevel Changed!</strong> The system will reboot now unless there is an error.<br /><br /><br />"
echo "</body></html>"
exit 0
