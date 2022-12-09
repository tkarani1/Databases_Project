<head><title>All Course Averages</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$item = $_POST['this_genre'];

	// echo some basic header info onto the page
	echo "<h2>Average Metrics for a Genre</h2><br>";

    // proceed with query only if supplied password is non-empty
	if (!empty($item)) {

       // call the stored procedure we already defined on dbase
	$result = $conn->query("CALL Query3('".$item."');");

	    if (($result) && ($result->num_rows > 1)) {
	      echo "<table border=\"2px solid black\">";
            //Create table to display results
            echo "<table border=\"1px solid black\">";
            echo "<tr><th> State </th> <th> NumSpeciesHosted </th> </tr>";

            //Report result set by visiting each row in it
            while ($row = $result->fetch_row()) {
               array_push($dataPoints, array( "label"=> $row[0], "y"=> $row[1]));
               echo "<tr>";
               echo "<td>".$row[0]."</td>";
               echo "<td>".$row[1]."</td>";
               echo "</tr>";
            } 
         
	 
            echo "</table>";

          } else {
			echo "No songs with this genre"; 
	  }   
   } else {
	echo "No genre provided <br>";  
 }

   // close the connection opened by open.php
   $conn->close();
?>
</body>
