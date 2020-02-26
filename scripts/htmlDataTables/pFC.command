#!/bin/bash
cd ~/Dropbox/_open/_ayso/s1/reports/scripts/htmlDataTables
rm -f ./html/*.csv
python3 processFutureCourses.py ./html/Future_Courses_Report.html