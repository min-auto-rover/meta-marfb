#!/bin/sh
less << EOF

$(uname -a)

Welcome to Minimal Autonomous Rover (MAR) GNU/Linux System!

MAR GNU/Linux is free and open-source software.
Copyright (C) 2024 Qiyang Sun and the MAR Project Maintainers.

University of Southampton
University Road, Southampton, United Kingdom  SO17 1BJ

* Repository:      https://git.soton.ac.uk/qs2g22/meta-marfb
* Support:         mailto:qs2g22@soton.ac.uk

The programs included with the MAR GNU/Linux system are free software;
the exact distribution terms for each program are described in the
license/ and spdx/ folders of the release archives. MAR GNU/Linux is
distributed in the hope that it will be useful, but it comes with
ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law.

=> You  receive this  message  of  the  day  because  of  the  fastinit
   configuration.  To change the runlevel, refer to manpage fastinit(8)
   which is not shipped in this image. Message of the day should not be
   printed to serial output because it will confuse the rover.
=> Heavy serial outputs like this affect performance.
=> Uptime: $(uptime)

Press 'q' to quit pager and continue.

EOF

clear

cat << EOF

Welcome to Minimal Autonomous Rover (MAR) GNU/Linux System!

MAR GNU/Linux is free and open-source software.
Copyright (C) 2024 Qiyang Sun and the MAR Project Maintainers.

The programs included with the MAR GNU/Linux system are free software;
the exact distribution terms for each program are described in the
license/ and spdx/ folders of the release archives. MAR GNU/Linux is
distributed in the hope that it will be useful, but it comes with
ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law.

* Change runlevel before connecting serial to rover.
* To read the full message again, run print_motd.sh.

EOF

sleep 1s
