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

	    if (($result) && ($result->num_rows != 0)) {
	      echo "<table border=\"2px solid black\">";
          // output a row of table headers
	      echo "<tr>";
	      // collect an array holding all attribute names in $result
	      $flist = $result->fetch_fields();
          // output the name of each attribute in flist
	      foreach($flist as $fname){
	         echo "<td>".$fname->name."</td>";
	      }
	      echo "</tr>";

          // output a row of table for each row in result, using flist names
          // to obtain the appropriate attribute value for each column
	      foreach($result as $row){

              // reset the attribute names array
    	      $flist = $result->fetch_fields(); 
	          echo "<tr>";
	          foreach($flist as $fname){
                      echo "<td>".$row[$fname->name]."</td>";
              }
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
