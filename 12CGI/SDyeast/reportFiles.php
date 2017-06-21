

<?php
 
// for Linux
$result = shell_exec('ls -alhtp ../data/ | grep www-data');
// for Windows
// $result = shell_exec('dir');
 
echo "<pre>$result</pre>";
 
?>
