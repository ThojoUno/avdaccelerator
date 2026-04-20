# Install-ODBCDriver18.ps1
Write-Host 'AIB Customization: Installing ODBC Driver 18 for SQL Server'

$ErrorActionPreference = 'Stop'

try {
    # Determine system architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    
    # ODBC Driver 18 download URL (from Microsoft)
    if ($arch -eq "x64") {
        $installerUrl = "https://go.microsoft.com/fwlink/?linkid=2249004"  # ODBC Driver 18.4 x64
        $installerPath = "C:\Windows\Temp\msodbcsql_x64.msi"
    } else {
        $installerUrl = "https://go.microsoft.com/fwlink/?linkid=2249003"  # ODBC Driver 18.4 x86
        $installerPath = "C:\Windows\Temp\msodbcsql_x86.msi"
    }
    
    # Download ODBC Driver installer
    #Write-Host "Downloading ODBC Driver 18 for SQL Server ($arch)..."
    #Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    
    # After
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
    
    # Verify download
    if (-not (Test-Path $installerPath)) {
        throw "Failed to download ODBC Driver installer"
    }
    
    Write-Host "Installing ODBC Driver 18 for SQL Server..."
    # Install with acceptance of license terms
    $process = Start-Process -FilePath "msiexec.exe" `
        -ArgumentList "/i `"$installerPath`" /qn /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" `
        -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
        Write-Host "ODBC Driver 18 installation completed successfully (Exit code: $($process.ExitCode))"
        
        # Verify installation by checking registry
        $odbcKey = "HKLM:\SOFTWARE\ODBC\ODBCINST.INI\ODBC Driver 18 for SQL Server"
        if (Test-Path $odbcKey) {
            $driverPath = (Get-ItemProperty -Path $odbcKey -Name "Driver" -ErrorAction SilentlyContinue).Driver
            Write-Host "ODBC Driver 18 verified. Driver location: $driverPath"
        } else {
            Write-Host "Warning: ODBC Driver 18 registry key not found"
        }
        
        # Cleanup
        Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        exit 0
    } else {
        Write-Host "ODBC Driver 18 installation failed with exit code: $($process.ExitCode)"
        exit $process.ExitCode
    }
}
catch {
    Write-Host "Error installing ODBC Driver 18: $_"
    Write-Host $_.Exception.Message
    Write-Host $_.ScriptStackTrace
    exit 1
}
