import sys
import os
import glob
import csv

rptdata = []
csvdata = []


def read_csv(f):
    global csvdata, header, headerkeys

    with open(f, 'r') as fd:
        reader = csv.DictReader(fd)

        if len(csvdata) == 0:
            csvdata = next(reader)[1:]

            for item in csvdata:
                csvdata[0]item = item.replace('"', '')

        for row in reader:
            csvdata[] = row
            print csvdata


def print_csv():
    global header
    global rptdata

    print(header)
    for row in csvdata:
        print(', '.join(row))


def write_rpt(f):
    global header
    global rptdata

    rptfile = open(f, 'w')

    rptfile.write(''.join(header))
    for row in rptdata:
        rptfile.write(''.join(row))


def print_rpt():
    global header
    global rptdata

    print(''.join(header))
    for row in csvdata:
        print(''.join(row))


def process_csv(path):
    global rptdata, headerkeys

    if os.path.isdir(path):
        print('is folder')
        for f in glob.glob(path + '/*.csv'):
            print f
            read_csv(f)
    else:
        print('is file')

        print path
        read_csv(path)

    # rptdata = sorted(iter(csvdata), key=lambda x: (x[headerkeys['AYSOID']]))
    # print(rptdata)

    # write_rpt('report.highest.csv')


if __name__ == "__main__":
    # execute only if run as a script
    if len(sys.argv) == 0:
        print ("SYNTAX: python process_csv [csv_file or csv_folder] ")
    else:
        sys.argv[1] = os.path.dirname(os.path.realpath(__file__)) + '/' + sys.argv[1]

        process_csv(sys.argv[1])

        print_rpt()
