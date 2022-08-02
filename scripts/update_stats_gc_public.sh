#!/bin/bash
rsync -av ovh-front-geomapfish-public:/var/log/nginx/carto-public-2021_lausanne_ch_ssl_access.log.1 /tmp/
echo "checking first and last line of log"
head -n 1 /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 |gawk '{print $4}'
tail -n 1 /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 |gawk '{print $4}'
YESTERDAY_FILTER=$(date --date="1 day ago" +%d/%b/%Y)
grep "$YESTERDAY_FILTER" /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 > /tmp/access_carto_public_lausanne_ssl_yesterday.log
echo "## checking first and last line of yesterday log :"
head -n 1 /tmp/access_carto_public_lausanne_ssl_yesterday.log |gawk '{print $4}'
tail -n 1 /tmp/access_carto_public_lausanne_ssl_yesterday.log |gawk '{print $4}'
DAY=$(date --date="1 day ago" +%d)
MONTH=$(date --date="1 day ago" +%m)
YEAR=$(date --date="1 day ago" +%Y)
echo "SELECT COUNT(*) FROM layer_access_gc_public WHERE year=$YEAR AND month=$MONTH AND day=$DAY;" > /tmp/num_records_for_yesterday.sql
YESTERDAY_NUM_ROWS=$(su -c "psql -qt -f /tmp/num_records_for_yesterday.sql go_layers_stats" postgres)
if (( "$YESTERDAY_NUM_ROWS" > 0 )); then
  echo "## 💥💥 ERROR: the database contains already ${YESTERDAY_NUM_ROWS} entries of logs for yesterday $YESTERDAY_YESTERDAY_FILTER, will stop execution  "
  exit 2
else
  echo "## Cool 🚀✓🚀 the database does not contain yesterday entries of logs (${YESTERDAY_NUM_ROWS}), will try to parse them "
  goParseLog /tmp/access_carto_public_lausanne_ssl_yesterday.log > /tmp/gc_public_layers_yesterday.log
  sort /tmp/gc_public_layers_yesterday.log > /tmp/gc_public_layers_yesterday_sorted.log
  # shellcheck disable=SC2028
  echo "COPY layer_access_gc_public(layer,year,month,day,hour_min,ip_address,referer,user_agent) FROM '/tmp/gc_public_layers_yesterday_sorted.log' DELIMITER E'\t';" >/tmp/insert_yesterday_gc_public.sql
  echo "## Cool 🚀✓🚀 will try inserting yesterday log entries in database..."
  su -c "psql -f /tmp/insert_yesterday_gc_public.sql  go_layers_stats" postgres
  YESTERDAY_NUM_ROWS=$(su -c "psql -qt -f /tmp/num_records_for_yesterday.sql go_layers_stats" postgres)
  echo "## Cool 🚀✓🚀 finished inserting ${YESTERDAY_NUM_ROWS} yesterday log entries in database..."
fi






./goParseLog /tmp/carto-public-2021_lausanne_ch_ssl_access.log.1 > /tmp/gc_public_layers_yesterday.log
sort /tmp/gc_public_layers_yesterday.log > /tmp/gc_public_layers_yesterday_sorted.log
echo "inserting new log entries in database "
psql -c "COPY layer_access_gc_public(layer,year,month,day,hour_min,ip_address,referer,user_agent) FROM '/tmp/gc_public_layers_yesterday_sorted.log' DELIMITER E'\t';" go_layers_stats



echo "## checking first and last line of full log :"
head -n 1 /tmp/access_carto_lausanne_ssl.log |gawk '{print $4}'
tail -n 1 /tmp/access_carto_lausanne_ssl.log |gawk '{print $4}'

