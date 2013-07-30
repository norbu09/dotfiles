mail setup
==========


todo:
-----

- patch homebrew to make install option for notmuch-deliver
- describe addressbook stuff, either via notmuch or via ldbm or via
both?
- install lbdb (access to MacOS address book)

mutt-kz
-------

- make homebrew package

offlineimap
-----------

is in homebrew, just install and drop in current config

notmuch
-------

- install via homebrew
- run `notmuch setup`

afew
----

`afew` is a python script that can be used to automatically tag mails in
`notmuch`. I am still playing with the config but there is a basic
skeleton in `.config/afew/config`.

Docs on how to set it up are on: https://github.com/teythoon/afew - I
did not get round to bundle it for `homebrew` yet but dependencies like
`dbacl` should be there by now.

Next, setup a hook in the `notmuch` setup to run `afew` automatically
every time we get new mail into `notmuch`. Create a `hooks` directory in your
`notmuch` tree, that would be under your local mail root,
`~/.mail/.notmuch/hooks/` in my case. In there create a file called
`post-new` and put the following couple of lines in there:

    #!/bin/sh
    /usr/local/bin/afew --tag --new

and make the file executable:

    $ chmod +x ~/.mail/.notmuch/hooks/post-new

This hooks will then tag all new mail with the rules set up in your afew
config.

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

----

pointers/references:
http://zzompp.hosting.mbar.fi/gregarius/feed.php?channel=15&iid=42893&y=2009&m=01&d=25
