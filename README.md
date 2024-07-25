# ccp (FKA pycp)
Copy code into the clipboard buffer

I use this by putting this in ~/bin and putting 

export PATH="$PATH:~/bin"

in my .bash_profile

If you have to ask why you'd use this it's probably not for you ;)

Works great with https://github.com/m9e/cllm/tree/main

eg

`ccp file1.py file2.py dir/file3.py && cllm -M azure -m gptp4o -C -p output a completely new version of file1.py that imports the functions from file3.py instead of doing that locally > file1-new.py`

or whatnot


