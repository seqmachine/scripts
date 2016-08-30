# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

#Tian R. add env Aug 30,2016

#Aug 30, 2016 TianRi
PYTHONPATH="${PYTHONPATH}:/home/tianrui/softwares/biopython-1.67:\
/home/tianrui/.local/lib/python2.7/site-packages:\
/share/software/Base/Python-2.7.9/lib/python2.7/site-packages/"
export PYTHONPATH
