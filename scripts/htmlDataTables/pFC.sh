#!/bin/zsh

cd ~/Google_Drive.rick.roberts.9/_ayso/s1/reports/scripts/htmlDataTables
source ./venv/bin/activate
rm -f ./html/*.csv
python ./py/processFutureCourses.py ./html/Future_Courses_Report.html
deactivate