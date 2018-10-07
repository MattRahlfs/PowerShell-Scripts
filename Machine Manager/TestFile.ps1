



function test{


$value = "" | Select-Object -Property number,color
  $value.Number = 12
  $value.color = "blue"
  
  return $value


  }





  $testvariable = test




  write-host $testvariable.number
