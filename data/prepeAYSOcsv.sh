#!/bin/zsh

cd ~/Google_Drive.rick.roberts.9/_ayso/s1/reports/data
cp -f ../20210104/eAYSO* ./

source ../scripts/prep_csv/venv/bin/activate
python ../scripts/prep_csv/py/prep_eayso_csv.py
deactivate