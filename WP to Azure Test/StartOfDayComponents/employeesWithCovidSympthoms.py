import streamlit as st

def getEmployeesWithCovidSymthoms(df):
    atRiskEmployees = df[df.Covid == 'yes']['Completed By'].dropna()

    st.write('Employees with Covid Symthoms')
    st.dataframe(atRiskEmployees)
    