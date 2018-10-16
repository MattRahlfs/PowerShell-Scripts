
class character{

[Guid]
$ID = (New-Guid).guid

[ValidateLength(2,16)]
[string]$Name

[ValidateSet("Male", "Female")]
[string]$Sex

[ValidateRange(1,([int]::MaxValue))]
[int]$Age

[validateRange(0,12)]
[float]$Height

[ValidateRange(1,1000)]
[float]$Weight


[void]mymethod(){

write-host "test"


}

}


$npc1 = [character]::new()

$npc1.Name="bobie"

$npc1.mymethod()