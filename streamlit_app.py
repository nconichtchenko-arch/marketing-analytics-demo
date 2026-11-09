import streamlit as st
import pandas as pd
import plotly.express as px
from sqlalchemy import create_engine
import os

# Настройки подключения (из карты памяти)
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "dwh_marketplace",
    "user": "dwh_user",
    "password": "dwh_password",
}

@st.cache_data
def load_data():
    engine = create_engine(
        f"postgresql+psycopg2://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}"
    )
    query = "SELECT * FROM public.marketing_metrics"
    df = pd.read_sql(query, engine)
    return df

def main():
    st.set_page_config(page_title="Marketing Analytics", layout="wide")
    st.title("📊 Маркетинговая аналитика (ROMI & CTR)")
    st.markdown("Анализ эффективности рекламных кампаний на основе данных e-commerce.")

    df = load_data()

    # Фильтруем кампании, где есть выручка (ROMI != -100)
    df_active = df[df['romi_percent'] > -100].copy()

    # Метрики сверху
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Всего кампаний", len(df))
    col2.metric("С выручкой", len(df_active))
    col3.metric("Средний ROMI", f"{df_active['romi_percent'].mean():.1f}%")
    col4.metric("Средний CTR", f"{df_active['ctr_percent'].mean():.2f}%")

    st.markdown("---")

    # График 1: Топ-10 кампаний по ROMI
    st.subheader("🏆 Топ-10 кампаний по ROMI")
    top10 = df_active.nlargest(10, 'romi_percent')
    fig1 = px.bar(
        top10, 
        x='campaign_name', 
        y='romi_percent',
        color='channel',
        title="Самые окупаемые кампании",
        labels={'romi_percent': 'ROMI (%)', 'campaign_name': 'Кампания'}
    )
    st.plotly_chart(fig1, use_container_width=True)

    # График 2: Зависимость CTR от ROMI
    st.subheader("📈 CTR vs ROMI")
    fig2 = px.scatter(
        df_active,
        x='ctr_percent',
        y='romi_percent',
        size='cost',
        color='channel',
        hover_name='campaign_name',
        title="Чем выше CTR, тем выше ROMI?",
        labels={'ctr_percent': 'CTR (%)', 'romi_percent': 'ROMI (%)'}
    )
    st.plotly_chart(fig2, use_container_width=True)

    # Таблица с данными
    st.subheader("📋 Детальные данные")
    st.dataframe(df_active.sort_values('romi_percent', ascending=False), use_container_width=True)

if __name__ == "__main__":
    main()