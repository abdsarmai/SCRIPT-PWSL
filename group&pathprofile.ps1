#Programme pour créer des utilisateurs, les ajouter dans leur groupe et rajouter le chemin de leur profil (profils itinérants)
$CSVFile = "C:\Users\AdminDomainIRO\Documents\utilisateurs.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

$Group1 = "Mardi1"
$Group2 = "Mardi2"
$Group3= "Jeudi1"
$Group4 = "Jeudi2"


Foreach($Utilisateur in $CSVData){

    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = $UtilisateurPrenom.Substring(0,1).ToLower() + "." + $UtilisateurNom
    $UtilisateurEmail = "$UtilisateurLogin@latech.local"
    $UtilisateurMotDePasse = "Azerty@tech94"
    $UtilisateurFonction = $Utilisateur.Fonction

    if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin})
    {
        Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD"
    }
    else
    {
        New-ADUser -Name "$UtilisateurNom $UtilisateurPrenom" `
                    -DisplayName "$UtilisateurNom $UtilisateurPrenom" `
                    -GivenName $UtilisateurPrenom `
                    -Surname $UtilisateurNom `
                    -SamAccountName $UtilisateurLogin `
                    -UserPrincipalName "$UtilisateurLogin@latech.local" `
                    -EmailAddress $UtilisateurEmail `
                    -Title $UtilisateurFonction `
                    -Path "OU=Adhérents,OU=LATECH,DC=LATECH,DC=LOCAL" `
                    -AccountPassword (ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) `
                    -ChangePasswordAtLogon $true `
                    -Enabled $true

        Write-Output "Création de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
    }

    if ($Utilisateur.Groupe -eq "Mardi1") {
        Add-ADGroupMember -Identity $Group1 -Members $UtilisateurLogin
    }
    elseif ($Utilisateur.Groupe -eq "Mardi2") {
        Add-ADGroupMember -Identity $Group2 -Members $UtilisateurLogin
    }
    elseif ($Utilisateur.Groupe -eq "Jeudi1") {
    Add-ADGroupMember -Identity $Group3 -Members $UtilisateurLogin
    }
    elseif ($Utilisateur.Groupe -eq "Jeudi2") {
    Add-ADGroupMember -Identity $Group4 -Members $UtilisateurLogin
    }
}
