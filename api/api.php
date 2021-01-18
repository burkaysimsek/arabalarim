<?php
require_once('db.php');
$DB = new DB;
$_encoding = 'UTF-8';
$_path="http://192.168.0.15/arabalarim/";
$_images=$_path."images/";
if (!empty($_POST))
{
   
	$arac_resim = $_POST['resim'];
	$resim_muayne = $_POST['resim_muayne'];
	$gercekresim1 = base64_decode($arac_resim);
	$gercekresim2 = base64_decode($resim_muayne);
	$adsoyad =  $_POST['adsoyad'];
	$model =  $_POST['model'];
	$sigortayenileme =  $_POST['sigorta_yenileme'];
	$muayneyenileme =  $_POST['muayne_yenileme'];
	$km =  $_POST['km'];
	$uretimyili =  $_POST['uretimyili'];
	$aracresim =  $_POST['aracresim'];
	$muaynekagidi =  $_POST['muaynekagidi'];
        $query = "INSERT INTO tbl_arabalarim (adsoyad, model,km,uretimyili,muaynekagidi,aracresim,sigorta_yenileme,muayne_yenileme)
  			  VALUES('$adsoyad', '$model','$km','$uretimyili','$muaynekagidi','$aracresim','$sigortayenileme','$muayneyenileme')";
	$DB->query($query)or die( "Hata: " . $DB->error() );
	file_put_contents("images/".$aracresim,$gercekresim1);
        file_put_contents("images/".$muaynekagidi,$gercekresim2);
	echo "yüklendi";
}

$_arabaListesi = array();



if(isset($_GET['id'])) {
	$id = $_GET['id'];
	$sorgu = "DELETE FROM `tbl_arabalarim` WHERE `id` = $id";
	$DB->query($sorgu)or die( "Hata: " . $DB->error() );
		
}

if (isset($_GET['get'])) {

	
	//get Top articles
	if($_GET['get']=="araba"){
	$query = "SELECT id, adsoyad, aracresim, muaynekagidi, km,uretimyili,model,sigorta_yenileme,muayne_yenileme FROM tbl_arabalarim";


		
	
	$db_Sec = $DB->select($query);
	if (count( $db_Sec ) > 0 ) {
		foreach ( $db_Sec as $key => $get_info ) {
			$_arabaListesi[$key]['id']= $get_info['id'];
			$_arabaListesi[$key]['adsoyad']= $get_info['adsoyad'];
			$_arabaListesi[$key]['aracresim']= $_images.$get_info['aracresim'];
			$_arabaListesi[$key]['muaynekagidi']= $get_info['muaynekagidi'];
			$_arabaListesi[$key]['km']= $get_info['km'];
			$_arabaListesi[$key]['uretimyili']= $get_info['uretimyili'];
			$_arabaListesi[$key]['model']= $get_info['model'];	
			$_arabaListesi[$key]['sigorta_yenileme']= $get_info['sigorta_yenileme'];	
			$_arabaListesi[$key]['muayne_yenileme']= $get_info['muayne_yenileme'];	
		}
	}


		$row_feed['entry'] = $_arabaListesi;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}

	
	
}else{
	
}
?>