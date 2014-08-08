import smtplib, sys
import email.utils
from email.mime.text import MIMEText

# Create the message
msg = MIMEText(sys.argv[3])
msg['To'] = email.utils.formataddr(('Recipient', 'lojze.blatnik@gmail.com'))
msg['From'] = email.utils.formataddr(('pynotify', 'pynotify@blatnik.org'))
msg['Subject'] = sys.argv[2]

server = smtplib.SMTP('blatnik.org', 8123)
server.set_debuglevel(True) # show communication with the server
try:
    if sys.argv[1] == "email":
        server.sendmail('pynotify@blatnik.org', ['lojze.blatnik@gmail.com'], msg.as_string())
    elif sys.argv[1] == "sms":
        server.sendmail('pynotify@blatnik.org', ['sms@blatnik.org'], msg.as_string())
    else:
        sys.exit(1)
finally:
    server.quit()

