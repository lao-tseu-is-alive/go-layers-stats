--SELECT month, day, max(hour_min),  count(*) FROM   layer_access_gc_internal WHERE year = 2022 GROUP BY month, day ORDER BY month DESC, day DESC ;
--SELECT month, day, max(hour_min),  count(*) FROM   layer_access_gc_public WHERE year = 2022 GROUP BY month, day ORDER BY month DESC, day DESC  ;

-- BEGIN generate the layers_stat.json file
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
SELECT coalesce(array_to_json(array_agg(f)), '[]') AS layers_stats
FROM (SELECT coalesce(cte_internal.layer, cte_public.layer) as layer,
             cte_internal.requests_gc_internal,
             cte_internal.visits_gc_internal,
             cte_public.requests_gc_public,
             cte_public.visits_gc_public
      FROM cte_internal
               FULL JOIN cte_public ON cte_public.layer = cte_internal.layer
      ORDER BY cte_internal.layer) as f;
-- END  generate the layers_stat.json file