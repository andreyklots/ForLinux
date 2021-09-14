#!/bin/bash
echo "this file needs to be run with"
echo "chmod a=x installnav.bash"
echo "then call:"
echo "sudo ./installnav.bash"

echo ""

echo "copying nav"
cp nav.bash /usr/bin/nav/nav
chmod a=x nav

echo ""

echo "making alias for nav-command"
alias nv=". nav"

echo ""

echo "alias created: nv"
echo 'if failed, try: alias nv=". nav"'
