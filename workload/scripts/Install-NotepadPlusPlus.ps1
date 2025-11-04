# Install-NotepadPlusPlus.ps1
Write-Host 'AIB Customization: Installing Notepad++'

$ErrorActionPreference = 'Stop'

try {
    # Determine system architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    
    # Notepad++ version and download URL
    $version = "8.7.1"  # Update to latest stable version as needed
    if ($arch -eq "x64") {
        $installerUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$version/npp.$version.Installer.x64.exe"
        $installerPath = "C:\Windows\Temp\npp-x64.exe"
    } else {
        $installerUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$version/npp.$version.Installer.exe"
        $installerPath = "C:\Windows\Temp\npp.exe"
    }
    
    # Download Notepad++ installer
    Write-Host "Downloading Notepad++ $version ($arch) from GitHub..."
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    
    # Verify download
    if (-not (Test-Path $installerPath)) {
        throw "Failed to download Notepad++ installer"
    }
    
    Write-Host "Installing Notepad++..."
    # /S = Silent mode
    $process = Start-Process -FilePath $installerPath `
        -ArgumentList "/S" `
        -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        Write-Host "Notepad++ installation completed successfully"
        
        # Verify installation
        $installPath = if ($arch -eq "x64") {
            "C:\Program Files\Notepad++\notepad++.exe"
        } else {
            "C:\Program Files (x86)\Notepad++\notepad++.exe"
        }
        
        if (Test-Path $installPath) {
            Write-Host "Notepad++ verified at: $installPath"
        } else {
            Write-Host "Warning: Notepad++ executable not found at expected location"
        }
        
        # Cleanup
        Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        exit 0
    } else {
        Write-Host "Notepad++ installation failed with exit code: $($process.ExitCode)"
        exit $process.ExitCode
    }
}
catch {
    Write-Host "Error installing Notepad++: $_"
    Write-Host $_.Exception.Message
    Write-Host $_.ScriptStackTrace
    exit 1
}
