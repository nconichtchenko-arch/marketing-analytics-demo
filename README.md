# 📊 Marketing Analytics Demo (ROMI & CTR)

Pet-проект: анализ эффективности рекламных кампаний на основе данных e-commerce. Демонстрирует навыки расчета ключевых маркетинговых метрик (CTR, CPC, ROMI) и визуализации данных.

## 📸 Скриншоты

**1. Общие метрики и Топ-10 кампаний по ROMI:**

![Метрики](assets/dashboard_metrics.png)

**2. Зависимость CTR от ROMI:**

![CTR vs ROMI](assets/dashboard_scatter.png)

**3. Детальная таблица с показателями:**

![Таблица](assets/dashboard_table.png)

## 🎯 Зачем это

В маркетинговой аналитике важно не просто посчитать клики, а понять, **какая кампания приносит деньги**. Этот проект показывает, как из сырых данных о показах, кликах и затратах получить **ROMI** (Return on Marketing Investment) и сравнить эффективность разных каналов (Telegram, VK, Email, Google Ads).

## 🏗 Архитектура

```mermaid
graph LR
    subgraph DWH ["PostgreSQL (dwh_marketplace)"]
        Sales["dbt_schema.fct_sales<br/>(выручка по дням)"]
        Campaigns["public.marketing_campaigns<br/>(показы, клики, затраты)"]
    end

    subgraph Transform ["SQL-трансформация"]
        Metrics["public.marketing_metrics<br/>(CTR, CPC, ROMI)"]
    end

    subgraph App ["Streamlit App"]
        UI["Дашборд<br/>(Plotly + таблица)"]
    end

    Sales --> Metrics
    Campaigns --> Metrics
    Metrics --> UI

    classDef db fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px;
    classDef transform fill:#fff3e0,stroke:#e65100,stroke-width:2px;
    classDef app fill:#f3e5f5,stroke:#4a148c,stroke-width:2px;
    
    class Sales,Campaigns db;
    class Metrics transform;
    class UI app;
```

## 📂 Структура

```
marketing-analytics-demo/
├── sql/
│   ├── 01_init_campaigns.sql       # Генерация тестовых кампаний
│   └── 02_marketing_metrics.sql    # Расчет CTR, CPC, ROMI
├── app/
│   ├── __init__.py
│   └── streamlit_app.py            # Дашборд (Streamlit + Plotly)
├── assets/                         # Скриншоты для README
├── README.md
└── requirements.txt
```

## 🚀 Запуск

### 1. Инициализация данных
Выполни SQL-скрипты в PostgreSQL (база `dwh_marketplace`):
```sql
-- Создание таблицы кампаний
\i sql/01_init_campaigns.sql

-- Создание витрины с метриками
\i sql/02_marketing_metrics.sql
```

### 2. Запуск дашборда
```bash
pip install streamlit plotly pandas sqlalchemy psycopg2-binary
streamlit run app/streamlit_app.py
```

Дашборд будет доступен по адресу `http://localhost:8501`.

## 📈 Метрики (расшифровка)

| Метрика | Расшифровка (англ.) | Формула | Что показывает (по-русски) |
| :--- | :--- | :--- | :--- |
| **CTR** | Click-Through Rate | (Клики / Показы) * 100 | **Кликабельность.** Процент людей, которые кликнули на рекламу после того, как её увидели. |
| **CPC** | Cost Per Click | Затраты / Клики | **Стоимость клика.** Сколько денег ты платишь за один переход по рекламе. |
| **ROMI** | Return on Marketing Investment | (Выручка - Затраты) / Затраты * 100 | **Окупаемость рекламы.** Если ROMI > 0 — реклама принесла больше, чем потратили. Если < 0 — сработали в минус. |
| **AARRR** | Acquisition, Activation, Retention, Referral, Revenue | — | **Воронка продаж.** Путь клиента: как узнал -> зашел -> купил -> вернулся -> порекомендовал. |
| **LTV** | Lifetime Value | — | **Пожизненная ценность клиента.** Сколько денег приносит один клиент за все время работы с тобой. |
| **CAC** | Customer Acquisition Cost | — | **Стоимость привлечения клиента.** Сколько стоит заполучить одного нового клиента. (Если LTV > CAC — бизнес работает). |

## 📊 Результаты (пример)

- **Кампания 1 (Telegram):** ROMI = 29 609%, CTR = 10.83%, CPC = 5.82 руб.
- **Кампания 24 (Email):** ROMI = 20 526%, выручка = 4.3 млн.
- **Кампания 9 (VK):** ROMI = 14 308% (при очень низком CTR и высоком CPC).

## 🔗 Связанные проекты

- [`marketplace-dwh-analytics`](https://github.com/nconichtchenko-arch/marketplace-dwh-analytics) — источник данных (fct_sales).
- [`data-governance-platform`](https://github.com/nconichtchenko-arch/data-governance-platform) — управление данными.
- [`ecommerce-analytics-rfm`](https://github.com/nconichtchenko-arch/ecommerce-analytics-rfm) — RFM-анализ.

## 📫 Контакты

- **GitHub:** [github.com/nconichtchenko-arch](https://github.com/nconichtchenko-arch)
- **Email:** pavloni@mail.ru
- **Формат работы:** удалённо
