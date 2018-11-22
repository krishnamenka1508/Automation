[program:rollup_order]
command= php /var/www/jal/php/queue_consumer/rollup/order.php
numprocs=1
process_name = %(program_name)s_%(process_num)02d
directory=/tmp
redirect_stderr=true ; redirect proc stderr to stdout (default false)
stdout_logfile_maxbytes=1MB ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=0
;stdout_logfile=/etc/supervisor/log/%(program_name)s.output
;environment=GEARMAN_USER=gearman
autostart=true
autorestart=true
user=root
stopsignal=KILL

