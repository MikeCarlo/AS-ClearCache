$server = $args[0]
$databaseId = $args[1]
$clearCache = "<ClearCache xmlns=""http://schemas.microsoft.com/analysisservices/2003/engine""><Object><DatabaseID>$($databaseId)</DatabaseID></Object></ClearCache>"


$wshell = New-Object -ComObject Wscript.Shell


Function invokeascmd{
     [xml]$output = Invoke-AsCmd -Server:$server -Database:$databaseId  -Query:$clearCache
     foreach ($errorMessage in $output.return.root.Messages.Error ){
            $message = "Failed due to error: `n`n" + $errorMessage.Description
            $wshell.Popup(  $message)}
}

if (Get-Module -ListAvailable -Name SqlServer) {

                invokeascmd} 

else {
    
    $confirmation  = $wshell.Popup("Missing dependency package 'SqlServer'. Attempt to install as admin?",0,"Alert",64+4)
    
    if ($confirmation -eq 6) {
            $ins = " Write-Host ""INSTALLING -- DO NOT CLOSE THIS WINDOW UNTIL INSTRUCTED TO DO SO "" `n  Install-Module -Name SqlServer -Force `n Write-Host ""Finished - safe to close""  "
            $args = "-noexit $ins"
            Start-Process powershell -Verb runAs   -ArgumentList ("-executionpolicy bypass $args")
  
    } else {

    
    }
    invokeascmd
}




 