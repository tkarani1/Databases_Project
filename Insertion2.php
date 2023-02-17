<body>
<?php

//open a connection to dbase server 
include 'open.php';

// collect the posted value 
$item1 = $_POST['item1'];
$item2 = $_POST['item2'];
$item3 = $_POST['item3'];
$item4 = $_POST['item4'];

echo "<h2>Insert into SongReleases Table </h2><br>";

if (!empty($item1) and !empty($item2) and !empty($item3) and !empty($item4)) {
   if (!is_numeric($item4)) {
       echo "Number of Artists is not a number";
   }
   else {
       $item4_num = (int)$item4;

       echo "songID: ";
       echo $item1;
       echo "\n\n";
       echo "artistID: ";
       echo $item2;
       echo "\n\n";
       echo "songType: ";
       echo $item3;
       echo "\n\n";
       echo "Number of Artists: ";
       echo $item4;
       echo "\n\n";
       echo "<br><br>";
       
       if ($result = $conn->query("CALL InsertSongIfIDNotExists('".$item1."', '".$item2."', '".$item3."', '".$item4_num."');")) {
           echo "Call to InsertSongIfIDNotExists succeeded!<br>";
       } else {
           echo "The details Fail the Insertion to SongReleases Plant Table<br>";
       }
   }
} else {
   echo "not set";
}
$conn->close();

?>
</body>
