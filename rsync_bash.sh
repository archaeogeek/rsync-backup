#!/bin/sh
# Objective:  Handles rSync
# Author Russ Thompson @ viGeek.net
# This script assumes you're using password-less login (via keys).  User/PASS can be added easily via opts.

# Log & Email parms...
LOGF="$(pwd)/rsync-results.log"
ETO"whatever@email.com"
ESUB="$(hostname -s) - rSync - FAILURE"
EFILE="tmpemail.txt"

# Make initial log entry...
echo "rSyncd script kicked off at $(date) by $(whoami)" >> $LOGF

# Remote host machine name (supports multiple entries)
REMOTE_SERVERS="69.69.69.69"

# Directory to copy from on the source machine.
SRCDIR="/path/to/source/"

# Directory to copy to on the destination machine.
DESTDIR="/path/to/destination"

# Path to SSH
SSH=/usr/bin/ssh

# Does copy, but still gives a verbose display of what it is doing (CHANGE THESE)
OPTS="-rptgvv --remove-sent-files --delete-after"

# This deletes rsync-results.log after xyz (to prevent buildup)
find $LOGF -mtime +30 -exec rm {} \;
# Can also be deleted via size paramaters

function trap_clean {
    # Error handling...
    echo -e "$(hostname) caught error on line $LINENO at $(date +%l:%M%p) via script $(basename $0)" | tee -a $EFILE $LOGF
    echo -e "Please see the tail end of $LOGF for additional error details...">> $EFILE
    /bin/mail -s "$ESUB" "$EADDY" < $EFILE
    # Cleanup our temp e-mail file
    rm -f $EFILE
}

# Defined trap conditions
trap trap_clean ERR SIGHUP SIGINT SIGTERM

# Determine that files exist
if ls $SRCDIR ; then
  for REMOTE in $REMOTE_SERVERS
  do
      VAR=`ping -s 1 -c 1 $REMOTE > /dev/null; echo $?`
      if [ $VAR -eq 0 ]; then
      echo "rsync $OPTS $REMOTE::$SRCDIR $DESTDIR"
      rsync -e "$SSH" $OPTS $SRCDIR $REMOTE::$DESTDIR 2>> $LOGF
  else
      echo "Cannot connect to $REMOTE." >> $LOGF
      fi
  done
else
  echo "rSync script did not run : no files present" >> $LOGF
fi

# Fill log with line for easy reading...
echo "--------------------------------------------------------------------------------------------------------------" >> $LOGF
Comments are closed.