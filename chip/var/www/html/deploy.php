<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<link rel="stylesheet" href="jquery.mobile-1.4.5.min.css">
	<script src="jquery-1.11.3.min.js"></script>
	<script src="jquery.mobile-1.4.5.min.js"></script>
</head>
<body>

    Installation Type: <?php echo $_POST["final_microtype"]; ?> <br />
    Callsign: <?php echo $_POST["final_callsign"]; ?> <br />
    Node Name: <?php echo $_POST["final_meshhostname"]; ?> <br />
    Node Password: <?php echo $_POST["final_meshpassword"]; ?> <br />
    Node Channel: <?php echo $_POST["final_nodechannel"]; ?> <br />
    Node SSID: <?php echo $_POST["final_nodessid"]; ?> <br />
    Mesh Ethernet Type: <?php echo $_POST["final_meshEthernetType"]; ?> <br />
    Router Hostname: <?php echo $_POST["final_routerhostname"]; ?> <br />
    SSID: <?php echo $_POST["final_ssid"]; ?> <br />
    Password: <?php echo $_POST["final_password"]; ?> <br />
    Router Ethernet Type: <?php echo $_POST["final_routerEthernetType"]; ?> <br />
    AP SSID: <?php echo $_POST["final_accesspointssid"]; ?> <br />
    AP Password: <?php echo $_POST["final_accesspointpassword"]; ?> <br />
    AP Channel: <?php echo $_POST["final_accesspointchannel"]; ?> <br />


	<h1> Installation Results </h1>

	<h3> Installation command: </h3>
	<?php
		$command = "/var/www/html/./mmconfig ";
		$command .= $_POST["final_microtype"] . " ";
		$command .= $_POST["final_callsign"] . " ";
		$command .= $_POST["final_meshhostname"] . " ";
		$command .= $_POST["final_meshpassword"] . " ";
		$command .= $_POST["final_nodechannel"] . " ";
		$command .= $_POST["final_meshEthernetType"] . " ";
		$command .= $_POST["final_routerhostname"] . " ";
		$command .= $_POST["final_ssid"] . " ";
		$command .= $_POST["final_password"] . " ";
		$command .= $_POST["final_routerEthernetType"] . " ";
		$command .= $_POST["final_accesspointssid"] . " ";
		$command .= $_POST["final_accesspointpassword"] . " ";
		$command .= $_POST["final_accesspointchannel"] . " ";
		$command .= $_POST["final_nodessid"] . " ";
		echo $command;
	?>







	<?php
		echo shell_exec("sudo $command");
		echo "<br />";

	?>
</body>
</html>
