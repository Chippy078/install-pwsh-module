<#
.SYNOPSIS
    Name: Install_module.ps1
     
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

#----------------[ Global Vars ]---------------------------------------------------------------------------
$global:pwshpath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
$Global:des = "C:\Transfer\$module"
$global:module_excel = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Excel"
$global:zip = "C:\Transfer\$module.zip"
#----------------[ Global SQL data ]---------------------------------------------------------------------------

#-------------------(Function)------------------------------------------------------------------------------
function pwsh_module {

    If((Test-Path $global:module_excel)-eq $true){
        Write-LogLine "$module module found!"
    } else {
        Write-LogLine "$module module not found"
        Write-LogLine "uploading module!"
        
        upload_module
    }
}

function upload_module{


    if((Test-path $global:zip)-eq $true){

        Write-LogLine "Zip file found!"
        Sleep 1
        Write-LogLine "Starting unzipping process"
        sleep 1
        Expand-Archive -LiteralPath "C:\Transfer\$module.zip" -DestinationPath "C:\Transfer"
        Sleep 3
        Write-LogLine "File unzipt starting upload"
        sleep 1
        Move-Item $Global:des -Destination $global:pwshpath
    } else {
        
        Write-LogLine "$module.zip not found "
        Write-LogLine "Upload module"
        $global:returncode = 1;
    }

}
#--------------------(Main)-----------------------------------------------------------------------------
Set-logInit("Get or upload Pwsh module  _")
Write-LogLine("$date Get or upload Pwsh module ")
Write-Version  $version
Write-Version $space

pwsh_module

Write-logoutput
return  $global:returncode

