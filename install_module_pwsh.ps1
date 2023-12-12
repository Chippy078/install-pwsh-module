<#
.SYNOPSIS
    Name: Install_module.web.ps1
     
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

#----------------[ Global Vars ]---------------------------------------------------------------------------
$global:default = "C:\Program Files\WindowsPowerShell\Modules\"
$global:module_excel = "C:\Program Files\WindowsPowerShell\Modules\ImportExcel"
$global:zip = "C:\Temp\$module.zip"
$global:des = "C:\Temp\"
$global:move = "C:\Temp\$module"

#----------------[ Global SQL data ]---------------------------------------------------------------------------

#-------------------(Function)------------------------------------------------------------------------------
function local {
    
    If((Test-Path $global:module_excel)-eq $true){
        Write-LogLine "$module module found!"
    } else {

        Write-LogLine "$module module not found"
        Write-LogLine "uploading module!"
           
      if((Test-path $global:zip)-eq $true){

        Write-LogLine "Zip file found!"
        Start-Sleep 1
        Write-LogLine "Starting unzipping process"
        Start-Sleep 1
        Expand-Archive -LiteralPath $global:zip -DestinationPath $global:des
        Start-Sleep 3
        Write-LogLine "File unzipt starting import"
        Start-Sleep 1
        Move-Item -LiteralPath $global:move -Destination $global:default -Force
        Start-Sleep 3
        Write-LogLine "Installing $module ...."
        Import-Module -Name $module
        Start-Sleep 1
        Write-LogLine "$module installed"
      
    } else {
        
        Write-LogLine "$module.zip not found "
        Write-LogLine "Place Zipped module file in the Temp folder!!!"
        $global:returncode = 1;
    }
  } 
} 

function web {

    If((Test-Path $global:module_excel)-eq $true){
        Write-LogLine "$module module found!"
    } else {

        Write-LogLine "$module module not found"
        Write-LogLine "Installing $module from the WEB!"
        Install-Module -Name $module -AllowClobber -Force
        Start-Sleep 3
        Write-LogLine "$module installed!"
    }
}
#--------------------(Main)-----------------------------------------------------------------------------
Set-logInit("Install Pwsh module  _")
Write-LogLine("$date Install Pwsh module ")
Write-Version  $version
Write-Version $space

#local
web

Write-logoutput
return  $global:returncode
