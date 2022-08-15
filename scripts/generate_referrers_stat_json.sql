-- BEGIN generate the referrers_stat.json file
WITH cte_internal as (SELECT COUNT(*)                                                                 as count_internal,
                             split_part(split_part(replace(referer, 'https://', ''), '?', 1), '/', 1) as referrer
                      FROM layer_access_gc_internal
                      GROUP BY split_part(split_part(replace(referer, 'https://', ''), '?', 1), '/', 1)
                      ORDER BY 1 DESC),
     cte_public as (SELECT COUNT(*)                                                                 as count_public,
                           split_part(split_part(replace(referer, 'https://', ''), '?', 1), '/', 1) as referrer
                    FROM layer_access_gc_public
                    GROUP BY split_part(split_part(replace(referer, 'https://', ''), '?', 1), '/', 1)
                    ORDER BY 1 DESC)
SELECT coalesce(array_to_json(array_agg(f)), '[]') AS referrers_stats
FROM (SELECT coalesce(cte_internal.referrer, cte_public.referrer) as referrer,
             cte_internal.count_internal,
             cte_public.count_public
      FROM cte_internal
               FULL JOIN cte_public ON cte_public.referrer = cte_internal.referrer
      ORDER BY cte_internal.referrer) as f;
-- END generate the referrers_stat.json file