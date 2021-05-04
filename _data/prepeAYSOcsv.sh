#!/bin/zsh

cd "$(dirname "$0")"

cp -f ../__sports_connect_reports/20210104.eAYSO.archive/eAYSO* ./

source ../scripts/venv/bin/activate

python ../scripts/prep_eayso_csv/py/prep_eayso_csv.py

deactivate