#! /bin/bash

# extract url from the README on the desktop
URL=`cat /opt/CyberPatriot/README.desktop | grep -wo '\".*\"'`
URL=${URL:1:-1}

# yoink the page
sudo apt install curl
PAGE_CONTENTS=`curl $URL`

# yoink the admins and users start and end lines
ADMINS_START_LINE=`echo $PAGE_CONTENTS | grep -n 'Authorized Adminastrators:' | grep -o '^[0-9]*'`
ADMINS_START_LINE=$((ADMINS_START_LINE + 1))
ADMINS_END_LINE=`echo $PAGE_CONTENTS | grep -n '<b>Authorized Users:</b>' | grep -o '^[0-9]*'`
ADMINS_END_LINE=$((ADMINS_END_LINE - 2))

USERS_START_LINE=`echo $PAGE_CONTENTS | grep -n '<b>Authorized Users:</b>' | grep -o '^[0-9]*'`
USERS_START_LINE=$((USERS_START_LINE + 1))
USERS_END_LINE=`echo $PAGE_CONTENTS | grep -n '<h2>Competition Guidelines:</h2>' | grep -o '^[0-9]*'`
USERS_END_LINE=$((USERS_END_LINE - 3))

# admins has a weird format
# USERNAME (you)
#           password: PASSWORD123!
# USERNAME
#           password: PASSWORD123!
ADMINS=`echo $PAGE_CONTENTS | sed -n "$ADMINS_START_LINE,$ADMINS_END_LINEp"`
ADMIN_NAMES=''
ADMIN_PASSWORDS=''
LINE_INDEX=0
echo $ADMINS | while read line; do
  if [[ $(( LINE_INDEX % 2 )) = 0 ]]; then
    line=`echo $line | grep -o '.*\w'`
    ADMIN_NAMES=`printf "$ADMIN_NAMES\n$line\n"`
  else
    line=`echo $line | grep -o '[^: ]*$'`
    ADMIN_PASSWORDS=`printf "$ADMIN_PASSWORD\n$line\n"`
  fi

  LINE_INDEX=$(($LINE_INDEX + 1))
done

# users has a normal format
# USERNAME
# USERNAME
USER_NAMES=`echo $PAGE_CONTENTS | sed -n "$USERS_START_LINE,$USERS_END_LINEp"`
