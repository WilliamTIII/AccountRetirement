$file = Import-Csv  "C:\steve\terms.csv"
Connect-AzureAD
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking



ForEach ($user in $file)
{
    
    $ID = $user.employeeid
    $username = Get-adUser -filter {EmployeeID -eq $id} -Properties SamAccountName,employeeid,distinguishedname | ?{$_.distinguishedname -notlike "*internal*"}
    
    "Running " + ($username.userprincipalname)
    Revoke-AzureADUserAllRefreshToken -ObjectId $username.UserPrincipalName
   Get-InboxRule -Mailbox $username.UserPrincipalName | Disable-InboxRule -Confirm:$false -Force
}






import-csv C:\steve\terms.csv

$user.employeeid