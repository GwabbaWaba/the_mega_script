#! /bin/bash

# extract url from the README on the desktop
URL=`cat /opt/CyberPatriot/README.desktop | grep -wo '\".*\"' | grep -woE '[^"]*'`
echo $URL

# yoink the page
PAGE_CONTENTS=`wget -O - $URL`

echo $PAGE_CONTENTS > page.html

# yoink the admins and users start and end lines
ADMINS=`echo $PAGE_CONTENTS | grep -oE "Authorized Administrators:(.+)Authorized Users" | grep -oE '\S+( \(you\))?' | sed G` #.*<b>Authorized Users:</b>'`

echo $ADMINS > admins.txt

LINE_INDEX=0
for i in $ADMINS
do
  if [ $line = 'Authorized' ] || [ $line = '(you)' ]
  if [[ $(( LINE_INDEX % 3 )) = 0 ]]; then
    echo $i
    ADMIN_NAMES="$ADMIN_NAMES\n$line"
  elif [[ $(( LINE_INDEX % 3 )) = 1 ]]; then
    printf ""
  else
    line=`echo $line | grep -o '[^: ]*$'`
    ADMIN_PASSWORDS=`printf "$ADMIN_PASSWORD\n$line\n"`
  fi

  LINE_INDEX=$(($LINE_INDEX + 1))
done

exit

# USERS_START_LINE=`echo $PAGE_CONTENTS | grep -n '<b>Authorized Users:</b>' | grep -o '^[0-9]*'`
# USERS_START_LINE=$((USERS_START_LINE + 1))
# USERS_END_LINE=`echo $PAGE_CONTENTS | grep -n '<h2>Competition Guidelines:</h2>' | grep -o '^[0-9]*'`
# USERS_END_LINE=$((USERS_END_LINE - 3))

# admins has a weird format
# USERNAME (you)
#           password: PASSWORD123!
# USERNAME
#           password: PASSWORD123!
ADMIN_NAMES=''
ADMIN_PASSWORDS=''
LINE_INDEX=0
echo $ADMINS | while read line; do
  if [[ $(( LINE_INDEX % 3 )) = 0 ]]; then
    echo $line
    ADMIN_NAMES="$ADMIN_NAMES\n$line"
  elif [[ $(( LINE_INDEX % 3 )) = 1 ]]; then
    printf ""
  else
    line=`echo $line | grep -o '[^: ]*$'`
    ADMIN_PASSWORDS=`printf "$ADMIN_PASSWORD\n$line\n"`
  fi

  LINE_INDEX=$(($LINE_INDEX + 1))
done

echo $ADMIN_NAMES

# users has a normal format
# USERNAME
# USERNAME
# USER_NAMES=`echo $PAGE_CONTENTS | sed -n "$USERS_START_LINE,$USERS_END_LINEp"`
