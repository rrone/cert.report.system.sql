import shutil
import glob
import os
import csv


path = os.path.dirname(os.path.abspath(__file__)) + '/*.csv'
nfiles = 0
nlines = 0


def main():
    global nfiles
    global nlines
    hdr = False

    # with open('crs_certs.csv', 'w') as wfd:
    for f in glob.glob(path):
        nfiles += 1
        mydict = {}
        with open(f, 'r') as fd:
            reader = csv.reader(fd)
            print f
            mydict = dict((rows[0]) for rows in reader)cd
            print mydict


if __name__ == "__main__":
    # execute only if run as a script
    main()

    print('{0} files found; {1} lines read'.format(nfiles, nlines))
