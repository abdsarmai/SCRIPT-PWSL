# Liste des utilisateurs à créer
$users = @(
    @{
        Name = "John Doe"
        GivenName = "John"
        Surname = "Doe"
        SamAccountName = "jdoe"
        UserPrincipalName = "jdoe@latech.local"
        EmailAddress = "jdoe@latech.local"
        Path = "OU=Adhérents,OU=LATECH,DC=latech,DC=local"
        Password = "Password123"
    },
    @{
        Name = "Jane Smith"
        GivenName = "Jane"
        Surname = "Smith"
        SamAccountName = "jsmith"
        UserPrincipalName = "jsmith@latech.local"
        EmailAddress = "jsmith@latech.local"
        Path = "OU=Adhérents,OU=LATECH,DC=latech,DC=local"
        Password = "Password456"
    }
    # Ajoutez d'autres utilisateurs ici si nécessaire
)

# Boucle à travers la liste des utilisateurs
foreach ($user in $users) {
    New-ADUser -Name $user.Name `
               -GivenName $user.GivenName `
               -Surname $user.Surname `
               -SamAccountName $user.SamAccountName `
               -UserPrincipalName $user.UserPrincipalName `
               -EmailAddress $user.EmailAddress `
               -Path $user.Path `
               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
               -ChangePasswordAtLogon $true `
               -Enabled $true
}
