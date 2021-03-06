import argparse
import os
import pandas as pd

#Optional argument specifying the base path to the csv files
parser = argparse.ArgumentParser()
parser.add_argument('--csvpath', default="")
args = parser.parse_args()

def read_acs_data(file_path):
    return pd.read_csv(file_path,
            quotechar='"',
            header=0,
            skiprows=[1], #This row is just some metadata describing the variable
            skipinitialspace=True)

population_data = read_acs_data(os.path.join(args.csvpath, "ACS_12_3YR_DP05_with_ann.csv"))
degree_data = read_acs_data(os.path.join(args.csvpath, "ACS_12_3YR_C15010_with_ann.csv"))

merged_data = population_data.merge(degree_data, on="GEO.id")
engineer_counts = pd.DataFrame.from_items([
    ('geo_id', 'US' + merged_data['GEO.id2_x'].map("{:02}".format)), #Census data has a leading 0 on the geo ids
    ('state_name', merged_data['GEO.display-label_x']),
    ('STEM_count', merged_data['HD01_VD02'] + merged_data['HD01_VD03']),
    ('total_population', merged_data['HC01_VC03']),
    ])
engineer_counts.set_index(['geo_id'], inplace=True)

#Adjust the STEM count by dividing by that state's population
#Multiply by 1000 to get the number of engineers per 1000 people
engineer_counts['adjusted_STEM_count'] = (1000 * engineer_counts['STEM_count']) / engineer_counts['total_population']
#Rescale for a max of 1
engineer_counts['rebased_adjusted_STEM_count'] = engineer_counts['adjusted_STEM_count'] / engineer_counts['adjusted_STEM_count'].max()

engineer_counts.to_json('engineer_counts.json')
engineer_counts.to_csv('engineer_counts.csv')
