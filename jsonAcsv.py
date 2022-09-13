import pandas as pd
import json
import csv


#df = pd.read_json(r'Datasets\constructors.json',lines = True)
#df.to_csv(r'Datasets\constructors.csv')

#df = pd.read_json(r'Datasets\drivers.json',lines = True)
#df.to_csv(r'Datasets\drivers.csv')

df = pd.read_json(r'Datasets\pit_stops.json',lines = False)
df.to_csv(r'Datasets\pit_stops.csv')

#df = pd.read_json(r'Datasets\results.json',lines = True)
#df.to_csv(r'Datasets\results.csv')


