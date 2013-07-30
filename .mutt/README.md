mail setup
==========

- install mutt (MUA)
- install offlineimap (IMAP sync)
- install lbdb (access to MacOS address book)
- install nothingmutch
- install afew

still missing stuff (at least)
- imapfilter (-> done, write about tagging)
- smtp stuff (-> done document how)

pointers/references:
http://zzompp.hosting.mbar.fi/gregarius/feed.php?channel=15&iid=42893&y=2009&m=01&d=25

todo:
-----

- write propper doku (blog post or such)

Postfix on MacOS
----------------

Postfix is installed on MacOS and configured in an interesting way. If
you run sendmail from the commandline it wakes up Postfix and sends
mail, all you need to do is configure postfix that it uses SMTP_AUTH to
authenticate against a relay host. This is the config snippet you have
to add to `/etc/postfix/main.cf`

    relayhost = MAILSERVER OF YOUR ISP OR YOUR OWN
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_sasl_mechanism_filter = login

and the contents of `/etc/postfix/sasl_passwd` looks like this:

    MAILSERVER OF YOUR ISP OR YOUR OWN  username:password

Make sure you protect it with a bit of file system security:

    $ sudo chown root:wheel /etc/postfix/sasl_passwd
    $ sudo chmod 600 /etc/postfix/sasl_passwd

and compile the map with postmap into the postfix database format:

    $ sudo postmap /etc/postfix/sasl_passwd

after that you should be able to send mail. if you want to see your mail
going out you can run `colortail` with my color sceme like this:

    $ colortail -f -k ~/.colortail/conf.maillog /var/log/mail.log

Sending mail should be sorted with this setup.
