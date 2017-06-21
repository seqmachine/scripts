

<?php
 
// for Linux
#$result = shell_exec('ls -altp');

$result = shell_exec('./pipeline.sh');
 
#$result = shell_exec('wc -l ../data/*');

#$result=shell_exec('python ReadAligner_v2.2/readAligner_bioobc.py');

// for Windows
// $result = shell_exec('dir');
 
echo "<pre>$result</pre>";
 
?>
