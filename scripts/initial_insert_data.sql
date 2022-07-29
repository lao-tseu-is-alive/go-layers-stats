TRUNCATE layer_access_gc_internal RESTART IDENTITY;
COPY layer_access_gc_internal(layer,year,month,day,hour_min,ip_address,referer,user_agent) FROM '/home/cgil/cgdev/golang/go-parse-log-uri/gc_internal_layers_sorted.log' DELIMITER E'\t';
TRUNCATE layer_access_gc_internal RESTART IDENTITY;
COPY layer_access_gc_public(layer,year,month,day,hour_min,ip_address,referer,user_agent) FROM '/home/cgil/cgdev/golang/go-parse-log-uri/gc_public_layers_sorted.log' DELIMITER E'\t';

