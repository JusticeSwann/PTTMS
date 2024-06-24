import GetDataFromWp as wp

wpDf = wp.getDataFromWpFluentFroms() 

def getStartOfDay():
    cleanDf = wpDf.loc[wpDf['form_id'] == 6]
    transformedDf = cleanDf.pivot_table(index='submission_id', columns='field_name', values='field_value', aggfunc=lambda x: ' '.join(x)).sort_index()
    renamedDf = transformedDf.rename(columns={
        'input_text' : 'Job Name',
        'input_text_1': 'Submitted By',
        'input_text_2': 'Supervisor',
        'datetime': 'Date',
        'input_radio': 'Injuries',
        'input_radio_1': 'Fevers',
        'input_radio_2': 'Covid',
        'input_radio_3' : 'Visited COVID HOT areas',
        'input_radio_4' : 'Social Distancing',
        'dropdown' : 'Completed By'
    })
    
    return(renamedDf)

def getVehicleInspection():
    cleanDf = wpDf.loc[wpDf['form_id'] == 9]
    transformedDf = cleanDf.pivot_table(index='submission_id', columns='field_name', values='field_value', aggfunc=lambda x: ' '.join(x)).sort_index()
    renamedDf = transformedDf.rename(columns={
        'datetime': 'Date',
        'dropdown' : 'Completed By',
        'input_text' : 'Supervisor',
        'input_text_1' : 'Job Name',
        'input_text_2' : 'Company Name',
        'checkbox_1' : 'Headlights',
        'checkbox' : 'Tail Lights',
        'checkbox_2' : 'Turn Indicator Lights',
        'checkbox_3' : 'Stop Lights',
        'checkbox_4' : 'Brakes',
        'checkbox_5' : 'Emergency/Parking Brake',
        'checkbox_6' : 'Steering Mechanism',
        'checkbox_7' : 'Ball joints',
        'checkbox_8' : 'Tie Rods',
        'checkbox_9' : 'Rack & Pinion',
        'checkbox_10': 'Blushings',
        'checkbox_11': 'Windshield',
        'checkbox_12': 'Rear Window and Other Glass',
        'checkbox_13': 'Windshield Wipers',
        'checkbox_14': 'Front Seat Adjustment',
        'checkbox_15': 'Doors',
        'checkbox_16': 'Horns',
        'checkbox_17': 'Speedometer',
        'checkbox_18': 'Bumpers',
        'checkbox_19': 'Muffler and Exhaust System',
        'checkbox_20': 'Tires',
        'checkbox_21': 'Interior and Exterior Rear View Mirrors',
        'checkbox_22': 'Safty Belts'

    })
    
    return(renamedDf)





