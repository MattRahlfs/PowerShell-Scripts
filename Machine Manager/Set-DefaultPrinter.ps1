param(

$printer
)


$a = GWMI -class Win32_Printer | where name -like "*$printer*"

$a.setdefaultprinter()