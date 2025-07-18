# =================================================================================
# OPTIMIZED SETUP SCRIPT (VERSION 3 - FULLY AUTOMATED)
#
# Optimizations:
# - Checks if WinGet and Git already exist before attempting installation.
# - Resiliently handles potential errors from the Repair-WinGetPackageManager cmdlet.
# - Removes the 'PAUSE' command from the Store script for unattended execution.
# - Automatically detects the Git installation path for increased robustness.
# - Uses a temporary directory for the GitHub clone and cleans it up afterward.
# - Installs and launches Windows Terminal at the end of the process.
#
# IMPORTANT: This script MUST be run as Administrator.
# =================================================================================

# --- SCRIPT CONFIGURATION ---

# URL of the repository used to install the Microsoft Store.
$StoreRepoUrl = "https://github.com/kkkgo/LTSC-Add-MicrosoftStore"


# --- HELPER FUNCTIONS ---

function Check-AdminPrivileges {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "ERROR: This script requires Administrator privileges."
        Write-Warning "Please right-click the .ps1 file and select 'Run as Administrator'."
        pause
        exit
    }
}

function Invoke-Step {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [scriptblock]$ScriptBlock
    )
    Write-Host "--- STARTING STEP: $Name ---" -ForegroundColor Green
    try {
        & $ScriptBlock
        Write-Host "--- STEP COMPLETED: $Name ---" -ForegroundColor Green
    } catch {
        Write-Error "A fatal error occurred in step '$Name': $_"
        pause
        exit
    }
    Write-Host ""
}

# --- MAIN SCRIPT ---

Check-AdminPrivileges

Invoke-Step -Name "Winget Configuration" -ScriptBlock {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Winget is already functional. Skipping configuration." -ForegroundColor Yellow
    }
    else {
        Write-Host "Winget not found. Attempting to install/repair..."
        # Hide progress bars for a cleaner output
        $progressPreference = 'silentlyContinue'
        try {
            # Install necessary providers for WinGet
            Install-PackageProvider -Name NuGet -Force -Scope AllUsers -ErrorAction Stop | Out-Null
            Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers -ErrorAction Stop | Out-Null
            Repair-WinGetPackageManager -AllUsers -ErrorAction Stop
        }
        catch {
            # This cmdlet can sometimes fail on certain systems but WinGet might still work.
            Write-Warning "An error occurred during the repair attempt: $($_.Exception.Message)"
            Write-Warning "The script will continue and verify if winget is functional despite the error."
        }
    }

    # Final check to ensure WinGet is available before proceeding
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Success check: The 'winget' command is available."
    }
    else {
        throw "Critical Failure: WinGet could not be installed or found. The script cannot continue."
    }
}

Invoke-Step -Name "Git Installation" -ScriptBlock {
    if (Get-Command git.exe -ErrorAction SilentlyContinue) {
        Write-Host "Git is already installed. Skipping installation." -ForegroundColor Yellow
    } else {
        Write-Host "Installing Git via WinGet..."
        winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    }
}

Invoke-Step -Name "Add Git to PATH" -ScriptBlock {
    # Detect Git installation path from the registry
    $gitExePath = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\GitForWindows' -Name 'InstallPath' -ErrorAction SilentlyContinue).InstallPath
    if ($gitExePath) {
        $gitBinPath = Join-Path $gitExePath -ChildPath 'bin'
        $currentUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")

        # Add to PATH only if it's not already there
        if ($currentUserPath -notlike "*$gitBinPath*") {
            Write-Host "Adding Git bin directory to user PATH: $gitBinPath"
            $newPath = $currentUserPath + ";" + $gitBinPath
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            # Update PATH for the current session as well
            $env:PATH = $newPath
        } else {
            Write-Host "Git path is already configured in the user PATH." -ForegroundColor Yellow
        }
    } else {
        Write-Warning "Could not automatically detect the Git installation path."
    }
}

Invoke-Step -Name "Add Microsoft Store (Automated Mode)" -ScriptBlock {
    # Create a unique temporary directory for the clone
    $tempDir = Join-Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    Write-Host "Cloning repository to temporary directory: $tempDir"
    git clone $StoreRepoUrl $tempDir

    $storeCmdPath = Join-Path $tempDir -ChildPath "Add-Store.cmd"
    if (Test-Path $storeCmdPath) {
        # Modify the .cmd script to remove the 'PAUSE' command, allowing for unattended execution
        Write-Host "Modifying the Add-Store.cmd script for automatic execution..."
        (Get-Content -Path $storeCmdPath) | Where-Object { $_ -notmatch 'PAUSE' } | Set-Content -Path $storeCmdPath

        Write-Host "Executing the Add-Store.cmd script. The window will close automatically..."
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$storeCmdPath`"" -Wait -WindowStyle Normal
    } else {
        throw "The Add-Store.cmd script was not found in the cloned repository."
    }

    Write-Host "Cleaning up temporary files..."
    Remove-Item -Path $tempDir -Recurse -Force
}

Invoke-Step -Name "Change System Locale" -ScriptBlock {
    Write-Host "Changing system language and region settings to en-US..."
    Set-WinSystemLocale -SystemLocale en-US
    Set-Culture -CultureInfo en-US
    Set-WinHomeLocation -GeoId 244 # GeoID for USA
    Set-WinUserLanguageList -LanguageList en-US -Force
    Write-Host "Locale settings changed. A system restart may be required for all changes to take effect." -ForegroundColor Yellow
}

Invoke-Step -Name "Clear Microsoft Store Cache" -ScriptBlock {
    Write-Host "Clearing the Microsoft Store cache... This may take a moment."
    Start-Process -FilePath "wsreset.exe" -ArgumentList "-i" -Wait
}

Invoke-Step -Name "Windows Terminal Installation" -ScriptBlock {
    Write-Host "Installing Microsoft Windows Terminal..."
    winget install --id Microsoft.WindowsTerminal -e --source winget --accept-package-agreements --accept-source-agreements
}

# --- FINALIZATION ---
Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host " ALL TASKS HAVE BEEN COMPLETED." -ForegroundColor Cyan
Write-Host " Launching Windows Terminal..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Launch Windows Terminal to signify completion.
Start-Process wt.exe

# The script ends here, leaving the original PowerShell window open with the full log.