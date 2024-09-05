# enum_script.sh
### Usage: ./enum_script.sh
I recommend base64 encoding the script and then pasting it into /tmp on the target server then decoding it.
cat enum_script.sh | base64 -w0 > enum_script_encoded
cat enum_script_encoded | base64 -d > enum_script.sh
chmod +x enum_script.sh
./enum_script.sh
### NOTE: I have some commands in the script you might find kind of cool. You should check it out. Peace enjoy!
