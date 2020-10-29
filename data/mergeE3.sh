#!/bin/zsh
cd ~/Dropbox/_open/_ayso/s1/reports/data
source ~/Dropbox/_open/_ayso/s1/reports/scripts/mergeE3/bin/activate
python ../scripts/mergeE3/mergeE3.py
deactivate