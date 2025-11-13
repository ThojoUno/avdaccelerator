# Install-7Zip.ps1
Write-Host 'AIB Customization: Installing 7-Zip'

$ErrorActionPreference = 'Stop'

try {
    # Determine system architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    
    # 7-Zip version and download URL
    $version = "2408"  # 24.08
    if ($arch -eq "x64") {
        $installerUrl = "https://www.7-zip.org/a/7z$version-x64.msi"
        $installerPath = "C:\Windows\Temp\7z-x64.msi"
    } else {
        $installerUrl = "https://www.7-zip.org/a/7z$version.msi"
        $installerPath = "C:\Windows\Temp\7z.msi"
    }
    
    # Download 7-Zip installer
    Write-Host "Downloading 7-Zip $arch installer from $installerUrl..."
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    
    # Verify download
    if (-not (Test-Path $installerPath)) {
        throw "Failed to download 7-Zip installer"
    }
    
    Write-Host "Installing 7-Zip..."
    $process = Start-Process -FilePath "msiexec.exe" `
        -ArgumentList "/i `"$installerPath`" /qn /norestart" `
        -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
        Write-Host "7-Zip installation completed successfully (Exit code: $($process.ExitCode))"
        
        # Verify installation
        $installPath = if ($arch -eq "x64") { 
            "C:\Program Files\7-Zip\7z.exe" 
        } else { 
            "C:\Program Files (x86)\7-Zip\7z.exe" 
        }
        
        if (Test-Path $installPath) {
            Write-Host "7-Zip verified at: $installPath"
        } else {
            Write-Host "Warning: 7-Zip executable not found at expected location"
        }
        
        # Cleanup
        Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        exit 0
    } else {
        Write-Host "7-Zip installation failed with exit code: $($process.ExitCode)"
        exit $process.ExitCode
    }
}
catch {
    Write-Host "Error installing 7-Zip: $_"
    Write-Host $_.Exception.Message
    Write-Host $_.ScriptStackTrace
    exit 1
}
