-- =========================================================
-- 01_init_campaigns.sql
-- Генерация тестовых данных по рекламным кампаниям
-- (для pet-проекта Marketing Analytics Demo)
-- =========================================================

DROP TABLE IF EXISTS public.marketing_campaigns;

CREATE TABLE public.marketing_campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50), -- 'Google Ads', 'VK', 'Telegram', 'Email'
    start_date DATE,
    end_date DATE,
    impressions INTEGER, -- Показы
    clicks INTEGER,      -- Клики
    cost NUMERIC(10, 2)  -- Затраты (в рублях)
);

-- Генерируем случайные данные за 2011 год (в диапазоне данных fct_sales)
TRUNCATE TABLE public.marketing_campaigns RESTART IDENTITY;

INSERT INTO public.marketing_campaigns (campaign_name, channel, start_date, end_date, impressions, clicks, cost)
SELECT 
    'Кампания ' || gs,
    (ARRAY['Google Ads', 'VK', 'Telegram', 'Email'])[floor(random() * 4 + 1)],
    (DATE '2011-01-01' + (random() * 300)::int),
    (DATE '2011-01-01' + (random() * 330)::int),
    floor(random() * 50000 + 10000)::int,
    floor(random() * 2000 + 100)::int,
    floor(random() * 50000 + 5000)::numeric
FROM generate_series(1, 50) AS gs;

-- Проверка
SELECT * FROM public.marketing_campaigns LIMIT 5;