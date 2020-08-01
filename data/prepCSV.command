#!/bin/zsh
cd ~/Dropbox/_open/_ayso/s1/reports/data
source ~/Dropbox/_open/_ayso/s1/reports/scripts/cleaneAYSO/bin/activate
python ../scripts/cleaneAYSO/cleaneAYSO.py
deactivate