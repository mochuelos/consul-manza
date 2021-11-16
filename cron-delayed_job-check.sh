#!/bin/bash
#* * * * * /bin/bash -l -c '/home/consul/cron-delayed_job-check.sh'
PATH=/usr/sbin:/usr/bin:/sbin:/bin
if ! $(ps -ef | grep -v grep | grep "delayed_job.")
then
    source /home/consul/.rvm/scripts/rvm && cd /home/consul/consul/current && RAILS_ENV=production bin/delayed_job -n 2 restart
    curl -s --user 'api:SENDING_KEY \
        https://api.eu.mailgun.net/v3/DOMAIN/messages \
        -F from='FROM_ADDRESS' \
        -F to='TO_ADDRESS' \
        -F subject='delayed_job restarted' \
        -F text='delayed_job restarted'
fi
con
