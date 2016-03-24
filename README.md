# rsync-backup
*Linux backup scripts using rsync*

* Initial version copied with thanks from [vigeek.net](http://vigeek.net/linux/bash/rsync-cron-script-with-error-handling).
* Runs rsync with given options. Creates a log file of errors.
* Emails when it's done, either to say it has succeeded or it has failed (and if so, why).

##Usage##

* Install a simple mail client for sending emails- [ssmtp](https://wiki.debian.org/sSMTP) is ideal
* Note if you use gmail with two-factor authentication you will need to generate an app password, see [here](https://support.google.com/accounts/answer/185833) for info
* Rename exclude-file.txt.sample to exclude-file.txt and adjust according to your needs
* Rename rsync_bash.sh.sample to rsync_bash.sh and adjust the options to meet your needs
* Make rsync_bash.sh executable and run from command line to make sure it's working
* Schedule to run when you need it to, using cron

