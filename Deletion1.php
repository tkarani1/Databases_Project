<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

        // collect the posted value in a variable called $item
	$item = $_POST['item'];

        echo "<h2>Delete all tuples for a country</h2><br>";
        echo "Country: ";

	if (!empty($item)) {
	   echo $item;
	   echo "<br><br>";

        if ($result = $conn->query("CALL DeleteFromCountryHappiness('".$item."');")) {
         echo "Call to DeleteFromCountryHappiness succeeded!<br>";
        } else {
            echo "Call to DeleteFromCountryHappiness failed<br>";
       }
	} else {
	   echo "not set";
	}
	$conn->close();

?>
</body>
