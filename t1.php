<?php
$c=oci_connect("q","q","localhost:1522/xe.Dlink");
	
if(!isset($_POST['year']) and !isset($_POST['term'])){
    echo "bos";
  }
else{
 
$stid = oci_parse($c, 'select * from table (most_pop_course('.$_POST['term'].','.$_POST['year'].'))');
oci_execute($stid);
  
  echo  "<table class='clTbl' width='100%'>
  <tbody><tr>
        <td class='ctg' width='15.384615384615%' align='center' style='background-color: #DDF4FF'> &nbsp;&nbsp;&nbsp;&nbsp;<span  style='font-size:14px; font-weight:bold; color:black;'>DERS KOD</span></td>
        <td class='ctg' width='15.384615384615%' align='center' style='background-color: #DDF4FF'> &nbsp;&nbsp;&nbsp;&nbsp;<span  style='font-size:14px; font-weight:bold; color:black;'>STUDENTS COUNT</span></td>
        <td class='ctg' width='15.384615384615%' align='center' style='background-color: #DDF4FF'> &nbsp;&nbsp;&nbsp;&nbsp;<span  style='font-size:14px; font-weight:bold; color:black;'>TEACHER</span></td>
        <td class='ctg' width='15.384615384615%' align='center' style='background-color: #DDF4FF'> &nbsp;&nbsp;&nbsp;&nbsp;<span  style='font-size:14px; font-weight:bold; color:black;'>REGISTRATION DATE</span></td>

  </tr>";
  


while (($row = oci_fetch_array($stid, OCI_BOTH))) {
	
	echo "<tr>
			<td class='ctg' align='center' style='font-size: 20px; padding: 0;'>".$row[0]."</td>".
			"<td class='ctg' align='center' style='font-size: 20px; padding: 0;'>".$row[1]."</td>".
			"<td class='ctg' align='center' style='font-size: 20px; padding: 0;'>".$row[2]."</td>".
			"<td class='ctg' align='center' style='font-size: 20px; padding: 0;'>".$row[3]."</td>";
			
}	
      
	
echo "</tbody></table>";
}

?>


