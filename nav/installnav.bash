#!/bin/bash
echo "makind dir in /usr/bin/nav"
mkdir /usr/bin/nav

echo "copying nav.bash"
cp nav.bash /usr/bin/nav/nav.bash
chmod -x /usr/bin/nav/nav.bash

echo "making alias for nav-command"
alias nav=". /usr/bin/nav/nav.bash"

echo "if alias not created, try calling:"
echo 'alias nav=". /usr/bin/nav/nav.bash"'
