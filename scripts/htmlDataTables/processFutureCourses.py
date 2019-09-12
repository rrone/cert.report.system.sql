from bs4 import BeautifulSoup
import requests
import csv
import sys
import os

from datetime import datetime
import pytz

# reference: https://www.pluralsight.com/guides/extracting-data-html-beautifulsoup
from tzlocal import get_localzone

# define Start Date format
dt_fmt = "%m/%d/%Y %I:%M:%S %p"

# AYSOU use of React/Angular requires login first
# url = "https://aysou.org/LMSAdmin/FutureCoursesReport.aspx"
# Make a GET request to fetch the raw HTML content
# html_content = requests.get(url).text

# so Login to https://aysou.org
# goto https://aysou.org/LMSAdmin/FutureCoursesReport.aspx
# save the web page as html
# and provide it as an argument to this script

if len(sys.argv) == 1:
    print('Syntax: processFutureCourses.py <FutureCoursesReport.html>')
    sys.exit(1)
fname = os.path.splitext(str(sys.argv[1]))[0]

# load the file saved from https://aysou.org/LMSAdmin/FutureCoursesReport.aspx
html_content = open(f"{fname}.html", "r")
# Parse the html content
soup = BeautifulSoup(html_content, "html.parser")

# Get the table in the file
fc_table = soup.find("table")

# Get all the headings of Lists
headings = {}
for tr in fc_table.tbody.find_all("tr"):  # find all tr's from table's tbody
    for td in tr.find_all("th"):  # find all td's from tr's
        heading = td.text
        headings[heading.replace(' ', '_')] = heading.replace(' (UTC)', '')
    break

# remove TimeZone & Registered Learners
for k in list(headings)[-2:]:
    del headings[k]

# Extract the courses
data = []
k = 1
# Get all the rows of table
for tr in fc_table.tbody.find_all("tr"):  # find all tr's from table's tbody
    t_row = []
    for td in tr.find_all("td"):  # find all td's from tr's
        t_row.append(td.text.replace('\n', '').strip())
    if t_row:
        data.append(t_row)

# Convert Start UTC to LocalTime
local_timezone = get_localzone()
for day in data:
    if day:
        start_utc_str = day[2]
        utc_dt = datetime.strptime(start_utc_str, dt_fmt)
        local_dt = utc_dt.replace(tzinfo=pytz.utc).astimezone(local_timezone)
        day[2] = local_dt.strftime(dt_fmt)

# parse data
s1_data = []
for c in data:
    # parse for Pacific Time
    # c[5] = TimeZone
    if c[5].find("Pacific") < 0:
        continue

    # parse for Section 1
    # c[3] = Location
    if c[3].find("1/") != 0 and c[1].find:
        continue

    # parse for courses today or later
    # c[2] = Start Date
    if datetime.strptime(c[2], dt_fmt).date() < datetime.today().date():
        continue

    # remove last two columns: TimeZone & Registered Learners
    s1_data.append(c[:len(c) - 2])

# for Coach Courses
coach_data = []
coach = "Coach"
field = "Field"
# c[0] = ILT Name / c[1] = Session Name
for c in s1_data:
    if ((c[0].find(coach) < 0) and (c[1].find(coach) < 0) and
            (c[0].find(field) < 0) and (c[1].find(field) < 0)):
        continue
    coach_data.append(c)

# for Coach Courses
referee_data = []
ref = "Referee"
# c[0] = ILT Name / c[1] = Session Name
for c in s1_data:
    if (c[0].find(ref) < 0) and (c[1].find(ref) < 0):
        continue
    referee_data.append(c)


# Write all data to CSV File
with open(f"{fname}.csv", 'w', newline='') as out_file:
    writer = csv.writer(out_file, quotechar='\"')
    writer.writerow(list(headings.keys()))
    writer.writerows(data)

# Write coach data to CSV File
with open(f"{fname}.coach.csv", 'w', newline='') as out_file:
    writer = csv.writer(out_file, quotechar='\"')
    writer.writerow(list(headings.keys()))
    writer.writerows(coach_data)

# Write referee data to CSV File
with open(f"{fname}.referee.csv", 'w', newline='') as out_file:
    writer = csv.writer(out_file, quotechar='\"')
    writer.writerow(list(headings.keys()))
    writer.writerows(referee_data)
