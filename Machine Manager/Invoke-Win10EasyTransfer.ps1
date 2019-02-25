param(

$OldComputer,

$Newcomputer,

$UserName 

)


$NetworkStoragePath = "C:\Users\$env:USERNAME\OneDrive - Mercy Online"

function createNetStorage{


    #creating the main directory to store the files
    Try{

        if(!(Test-Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage")){
            New-Item -Path $NetworkStoragePath -Name "Windows 10 Easy Transfer Storage" -ItemType Directory
            Write-Output "Created the storage directory"            
            }
    
    }
    Catch{$_.ErrorMessage
         Write-Output "Unable to create main storage directory"}

    #creating the directory for the old computer
    Try{
        
        if((Test-Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage") -and 
            !(Test-Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer")){

            New-Item -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage" -Name $OldComputer -ItemType Directory 
            Write-Output "Created the Directory for $OldComputer"}

        }
    Catch{$_.ErrorMessage
          Write-Output "Unable to create the $OldComputer Directory"}

    #creating the directory for the desktop 
    Try{
        
        if(!(Test-Path -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer\Desktop")){
            New-Item -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer" -Name "Desktop" -ItemType Directory
            Write-Output "Created desktop storage"
            }

        }
    Catch{$_.ErrorMessage
          Write-Output "Unable to create desktop storage"}

    #creating the directory for the favorites
    <#Try{
    
        if(!(Test-Path -Path "$NetworkStoragePath\$OldComputer\Favorites")){
            New-Item -Path "$NetworkStoragePath\$OldComputer" -Name "Favorites" -ItemType Directory
            Write-Output "Created Favorites Folder"
        
        }


    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to create Favorites Folder"}#>



}


function getDesktop{

    Try{
        
        if(& "$PSScriptRoot\Get-MachineConnection.ps1" $OldComputer){
            
            foreach($item in (Get-ChildItem -Path "\\$OldComputer\c$\Users\$UserName\Desktop\" -Recurse -Force)){
            Copy-Item -Path "\\$OldComputer\c$\Users\$UserName\Desktop\$($Item.name)" -Destination "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer\Desktop" -Recurse -Force}
            }
        Write-Output "Copied desktop items"

        }
    Catch{Write-Output "Unable to copy data from $OldComputer's Desktop"}

}


function getSticky {

    Try{
    
        Invoke-Command -ComputerName $OldComputer  -ArgumentList $OldComputer -ScriptBlock {param($OldComputer) Get-Process -ComputerName $OldComputer -Name Microsoft.StickyNotes -ErrorAction SilentlyContinue | Stop-Process -Force}
    
    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to stop the sticky note process"}



    Try{
    
        if(!(Test-Path -Path "\\$OldComputer\C$\Users\$UserName\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe")){
            Write-Output "Sticky notes cannot be found"
        }else{Copy-Item -Path "\\$OldComputer\C$\Users\$UserName\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" -Destination "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer\" -Recurse -Force}
        Write-Output "Copied sticky notes"
    
    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to copy sticky notes"}

}


function startTransfer{


    Try{

        if(!(Test-Path -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer\Desktop")){
            Write-Output "Storage does not exist"
            createNetStorage
            getDesktop
            getSticky}
        elseif(Test-Path -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer\Desktop"){
            Write-Output "Storage already exists"
            Remove-Item -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\$OldComputer" -Recurse -Force
            startTransfer
            }
    
        }
    Catch{$_.ErrorMessage
            Write-Output "Unable to start the profile transfer"}

}


function sendData{

    Try{
        
        foreach($item in (Get-ChildItem -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\wbgks6h2\Desktop")){
            
            Copy-Item -Path "$NetworkStoragePath\Windows 10 Easy Transfer Storage\wbgks6h2\Desktop\$($item.name)" -Destination "\\$Newcomputer\c$\Users\$UserName\Desktop" -Recurse -Force
            
        }
        Write-Output "sent the desktop items"
        
    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to send desktop items to new pc"}

    Try{
        
        Copy-Item -Path "$NetworkStoragePath\Windows 10 Easy TRansfer Storage\$OldComputer\Microsoft*" -Destination "\\$Newcomputer\C$\Users\$UserName\AppData\Local\Packages\" -Recurse -Force
        Write-Output "Sent the sticky notes"
    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to send sticky notes to new pc"}



}

startTransfer

sendData