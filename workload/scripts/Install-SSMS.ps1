# Install-SSMS.ps1
Write-Host 'AIB Customization: Installing SQL Server Management Studio'

$installerPath = "C:\Windows\Temp\SSMS-Setup.exe"
#$installerUrl = "https://aka.ms/ssmsfullsetup"
# Direct link to version 20.2.1
$installerUrl = "https://go.microsoft.com/fwlink/?linkid=2313753&clcid=0x409"

try {
    # Download SSMS installer
    Write-Host "Downloading SSMS installer..."
    #Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $maxAttempts = 3
    for ($i = 1; $i -le $maxAttempts; $i++) {
        try {
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing -TimeoutSec 120
            break
        } catch {
            if ($i -eq $maxAttempts) { throw }
            Write-Host "Download attempt $i failed: $($_.Exception.Message). Retrying in 15s..."
            Start-Sleep -Seconds 15
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
