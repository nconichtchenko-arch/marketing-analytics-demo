-- Считаем CTR (Click-Through Rate) и ROMI (Return on Marketing Investment)
-- Предполагаем, что все продажи в этот период принесли выручку.
-- (В реальности нужно связывать по UTM-меткам, но для pet-проекта сгенерируем базовую оценку).

WITH revenue_by_date AS (
    -- Берем выручку из нашей витрины fct_sales по дням
    SELECT 
        order_date,
        SUM(total_revenue) AS daily_revenue
    FROM dbt_schema.fct_sales
    GROUP BY order_date
),
campaign_metrics AS (
    -- Считаем CTR для каждой кампании
    SELECT 
        campaign_id,
        campaign_name,
        channel,
        impressions,
        clicks,
        cost,
        start_date,
        end_date,
        -- CTR = (Клики / Показы) * 100
        ROUND((clicks::numeric / NULLIF(impressions, 0)) * 100, 2) AS ctr_percent,
        -- Примерная стоимость клика (CPC)
        ROUND(cost / NULLIF(clicks, 0), 2) AS cpc
    FROM public.marketing_campaigns
)
SELECT 
    c.campaign_name,
    c.channel,
    c.ctr_percent,
    c.cpc,
    c.cost,
    -- Для ROMI нам нужна выручка. Упростим: берем выручку за период кампании.
    -- (В реальном проекте это был бы JOIN по UTM).
    COALESCE((
        SELECT SUM(daily_revenue) 
        FROM revenue_by_date r 
        WHERE r.order_date BETWEEN c.start_date AND c.end_date
    ), 0) AS revenue_attributed,
    -- ROMI = (Выручка - Затраты) / Затраты * 100
    ROUND(
        (COALESCE((
            SELECT SUM(daily_revenue) 
            FROM revenue_by_date r 
            WHERE r.order_date BETWEEN c.start_date AND c.end_date
        ), 0) - c.cost) / NULLIF(c.cost, 0) * 100
    , 2) AS romi_percent
FROM campaign_metrics c
ORDER BY romi_percent DESC;