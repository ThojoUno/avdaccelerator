# Install-SSMS.ps1
Write-Host 'AIB Customization: Installing SQL Server Management Studio'

$installerPath = "C:\Windows\Temp\SSMS-Setup.exe"
#$installerUrl = "https://aka.ms/ssmsfullsetup"
# Direct link to version 20.2.1
# $installerUrl = "https://go.microsoft.com/fwlink/?linkid=2313753&clcid=0x409"
# SSMS 20.2.1 — direct Microsoft CDN URL (bypasses fwlink redirect)
$installerUrl  = 'https://download.microsoft.com/download/7519f0ff-997c-4f36-b5aa-9a51d47dd34c/SSMS-Setup-ENU.exe'

try {
    # Download SSMS installer
    Write-Host "Downloading SSMS installer..."

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $maxAttempts = 3
    for ($i = 1; $i -le $maxAttempts; $i++) {
        try {
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing -TimeoutSec 900
            break
        } catch {
            if ($i -eq $maxAttempts) { throw }
            Write-Host "Download attempt $i failed: $($_.Exception.Message). Retrying in 30s..."
            Start-Sleep -Seconds 30
        }
    }
    
    # Install SSMS silently
    Write-Host "Installing SSMS..."
    Start-Process -FilePath $installerPath `
        -Args "/install /quiet /norestart" `
        -Wait -PassThru
    
    # Cleanup
    Remove-Item $installerPath -Force
    
    Write-Host "SSMS installation completed successfully"
    exit 0
}
catch {
    Write-Host "Error installing SSMS: $_"
    exit 1
}
