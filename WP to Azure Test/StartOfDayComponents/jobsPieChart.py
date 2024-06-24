import streamlit as st
import plotly.express as px

def getJobsPieChart(df):
    pieChartDf = df.groupby(['Job Name']).size().reset_index(name='Total')
    fig = px.pie(pieChartDf, values='Total',names='Job Name', title='Workload Distribution', height=340)
    st.plotly_chart(fig, theme=None)