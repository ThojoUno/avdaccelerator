# Remove consumer apps from Windows.
# https://woshub.com/how-to-uninstall-modern-apps-in-windows-10/
$UWPAppstoRemove = @(
    "Microsoft.OutlookForWindows", 
    "Microsoft.MicrosoftOfficeHub", 
    "MSTeams", 
    "Microsoft.BingNews",
    "Microsoft.BingWeather", 
    "Microsoft.MicrosoftSolitaireCollection", 
    "Microsoft.People",
    "Microsoft.ScreenSketch",
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps"
    "Microsoft.Xbox.TCUI", 
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider", 
    "Microsoft.XboxSpeechToTextOverlay", 
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.XboxGameCallableUI",
    "Microsoft.GamingApp",
    "Microsoft.Todos",
    "Microsoft.Windows.DevHome",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsCamera"
)

# Remove preinstalled Microsoft Store applications for all users and from the Windows image
foreach ($UWPApp in $UWPAppstoRemove) {
    Get-AppxPackage -Name $UWPApp -AllUsers | Remove-AppxPackage -AllUsers -Verbose -ErrorAction silentlyContinue
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -eq $UWPApp | Remove-AppxProvisionedPackage -Online -Verbose -ErrorAction silentlyContinue
}
