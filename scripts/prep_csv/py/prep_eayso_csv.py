import pandas
import os

version = '2020.10.21.00'

cwd = os.getcwd()
path = cwd + '/'

files = [
    'eAYSO.MY2016.certs.csv',
    'eAYSO.MY2017.certs.csv',
    'eAYSO.MY2018.certs.csv',
    'eAYSO.MY2019.certs.csv'
]

for file in files:
    df = pandas.read_csv(path + file, skip_blank_lines=True, low_memory=False)
    df['Street'] = df['Street'].str.replace('"', '')
    df['CertDate'] = pandas.to_datetime(df['CertDate'])
    df.to_csv(path + file, index=False)

infile = '1.csv'
outfile = '1.txt'
df = pandas.read_csv(path + infile, encoding="ISO-8859-1", skip_blank_lines=True, low_memory=False)
df['Date of Last AYSO Certification Update'] = pandas.to_datetime(df['Date of Last AYSO Certification Update'],
                                                                  format="%m/%d/%Y %H:%M:%S %p")
df['Date of Last AYSO Certification Update'] = df['Date of Last AYSO Certification Update'].dt.date
print('Writing ' + outfile + '...')
df.to_csv(path + outfile, sep='\t', index=False)
os.remove(path + infile)
print('Success')
