#!/bin/bash
LOG=/root/log/cmdGenerateGoLayersStatsGC.log
CGTIME=`date`
echo "******* BEGIN OF cmdGenerateGoLayersStatsGC at time :${CGTIME}"  >> ${LOG} 2>&1
cd /tmp
cp /root/bin/go-layers-stats/scripts/update_stats_gc_public.sh /tmp/  >> ${LOG} 2>&1
cp /root/bin/go-layers-stats/scripts/update_stats_gc_internal.sh /tmp/  >> ${LOG} 2>&1
echo "******* update_stats_gc_public.sh *******" >> ${LOG} 2>&1
/tmp/update_stats_gc_public.sh >> ${LOG} 2>&1
echo " ++ NOW  layer_access_gc_public contains : " >> ${LOG} 2>&1
su -c "psql -c 'SELECT COUNT(*) FROM layer_access_gc_public;' go_layers_stats " postgres >> ${LOG} 2>&1
echo "******* update_stats_gc_internal.sh *******" >> ${LOG} 2>&1
/tmp/update_stats_gc_internal.sh >> ${LOG} 2>&1
echo " ++ NOW  layer_access_gc_internal contains : " >> ${LOG} 2>&1
su -c "psql -c 'SELECT COUNT(*) FROM layer_access_gc_internal;' go_layers_stats " postgres >> ${LOG} 2>&1
echo "******* generating json files for the web site *******" >> ${LOG} 2>&1
rm /tmp/layers_stats.json
rm /tmp/referrers_stat.json
cp /root/bin/generate_layers_stats_json.sql /tmp
cp /root/bin/generate_referrers_stat_json.sql /tmp
su -c "psql -f generate_layers_stats_json.sql --quiet --tuples-only --output=/tmp/layers_stats.json go_layers_stats" postgres >> ${LOG} 2>&1
su -c "psql -f generate_referrers_stat_json.sql --quiet --tuples-only --output=/tmp/referrers_stat.json go_layers_stats" postgres >> ${LOG} 2>&1
cp /tmp/layers_stats.json /data/html_access/stats/data/layers_stats.json
cp /tmp/referrers_stat.json /data/html_access/stats/data/referrers_stat.json
echo "******* END    cmdGenerateGoLayersStatsGC  at time :${CGTIME}"  >> ${LOG} 2>&1
echo "***************************************************************"  >> ${LOG} 2>&1

