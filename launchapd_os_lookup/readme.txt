# Warning there is a flaw in this script. You need to run it twice to get the os-version you are looking for.
# I can not seem to unset the variables. So the old variable lingers and that is what is looked up. I have tried
# deleting the temp file it is being sent to and I have also tried the unset command. Let me know if you can help. Thanks.
# If there are obvious mistakes I apologize. I am learning Bash and Python as I go along.
# simple bash script to automate finding the launchpad OS version. For example Focal, jammy, Xenial, Buster, Bionic etc...
# Keep in mind even looking this up manually we can get the wrong OS version information because
# the server may be in a container or it may say it is a Jammy and it really is a Focal etc...
# This is grepping the output of an NMAP port scan. You provide the path,
# NOTE: It requires ddgr and html2text to be installed.
# NOTE: This script will only work on UBUNTU or DEBIAN servers
# NOTE: This is using the nmap output of -oN nmap/path/to/file.nmap. Some people like using -oG. I do not think it matters.
# Does not matter what extension your nmap file has. Does not need one.
# If you are planning on using this script a-lot of the time then you might want to
# hardcode the path to your nmap output file.
# if [ "$val1" == "$val2" ]; then <<< If you get an error with the curly brackets just remove them for variables val1 and val2.
