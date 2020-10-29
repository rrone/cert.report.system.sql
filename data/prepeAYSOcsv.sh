#!/bin/zsh
cd ~/Google_Drive.rick.roberts.9/_ayso/s1/reports/data
source ../scripts/prep_csv/venv/bin/activate
python ../scripts/prep_csv/py/prep_csv.py
deactivate