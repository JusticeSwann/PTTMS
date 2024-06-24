import streamlit as st
from st_pages import Page, show_pages, add_page_title
import transfromData as td

from StartOfDayComponents import employeesWorked
from StartOfDayComponents import numberOfSubmissions
from StartOfDayComponents import totalCovidReports
from StartOfDayComponents import employeesWithCovidSympthoms
from StartOfDayComponents import jobsPieChart


st.set_page_config(
    page_title='Data Analytics Dashboard',
    page_icon='📈',
    layout='wide'
)


st.sidebar.header('Filters')

sidebarCol1,sidebarCol2 = st.columns([1,1])
with sidebarCol1:
    startDate = st.sidebar.date_input(label='Start Date',)
with sidebarCol2:
    endDate = st.sidebar.date_input(label='End Date')

startDateStr = startDate.strftime('%d/%m/%Y')
endDateStr = endDate.strftime('%d/%m/%Y')

st.write(startDateStr)

def filterByDate(df):
    startDateStr = startDate.strftime('%d/%m/%Y')
    endDateStr = endDate.strftime('%d/%m/%Y')

    startOfDayDf = td.getStartOfDay()
    filteredStartOfDayDf = startOfDayDf[(startOfDayDf['Date'] >= startDateStr) & (startOfDayDf['Date'] <= endDateStr)]


startOfDayDf = td.getStartOfDay()
filteredStartOfDayDf = startOfDayDf[(startOfDayDf['Date'] >= startDateStr) & (startOfDayDf['Date'] <= endDateStr)]

st.header("Start of Day")

st.dataframe(filteredStartOfDayDf)

leftCol,rightCol = st.columns([1,1])
col1,col2 = leftCol.columns([1,1])


with leftCol:
    with col1:
        numberOfSubmissions.getNumberOfSubmissions(filteredStartOfDayDf)
        totalCovidReports.getTotalCovidReports(filteredStartOfDayDf)
    with col2:
        employeesWorked.getEmployeesWorked(filteredStartOfDayDf,'Completed By')
        
        
with rightCol:
    jobsPieChart.getJobsPieChart(filteredStartOfDayDf)




st.header('Vehicle Inspection')
vehicleInspectionDf = td.getVehicleInspection()
filteredvehicleInspectionDf = vehicleInspectionDf[(vehicleInspectionDf['Date'] >= startDateStr) & (vehicleInspectionDf['Date'] <= endDateStr)]

st.dataframe(filteredvehicleInspectionDf)