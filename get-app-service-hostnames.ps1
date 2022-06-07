# Use this script if you want to use the hostname for web app scanning

#Rememeber to login first Connect-AzAccount


$tenantID = Get-AzTenant

$subscriptions = Get-AzSubscription -tenantID $tenantID

foreach ($id in $subscriptions) {
    Select-AzSubscription $id

    $appList = Get-AzWebApp

    foreach($app in $appList){
        $hostname = $app.DefaultHostname 
        Write-Output "$hostname" | Out-File -Append "./Azure-App-Service-HostNames.txt"
    }
}

Write-Output "Output written to file ./Azure-App-Service-HostNames.txt"