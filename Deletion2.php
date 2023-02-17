<body>
<?php

//open a connection to dbase server 
include 'open.php';

// collect the posted value in a variable called $Student
$item1 = $_POST['item1'];
$item2 = $_POST['item2'];

echo "<h2>Delete all tuples with given songId and albumName from the AlbumTracks Table which has Foreign Key Constraints and Delete Cascades</h2><br>";
echo "SongId: ";
echo $item1;
echo "\n";
echo "Album TrackId: ";
echo $item2;
echo "\n";

if (!empty($item1) and !empty($item2)) {
	echo $item;
	echo "<br><br>";

	if ($result = $conn->query("CALL DeleteFromAlbumTracks('".$item1."', '".$item2."');")) {
		echo "Call to DeleteFromAlbumTracks succeeded!<br>";
	} else {
		echo "Call to DeleteFromAlbumTracks failed<br>";
	}
} else {
	echo "not set";
}
$conn->close();

?>
</body>
