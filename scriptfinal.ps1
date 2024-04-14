$usersData = Import-Csv -Path "Chemin du fichier csv"

foreach ($userData in $usersData) {
    New-ADUser -Name $userData.Name `
               -GivenName $userData.GivenName `
               -Surname $userData.Surname `
               -SamAccountName $userData.SamAccountName `
               -UserPrincipalName $userData.UserPrincipalName `
               -EmailAddress $userData.EmailAddress `
               -Path $userData.Path `
               -AccountPassword (ConvertTo-SecureString $userData.Password -AsPlainText -Force) `
               -ChangePasswordAtLogon $true `
               -Enabled $true
}