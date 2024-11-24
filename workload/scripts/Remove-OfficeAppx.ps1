# Remove consumer apps from Windows.
$apps = 'Microsoft.OutlookForWindows', 'Microsoft.MicrosoftOfficeHub', 'MSTeams', 'Microsoft.BingWeather', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.Xbox.TCUI', 'Microsoft.XboxIdentityProvider', 'Microsoft.XboxSpeechToTextOverlay', 'Microsoft.ZuneMusic'

foreach ($app in $apps) {
    Write-Host "Processing app: $app"
    # Perform actions on each app
    Get-AppxPackage -Name $app -AllUsers | Remove-AppPackage -AllUsers
}
