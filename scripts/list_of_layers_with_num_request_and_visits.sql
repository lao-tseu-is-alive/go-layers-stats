SELECT max(year), max(month), max(day), max(hour_min)
FROM layer_access_gc_public;
SELECT max(year), max(month), max(day), max(hour_min)
FROM layer_access_gc_internal;


-- list layer count
SELECT layer,
       year,
       month,
       day,
       --date_part('hour', hour_min) as hour,
       COUNT(*)                   as requests_gc_internal,
       COUNT(distinct ip_address) as visits_gc_internal
FROM layer_access_gc_internal
GROUP BY year, month, day, layer --, date_part('hour', hour_min)
ORDER BY layer, year, month, day
--,hour;
--SELECT DISTINCT layer FROM layer_access_gc_internal WHERE month=7 AND day=16 ORDER BY ip_address;
--UNION ALL
-- list count by hour public
SELECT year,
       month,
       day,
       --date_part('hour', hour_min) as hour,
       --layer,
       COUNT(*)                   as requests_gc_public,
       COUNT(distinct ip_address) as visits_gc_public
FROM layer_access_gc_public
GROUP BY year, month, day--, layer -- date_part('hour', hour_min)
ORDER BY year, month, day
--,layer;
-- global query to present list of layers with numbers from gc_internal and gc_public
WITH cte_internal as (SELECT layer,
                             COUNT(*)                   as requests_gc_internal,
                             COUNT(distinct ip_address) as visits_gc_internal
                      FROM layer_access_gc_internal
                      GROUP BY layer
                      ORDER BY layer),
     cte_public as (SELECT layer,
                           COUNT(*)                   as requests_gc_public,
                           COUNT(distinct ip_address) as visits_gc_public
                    FROM layer_access_gc_public
                    GROUP BY layer
                    ORDER BY layer)
SELECT coalesce(cte_internal.layer, cte_public.layer) as layer,
       cte_internal.requests_gc_internal,
       cte_internal.visits_gc_internal,
       cte_public.requests_gc_public,
       cte_public.visits_gc_public
FROM cte_internal
         FULL JOIN cte_public ON cte_public.layer = cte_internal.layer
ORDER BY cte_internal.layer