#!/bin/sh

MOVEDIR=/home/pi/
TRANSMISSION_USER=$USERNAME
TRANSMISSION_PASS=$PASSWORD
TORRENTLIST=`transmission-remote -n $TRANSMISSION_USER:$TRANSMISSION_PASS --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=' ' --fields=1`


for TORRENTID in $TORRENTLIST
do
    echo "$(date) * * * * * Operations on torrent ID $TORRENTID starting. * * * * *"

    TORRENT_INFO=`transmission-remote -n $TRANSMISSION_USER:$TRANSMISSION_PASS --torrent $TORRENTID --info`
    DL_COMPLETED=`echo $TORRENT_INFO | grep "Percent Done: 100%"`
    STATE_STOPPED=`echo $TORRENT_INFO | grep -o "State: Stopped\|Finished\|Idle"`
    TORRENT_RATIO=`echo $TORRENT_INFO | grep "Ratio:" | awk '{ print $2 }'`

    # if [ "$DL_COMPLETED" != "" ] && [ "$STATE_STOPPED" != "" ] && [ ${TORRENT_RATIO%.*} -ge 1 ];
        if [[ "$DL_COMPLETED" != "" ]];
        then
        echo "$(date) Torrent #$TORRENTID is completed."
        echo "$(date) Moving downloaded file(s) to $MOVEDIR."
        transmission-remote -n $TRANSMISSION_USER:$TRANSMISSION_PASS --torrent $TORRENTID --move $MOVEDIR
        echo "$(date) Removing torrent from list."
        transmission-remote -n $TRANSMISSION_USER:$TRANSMISSION_PASS --torrent $TORRENTID --remove
    else
        echo "$(date) Torrent #$TORRENTID is not completed. Ignoring. $DL_COMPLETED : $STATE_STOPPED, user: $TRANSMISSION_USER"
    fi
        echo "$(date) * * * * * Operations on torrent ID $TORRENTID completed. * * * * *"
done