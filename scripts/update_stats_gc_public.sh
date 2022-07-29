#!/bin/bash
rsync -av ovh-front-geomapfish-public:/var/log/nginx/carto-public-2021_lausanne_ch_ssl_access.log.1 /tmp/
echo "checking first and last line of log"
head -n 1 /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 |gawk '{print $4}'
tail -n 1 /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 |gawk '{print $4}'
./goParseLog /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 > /tmp/gc_public_layers_yesterday.log
sort /tmp/gc_public_layers_yesterday.log > /tmp/gc_public_layers_yesterday_sorted.log
echo "inserting new log entries in database "
psql -c "COPY layer_access_gc_public(layer,year,month,day,hour_min,ip_address,referer,user_agent) FROM '/tmp/gc_public_layers_yesterday_sorted.log' DELIMITER E'\t';" go_layers_stats