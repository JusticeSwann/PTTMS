import streamlit as st

def getNumberOfSubmissions(df):
    totalRows = df.shape[0]
    st.metric(label='Submission Total', value=totalRows, delta='+1')
