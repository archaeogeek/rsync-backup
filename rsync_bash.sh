#!/bin/bash
# Objective:  Handles rSync
# Author Russ Thompson @ viGeek.net
# This script assumes you're using password-less login (via keys).  User/PASS can be added easily via opts.

# Log & Email params...
LOGF="$(pwd)/rsync-results.log"
ETO="jo.k.cook@gmail.com"
ESUB="$(hostname -s) - rSync - FAILURE"
EFILE="msg.txt"

# Make initial log entry...
echo "rSyncd script kicked off at $(date) by $(whoami)" >> $LOGF

# Rsync options
SRC="/"
#EXCLUDE='"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.thumbnails/*","/home/*/.cache/mozilla/*","/home/*/.cache/chromium/*","/home/*/.local/share/Trash/*"'
DEST="/media/jo/SAMSUNG/backup"
OPTS="-aAXv"
EXCLUDEFILE="exclude-file.txt"

# Does copy, but still gives a verbose display of what it is doing (CHANGE THESE)
#OPTS="-rptgvv --remove-sent-files --delete-after"

# This deletes rsync-results.log after xyz (to prevent buildup)
find $LOGF -mtime +30 -exec rm {} \;
# Can also be deleted via size parameters

function trap_clean {
    # Error handling...
    echo "$(hostname) caught error on line $LINENO at $(date +%l:%M%p) via script $(basename $0)" | tee -a $EFILE $LOGF
    echo "Please see the tail end of $LOGF for additional error details...">> $EFILE
    #ssmtp "$ETO" < $EFILE
}

# Defined trap conditions
trap trap_clean ERR SIGHUP SIGINT SIGTERM

# Construct rsync command from variables, echo it to command line then run it
echo "rsync $OPTS --exclude={$EXCLUDE} $SRC $DEST"
rsync $OPTS --exclude-from $EXCLUDEFILE $SRC $DEST 2>> $LOGF

# Fill log with line for easy reading, and send email to say backup ran
echo "--------------------------------------------------------------------------------------------------------------" >> $LOGF
echo "Backup ran at $(date +%l:%M%p)" >> $EFILE
ssmtp "$ETO" < $EFILE

# Cleanup our e-mail template file
sed -i".bak" '5,$d' $EFILE
