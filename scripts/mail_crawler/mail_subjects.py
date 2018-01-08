import imaplib

mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login('ayso1sra@gmail.com', '2017\Calico')
mail.list()
mail.select('inbox')

typ, data = mail.search(None, 'ALL')
for num in data[0].split():
   typ, data = mail.fetch(num, '(RFC822)')
   print ('Message %s\n%s\n' % (num, data[0][1]))
mail.close()

mail.logout()
