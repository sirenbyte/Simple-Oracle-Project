<?php 
	$c=oci_connect("q","q","localhost:1522/xe.Dlink");
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="main.css">
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
	<link href="https://fonts.googleapis.com/css?family=Kanit" rel="stylesheet">

</head>
<body>
<div class="drop">
  <div class="option active placeholder" data-value="placeholder" id="op">
    Choose 
  </div>
  <div class="option first" data-value="wow">
    Find most popular courses
  </div>
  <div class="option second" data-value="drop">
  	Find most popular teacher
  </div>
  <div class="option thr" data-value="crt">
    Create any in Oracle
  </div>
  <div class="option" data-value="select">
    Calculate GPA
  </div>
  <div class="option" data-value="custom">
    No register any subject
  </div>
  <div class="option" data-value="animation"> 
  	Student spent money on retakes
  </div>
  <div class="option" data-value="animation"> 
	Hours teacher
  </div>
  <div class="option" data-value="animation"> 
  	Design schedule of teacher
  </div>
  <div class="option" data-value="animation"> 
  	Design schedule of student
  </div>
  <div class="option" data-value="animation"> 
  	Subjects and credits selected
  </div>
  <div class="option" data-value="animation"> 
  	Most clever flow of students 
  </div>
  <div class="option" data-value="animation"> 
  	Teachers rating for the semester
  </div>
  <div class="option" data-value="animation"> 
 	Subject ratings for the semester
  </div>
  <div class="option" data-value="animation"> 
	Calculate total number of retakes
  </div>

</div>

<div class="container" id="con">
	

<div class="text-center" id="first" >

<div style="display: flex;flex-direction:row;justify-content: space-around;">
<div class="form__group field">
  <input type="input" class="form__field" placeholder="Name" name="year" id='year' required />
  <label for="year" class="form__label">Year</label>
</div>
<div class="form__group field">
  <input type="input" class="form__field" placeholder="Name" name="term" id='term' required />
  <label for="term" class="form__label">Term</label>
</div>
</div>
</div>

<div id="first-in" style="position:relative;top:50px;color:white"></div>

	

<div class="text-center" id="second">
<div style="display: flex;flex-direction:row;justify-content: space-around;">
<div class="form__group field">
  <input type="input" class="form__field" placeholder="Name" name="year" id='year' required />
  <label for="year" class="form__label">Year</label>
</div>
<div class="form__group field">
  <input type="input" class="form__field" placeholder="Name" name="term" id='term' required />
  <label for="term" class="form__label">Term</label>
</div>
<div class="form__group field">
  <input type="input" class="form__field" placeholder="Name" name="ders" id='ders' required />
  <label for="term" class="form__label">Ders Kod</label>
</div>
</div>

</div>
<div id="second-in" style="position:relative;top:50px;color:white"></div>






<!-- con end -->
</div>



</body>

<script>
	$( document ).ready(function(){  
	  $( ".first" ).click(function(){ // задаем функцию при нажатиии на элемент <div>
	    $("#first").toggle()
	  });
	});

	$( document ).ready(function(){  
	  $( ".thr" ).click(function(){ // задаем функцию при нажатиии на элемент <div>
	    $("#thr").toggle()
	  });
	});
	
 	// $('#name').on('input',function(e){
	// var a=($(this).val());
	//    });

// 	$(document).ready(function(){
// $('#qame').change(function(){
// var variable = $( "#qame" ).val();
// $.ajax
// ({
// url: 'connect.php',
// data: { variable : variable},
// type: 'post',
// success: function(result)
// {
// $('#name').val(result);
// }
// });
// });
// });
jQuery(document).ready(function($) {
$("#year").on('change', function() {
$("#term").on('change', function() {
var variable = $( "#year" ).val();
var variable2 = $( "#term" ).val();
$.ajax ({
type: 'POST',
url: 't1.php',
data: { year : variable,term : variable2},
success : function(htmlresponse) {
$('#first-in').html(htmlresponse);
console.log(htmlresponse);
}
});
});
});
});
jQuery(document).ready(function($) {
$("#year").on('change', function() {
$("#term").on('change', function() {
$("#ders").on('change', function() {
var variable = $( "#year" ).val();
var variable2 = $( "#term" ).val();
var variable3 = $( "#ders" ).val();
$.ajax ({
type: 'POST',
url: 't2.php',
data: { year : variable,term : variable2,ders : variable3},
success : function(htmlresponse) {
$('#second-in').html(htmlresponse);
console.log(htmlresponse);
}
});
});
});
});
});
   



	$( document ).ready(function(){  
	  $( ".second" ).click(function(){ // задаем функцию при нажатиии на элемент <div>
	    $( "#second" ).toggle(); // отображаем, или скрываем элемент
	  });  
	});




	
	$(document).ready(function() {
    $(".drop .option").click(function() {
      var val = $(this).attr("data-value"),
          $drop = $(".drop"),
          prevActive = $(".drop .option.active").attr("data-value"),
          options = $(".drop .option").length;
      $drop.find(".option.active").addClass("mini-hack");
      $drop.toggleClass("visible");
      $drop.removeClass("withBG");
      $(this).css("top");
      $drop.toggleClass("opacity");
      $(".mini-hack").removeClass("mini-hack");
      if ($drop.hasClass("visible")) {
        setTimeout(function() {
          $drop.addClass("withBG");
        }, 400 + options*100); 
      }
      triggerAnimation();
      if (val !== "placeholder" || prevActive === "placeholder") {
        $(".drop .option").removeClass("active");
        $(this).addClass("active");
      };
    });
    
    function triggerAnimation() {
      var finalWidth = $(".drop").hasClass("visible") ? 25 : 20;
      $(".drop").css("width", "24em");
      setTimeout(function() {
        $(".drop").css("width", finalWidth + "em");
      }, 400);
    }
  });
</script>

</html>



