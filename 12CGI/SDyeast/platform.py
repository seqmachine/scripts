#!/usr/bin/env python
"""This demonstrates a minimal http upload cgi.
This allows a user to upload up to three files at once.
It is trivial to change the number of files uploaded.

This script has security risks. A user could attempt to fill
a disk partition with endless uploads. 
If you have a system open to the public you would obviously want
to limit the size and number of files written to the disk.
"""
import cgi
import cgitb; cgitb.enable()
import os, sys
try: # Windows needs stdio set for binary mode.
    import msvcrt
    msvcrt.setmode (0, os.O_BINARY) # stdin  = 0
    msvcrt.setmode (1, os.O_BINARY) # stdout = 1
except ImportError:
    pass

#UPLOAD_DIR = "/tmp"
UPLOAD_DIR="/var/www/data"

HTML_TEMPLATE = """<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head><title>Yeast Recombination Analysis Platform 5-7,2017</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head><body><h1><font color="blue"><center>Yeast Recombination Analysis Platform</center></font></h1>
<h3>Please upload the raw fastq files, one at a time:</h3>
<form action="%(SCRIPT_NAME)s" method="POST" enctype="multipart/form-data">
<input name="file_1" type="file"><br>
<input name="submit" type="submit">
</form>

<h3>Make sure the uploading of files is compelete, check the uploading:</h3>

<form action="reportFiles.php" method="post">
<input type="submit" name="check" value="Check uploaded files" /><br/>
</form>


<h3>Click start button to run:</h3>
A typical run takes around 2 hours. <br><br>
<form action="start.php" method="post">
<input type="submit" name="check" value="Start to run!" /><br/>
</form>

<h3>Finally get the results:</h3>
Check the very end of the new page showing the running details, open the address appeared at the bottom of the page in another browser tab and download the results. <br><br>
<form  method="post">
<!--<a href="../WT1_results"><input type="submit" name="result" value="Get the results" /></a>
-->
<br/>
</form>


</body>
</html>"""

def print_html_form ():
    """This prints out the html form. Note that the action is set to
      the name of the script which makes this is a self-posting form.
      In other words, this cgi both displays a form and processes it.
    """
    print "content-type: text/html\n"
    print HTML_TEMPLATE % {'SCRIPT_NAME':os.environ['SCRIPT_NAME']}

def save_uploaded_file (form_field, upload_dir):
    """This saves a file uploaded by an HTML form.
       The form_field is the name of the file input field from the form.
       For example, the following form_field would be "file_1":
           <input name="file_1" type="file">
       The upload_dir is the directory where the file will be written.
       If no file was uploaded or if the field does not exist then
       this does nothing.
    """
    form = cgi.FieldStorage()
    if not form.has_key(form_field): return
    fileitem = form[form_field]
    if not fileitem.file: return
    fout = file (os.path.join(upload_dir, fileitem.filename), 'wb')
    while 1:
        chunk = fileitem.file.read(100000)
        if not chunk: break
        fout.write (chunk)
    fout.close()

save_uploaded_file ("file_1", UPLOAD_DIR)
print_html_form ()
