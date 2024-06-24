import streamlit as st
import pandas

def getTotalCovidReports(df):
    totalYes = (df.Covid == 'yes').sum()
    st.metric(label="Total Covid Reports", value=totalYes, delta='0')