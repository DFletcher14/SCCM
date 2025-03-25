$global:ScriptFailed = $false

##================================================
## MARK: Logging Function
##================================================

# Define the Log file path
$logFilePath = "C:\Windows\fndr\logs\"
$logFileName = "$logFilePath\CallCenterConfig_Upgrade.log"

# Function to write logs
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "FNDR: $timestamp - $message"
    Write-Host $logMessage

    if (-not (Test-Path $logFilePath)) {
        New-Item -Path $logFilePath -ItemType Directory | Out-Null
    }
    Add-Content -Path $logFileName -Value $logMessage
}

try {
    Stop-Process -Name "callcenter" -Force -ErrorAction Stop
    Write-Log "callcenter process has been stopped"
} catch {
    Write-Log "Failed to stop callcenter process: $_"
}

try {
    Stop-Process -Name "tsclient" -Force -ErrorAction Stop
    Write-Log "tsclient process has been stopped"
} catch {
    Write-Log "Failed to stop tsclient process: $_"
}

##================================================
## MARK: Config.json
##================================================

# Variables
$SourceConfigJson = "C:\Windows\temp\CAS042B1\config.json"
$DestConfigJson = "C:\Program Files (x86)\Call Center Market Manager\"
$TargetConfigJson = Join-Path $DestConfigJson "config.json"

# Rename old config.json
try {
    Rename-Item -Path $TargetConfigJson -NewName "config.json.old" -Force -ErrorAction Stop
    Write-Log "$TargetConfigJson has been renamed to config.json.old"
} catch {
    Write-Log "Failed to rename config.json: $_"
    $global:ScriptFailed = $true
}

# Test both source and dest, if true copy source to dest
if (Test-Path $SourceConfigJson) {
    if(Test-Path $DestConfigJson) {
        try {
            Copy-Item $SourceConfigJson -Destination $DestConfigJson -Force -ErrorAction Stop
            Write-Log "$SourceConfigJson has been copied to $DestConfigJson"
        } catch {
            Write-Log "Failed to copy $SourceConfigJson to $DestConfigJson"
            $global:ScriptFailed = $true
        }
    } else {
        Write-Log "Destination folder does not exist: $DestConfigJson"
        $global:ScriptFailed = $true
    }
} else {
    Write-Log "Source file does not exist: $SourceConfigJson"
    $global:ScriptFailed = $true
    
}

##================================================
## MARK: App.Config.json
##================================================

# Variables
$SourceAppJson = "C:\Windows\temp\CAS042B1\app.config.json"
$DestAppJson = "C:\Program Files (x86)\TSClient\"
$TargetAppJson = Join-Path $DestAppJson "app.config.json"

# Rename old App.config.json
try {
    Rename-Item -Path $TargetAppJson -NewName "app.config.json.old" -Force -ErrorAction Stop
    Write-Log "$TargetAppJson has been renamed to app.config.json.old"
} catch {
    Write-Log "Failed to rename app.config.json: $_"
    $global:ScriptFailed = $true
}

# Test both source and dest, if true copy source to dest
if (Test-Path $SourceAppJson) {
    if(Test-Path $DestAppJson) {
        try {
            Copy-Item $SourceAppJson -Destination $DestAppJson -Force -ErrorAction Stop
            Write-Log "$SourceAppJson has been copied to $DestAppJson"
        } catch {
            Write-Log "Failed to copy $SourceAppJson to $DestAppJson"
            $global:ScriptFailed = $true
        }
    } else {
        Write-Log "Destination folder does not exist: $DestAppJson"
        $global:ScriptFailed = $true
    }
} else {
    Write-Log "Source file does not exist: $SourceAppJson"
    $global:ScriptFailed = $true
}

##================================================
## MARK: Config.xml
##================================================

# Variables
$SourceXML = "C:\Windows\temp\CAS042B1\config.xml"
$DestXML = "C:\Program Files (x86)\Call Center Market Manager\dependencies\LaTSapiWeb\"
$TargetXML = Join-Path $DestXML "config.xml"

# Rename old xml
try {
    Rename-Item -Path $TargetXML -NewName "config.xml.old" -Force -ErrorAction Stop
    Write-Log "$TargetXML has been renamed to config.xml.old"
} catch {
    Write-Log "Failed to rename config.xml: $_"
    $global:ScriptFailed = $true
}

# Test both source and dest, if true copy source to dest
if (Test-Path $SourceXML) {
    if(Test-Path $DestXML) {
        try {
            Copy-Item $SourceXML -Destination $DestXML -Force -ErrorAction Stop
            Write-Log "$SourceXML has been copied to $DestXML"
        } catch {
            Write-Log "Failed to copy $SourceXML to $DestXML"
            $global:ScriptFailed = $true
        }
    } else {
        Write-Log "Destination folder does not exist: $DestXML"
        $global:ScriptFailed = $true
    }
} else {
    Write-Log "Source file does not exist: $SourceXML"
    $global:ScriptFailed = $true
}

##================================================
## MARK: Exit Codes
##================================================

# Define Exit codes
if ($global:ScriptFailed) {
    Write-Log "CallCenter Config update failed"
    Exit 1
} else {
    Write-Log "CallCenter Config update has completed successfully."
    Exit 0
}