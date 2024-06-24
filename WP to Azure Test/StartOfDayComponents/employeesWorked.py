import streamlit as st

def getEmployeesWorked(df, coloumn):
    barchartDf = df.groupby([coloumn]).size().reset_index(name='total')
    st.write('Employee Submissions')
    st.bar_chart(barchartDf, x=coloumn, y='total')