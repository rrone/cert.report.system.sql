# -------------------------------------------------------------------------------
# Name:        read_email.py
# Purpose:     Retrieve All the emails from Gmail
#
# Author:      Kiran Chandrashekhar
#
# Created:     20/06/2016
# Copyright:   (c) kiran 2016
# Licence:      In the spirit of sharing knowledge and happiness,
#               You can copy, edit, share
# -------------------------------------------------------------------------------
# Search for relevant messages
# see http://tools.ietf.org/html/rfc3501#section-6.4.5

import sys
# import os
# import re
import imaplib
import email
import csv
from datetime import datetime, timedelta

# # Read only emails from last 3 days
no_days_query = 365

server = "imap.gmail.com"
port_num = 993


def read_email1(guser, gpwd):
    k = 0
    conn = imaplib.IMAP4_SSL(server, port_num)
    conn.login(guser, gpwd)
    conn.select()

    # Check status for 'OK'
    # status, all_folders = conn.list()

    folder_to_search = 'AYSO System Problem Reports'
    # folder_to_search = 'All Mail'

    # Check status for 'OK'
    status, select_info = conn.select(folder_to_search)

    if status == 'OK':
        today = datetime.today()
        cutoff = today - timedelta(weeks=52)

        from_email = 'support@ayso.org'
        # from_email = 'contact@sapnaedu.in'

        search_key = from_email + " after:" + cutoff.strftime('%Y/%m/%d')

        status, message_ids = conn.search(None, 'X-GM-RAW', search_key)

        with open('mail_subjects.csv', 'w') as csvfile:
            writer = csv.writer(csvfile)

            for mailid in message_ids[0].split():
                status, data = conn.fetch(mailid, '(RFC822)')

                email_msg = email.message_from_string(data[0][1])

                # Print all the Attributes of email message like Subject,
                # print email_msg.keys()

                subject = email_msg['Subject']
                sender_email = email_msg['From']
                sent_to_email = email_msg['To']
                date_email = email_msg['Date']

                line = "{} | {} | {} | {}"
                print line.format(date_email, sender_email, sent_to_email, subject)
                writer.writerow(line.format(date_email, sender_email, sent_to_email, subject))
                k += 1
            csvfile.close()
            conn.close()

            return k

    else:
        print status
        print select_info
        print "Error"

        conn.close()

        return 0


if __name__ == '__main__':
    # Gmail Configuration
    gmail_user = 'ayso1sra'
    gmail_pwd = '2017\Calico'

    ret = read_email1(gmail_user, gmail_pwd)
