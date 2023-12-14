<#
.SYNOPSIS
    Name: Install_pwshmodule_errorcatch.ps1
     
.DESCRIPTION
   The purpose of this script is to install powershell module through the Web.
  
.PARAMETER InitialDirectory
    This script can be run local filesystem at Workstation.
      
.NOTES
    Updated: xx-xx-2023
    Release Date: 14-12-2023
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

#----------------[ Global Vars ]---------------------------------------------------------------------------
$global:rep = "C:\Program Files\WindowsPowerShell\Modules\Nuget"
$global:reposit = "PSGallery"
#-------------------(Function)------------------------------------------------------------------------------
function name_info{

    Write-host "If you don't know the name of te module then visit https://www.powershellgallery.com/"
    Write-Host "Here you can find the name of the module your looking for"
    pause
    
}

function repo {

    if((Test-path $global:rep)-eq $true){
        Write-LogLine "Nuget Repository is installed."
    } else {

        try {
      			Write-Host "Cannot find the NuGet Repository so installing it now!"
						Write-LogLine "Cannot find the NuGet Repository so installing it now!"
						Start-Sleep 3
            Install-Package NuGet -Force -ErrorAction stop
            Write-LogLine "Setting Trust certificat"
            Set-PSRepository PSGallery -InstallationPolicy Trusted
            Write-LogLine "NuGet Repository is set as default"
						 Write-Host " NuGet repository is set as default        
						Start-Sleep 3
        }
        catch {
            $msg = "STOP The application has caught an error"

            Write-LogLine ($msg + "`n")
            Write-LogLine $_.Exception.Message
            Write-Host "Open Log file to see Error message!"
            pause
            $global:returncode = 1;
        }
    } 
}

function install_module{

    #{param($module)}
    $module = Read-Host "Module name"

    $global:modulefind = "C:\Program Files\WindowsPowerShell\Modules\$module"

     if((Test-Path $global:modulefind)-eq $true){

        Write-LogLine "The $module Module is already installed."
				Write-Host " The $module module is already installed."

     } else {
        try {
        Write-LogLine "Installing $module from the PowerShellGallary!"
				Write-Host "Installing $module from the PowerShellGallery!"
        Install-Module -Name $module -AllowClobber -Force -ErrorAction Stop
        start-sleep 10
				Write-Host "$module is now installed!"
        Write-LogLine "$module is now installed!"

        
        }
        catch {

            $msg = "`n STOP!! The application has caught an error"

            Write-LogLine ($msg + "`n")
            Write-LogLine $_.Exception.Message
            Write-Host "Open Log file to see Error message"
            pause
            $global:returncode = 1;
            
        }

     } 
}


#--------------------(Main)-----------------------------------------------------------------------------
Set-logInit("Install Pwsh module from the Internet  _")
Write-LogLine("$date Install Pwsh module from the Internet ")
Write-Version  $version
Write-Version $space
name_info
repo
Start-Sleep 3
install_module
Write-logoutput
return  $global:returncode

