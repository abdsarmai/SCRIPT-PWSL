Import-Module ActiveDirectory
$CSVFile = "Chemin du fichier csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

$groupes_adh = @("Gpe_1", "Gpe_2", "Gpe_3","Gpe_4","visiteurs")

$cheminOU = "Chemin OU de où sera mis les groupes"

foreach ($nomGroupe in $groupes_adh) {
    if (-not (Get-ADGroup -Filter { Name -eq $nomGroupe } -SearchBase $cheminOU)) {
        New-ADGroup -Name $nomGroupe -GroupScope Global -GroupCategory Security -Path $cheminOU
        Write-Host "Le groupe $nomGroupe a été créé."
    } else {
        Write-Host "Le groupe $nomGroupe est déjà existant."
    }
}



$ProfilPath = "Chemin pour que les données soit sav"

Foreach($Utilisateur in $CSVData){

    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = $UtilisateurPrenom.Substring(0,1).ToLower() + "." + $UtilisateurNom.ToLower()
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
                    -Path "Chemin OU de où sera mis les utilisateurs" `
                    -AccountPassword (ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) `
                    -ChangePasswordAtLogon $true `
                    -Enabled $true `
                    -ProfilePath ($ProfilPath -replace "%username%", $UtilisateurLogin)

        Write-Output "Création de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
    }
}
