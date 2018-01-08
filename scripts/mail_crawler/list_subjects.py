conn = imaplib.IMAP4_SSL("imap.gmail.com", 993)
gmail_user = 'kiran.chandrashekhar'
gmail_pwd = 'gmail_password_here'

conn.login(gmail_user, gmail_pwd)
conn.select()