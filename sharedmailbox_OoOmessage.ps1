$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

$users = import-csv


$nomanager=@()
foreach($user in $users){
    try{$manager = (Get-ADUser $user -Properties manager).manager}
    catch{$nomanager+=$user.UserPrincipalName}
    
    Get-Mailbox -Identity $user.UserPrincipalName | Set-Mailbox -Type shared
    Set-MailboxAutoReplyConfiguration -Identity $user.UserPrincipalName -AutoReplyState Enabled -InternalMessage "SOMETHING HERE" -ExternalMessage "SOMETHING HERE"
    try{Add-MailboxPermission -Identity $user.UserPrincipalName -User (get-aduser $manager).userprincipalname -AccessRights fullaccess }
    catch{"couldn't add $user.name because they have no manager"}

}
$nomanager



$users = get-aduser asal7286