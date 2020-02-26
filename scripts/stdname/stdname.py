import sys
import os
import glob
import shutil
import ntpath

vagrant_dir = "/Users/rick/Library/Application Support/com.clickontyler.VirtualHostX/VirtualHostX/crs_csv"


def path_folder(path):
    head, tail = ntpath.split(path)

    return head, tail or ntpath.basename(head)


def copy_rename(old_f, new_file_name):

    dst_dir = vagrant_dir

    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)

    dst_f = os.path.join(dst_dir, new_file_name)

    print '    {}'.format(dst_f)
    shutil.copy(old_f, dst_f)


def stdname(f):

    # expected filename format: 20171114.1u.636462865736685883.csv
    path = f.split(
        '.'
    )

    f2 = 'file.csv'

    if len(path) == 2:
        f2 = path
    elif len(path) > 2:
        f2 = path[1] + '.csv'

    copy_rename(f, f2)


def process_csv(path):

    if os.path.isdir(path):
        print 'Processing {}/*.csv...'.format(path)
        for f in glob.glob(path + '/*.csv'):
            stdname(f)
    else:
        print 'Processing {}...'.format(path)
        stdname(path)


if __name__ == "__main__":
    # execute only if run as a script
    if len(sys.argv) == 0:
        print ("SYNTAX: python process_csv [csv_file or csv_folder] ")
    else:
        # sys.argv[1] = os.path.dirname(os.path.realpath(__file__)) + '/' + sys.argv[1]

        process_csv(sys.argv[1])
