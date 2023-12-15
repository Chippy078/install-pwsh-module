<#
.SYNOPSIS
    Name: install_pwshmodule_application.ps1
     
.DESCRIPTION
   The purpose of this script is to Collect all SanDevice info from Location.
  
.PARAMETER InitialDirectory
    This script can be run local filesystem at Workstation.
      
.NOTES
    Updated: xx-xx-2023
    Release Date: 19-10-2023
    Author: Jordy Scheers
    Copyright 2019 By Verkerk Service Systemen
    All Rights Reserved
    May not be reproduced or redistributed
    Without written consent from Verkerk Service Systemen       

.NOTES
    Debug codes
    $01  = "Target found"
    $02  = "Starting function"
    $10  = "Creating Directory"  
    $13  = "Execution failed"
    $117 = "Execution completed"
    $404 = "File or map not found"
    $500 = "Unable to create item"  

.EXAMPLE 
    default 
     else{
            #Write-Host "(ERROR) file not found"
            Write-Logline ("$(get-date) code 404 [ERROR]")
             $global:returncode = 1;
        }
#>
#-----------------[Date ]-------------------------------------------------------------------------------
$date = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
#----------------[Version]-------------------------------------------------------------
$version = "Version: 1.0.0"
$space = "---------------------------------"
#----------------[ LogFile_Module ]----------------------------------------------------
function set-LogLineHeader($string) {
    $global:msg_header = $string
}

function Set-LogInit($Prefix) {
    $time = Get-Date -Format "yyyyddMM_HHmmss"
    $logDir = New-Item -Path "C:\Logs\" -Name "VCB" -ItemType "directory" -Force
    $logFileName = ($Prefix) + $time + ".log"
    $global:logFile = New-Item -Path $logDir -Name $logFileName -ItemType "file" 
    $global:logLines = New-Object System.Collections.ArrayList
    set-logLineHeader("")
    #$global:logLines.Add($global:msg_header+"start of logging") > $null
}

function Write-LogLine($string) {
    $global:logLines.Add($global:msg_header + $string) > $null
}
function Write-Version($string) {
    $global:logLines.Add($global:msg_header + $string) > $null
}

function Write-LogLineAtPosition($param) {
    $pos = $param[0]
    $string = $param[1]
    #Write-Host "POS= $pos, string = $string"
    $global:logLines.insert($pos, $global:msg_header + $string)
}

function Write-LogOutput {
    foreach ($element in $global:logLines) {  
        Write-Host($element)
        $element | Out-File $global:logFile -Append
    }
}
#----------------[Debug codes]-----------------------------------------------------------------------------
$01  = "Target found"
$02  = "Starting function"
$10  = "Creating Directory"  
$13  = "Execution failed"
$117 = "Execution completed"
$404 = "File or map not found"
$500 = "Unable to create item"
#----------------[ Global Default ]---------------------------------------------------------------------------
$global:returncode = 0 # VCB 0 = succes , 1 = failed
#----------------[ Param ]---------------------------------------------------------------------------------

#{param($module)}
$module = Read-Host "Module name"
$input = Read-host "Choose local or web"
#----------------[ Global Vars ]---------------------------------------------------------------------------
$global:default = "C:\Program Files\WindowsPowerShell\Modules\"
$global:module_excel = "C:\Program Files\WindowsPowerShell\Modules\ImportExcel"
$global:zip = "C:\Temp\$module.zip"
$global:des = "C:\Temp\"
$global:move = "C:\Temp\$module"
$global:falt = "Syntax Error!"

#-------------------(Function)------------------------------------------------------------------------------
function local {
    
    If((Test-Path $global:module_excel)-eq $true){
        Write-LogLine "$module module found!"
        Write-Host "$module module found!"
    } else {
        try {

            Write-Host "$module module not found"
            Write-Host " Uploading $module module"
            Write-LogLine "$module module not found"
            Write-LogLine "uploading $module module!"
               
          if((Test-path $global:zip)-eq $true){
    
            Write-LogLine "Zip file found!"
            Write-Host "Zip file found!"
            Start-Sleep 1
            Write-LogLine "Starting unzipping process"
            Write-Host "Starting unzipping process"
            Start-Sleep 1
            Expand-Archive -LiteralPath $global:zip -DestinationPath $global:des
            Start-Sleep 3
            Write-LogLine "$module unzipt starting import"
            Write-Host "$module unzipt starting import"
            Start-Sleep 1
            Move-Item -LiteralPath $global:move -Destination $global:default -Force
            Start-Sleep 3
            Write-LogLine "Installing $module ...."
            Write-Host "Installing $module ...."
            Import-Module -Name $module
            Start-Sleep 1
            Write-LogLine "$module has been installed"
            Write-Host "$module has been installed"
          
        } else {
            
            Write-Host "$module.zip not found "
            Write-Host "Place Zipped $module file in the Temp folder!!!"
            Write-LogLine "$module.zip not found "
            Write-LogLine "Place Zipped $module file in the Temp folder!!!"
            $global:returncode = 1;
        }
            
        }
        catch {
            $msg = "STOP The application has caught an error"

            Write-LogLine ($msg + "`n")
            Write-LogLine $_.Exception.Message
            Write-Host "Open Log file to see Error message"
            Write-logoutput
            pause
            $global:returncode = 1;
        }
  } 
} 

function web {

    $global:modulefind = "C:\Program Files\WindowsPowerShell\Modules\$module"

    if((Test-Path $global:modulefind)-eq $true){

       Write-LogLine "The $module Module is already installed."
       Write-Host "The $module Module is already installed."s

    } else {
       try {
       Write-LogLine "Installing $module from the PowerShellGallery!"
       Write-Host "Installing $module from the PowerShellGallery!"
       Install-Module -Name $module -AllowClobber -Force -ErrorAction Stop
       start-sleep 5
       Write-LogLine "$module is now installed!"
       Write-Host "$module is now installed!"
       Start-Sleep 5
       
       }
       catch {

           $msg = "`n STOP!! The application has caught an error"
           $loc = "C:/Logs/VCB/"

           Write-LogLine ($msg + "`n")
           Write-LogLine $_.Exception.Message
           Write-Host "Open Log file to see Error message"
           Write-logoutput
           pause
           $global:returncode = 1;
           
       }
    } 
}
#--------------------(Main)-----------------------------------------------------------------------------
Set-logInit("Install Powershell module Through Application  _")
Write-LogLine("$date Install Poweshell module Through Application")
Write-Version  $version
Write-Version $space

if($input -match "local"){
    Try {
    Write-LogLine "Running Application in local machine Modus"
     Write-Host "Running Application in local machine Modus"
     local
    } Catch{
        $msg = "`n STOP!! The application has caught an error"
           $loc = "C:/Logs/VCB/"

           Write-LogLine ($msg + "`n")
           Write-LogLine $_.Exception.Message
           Write-Host "Open Log file to see Error message"
           Write-logoutput
           pause
           $global:returncode = 1;
    }
}elseif ($input -match "web"){

    Try{
    Write-LogLine "Running Application in Web Modus"
    Write-Host "Running Application in Web Modus"
    Web
    }Catch{
        $msg = "`n STOP!! The application has caught an error"
           $loc = "C:/Logs/VCB/"

           Write-LogLine ($msg + "`n")
           Write-LogLine $_.Exception.Message
           Write-Host "Open Log file to see Error message"
           Write-logoutput
           pause
           $global:returncode = 1;
    }
} else{
    Try{
    Write-host $global:falt
    Write-LogLine $global:falt
    Start-Sleep 5
    }Catch{
        $msg = "`n STOP!! The application has caught an error"
           $loc = "C:/Logs/VCB/"

           Write-LogLine ($msg + "`n")
           Write-LogLine $_.Exception.Message
           Write-Host "Open Log file to see Error message"
           Write-logoutput
           pause
           $global:returncode = 1;
    }
}

Write-logoutput
return  $global:returncode
