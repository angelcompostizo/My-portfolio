function MultiNewMCCUser{

    $MultiGrupo = Read-Host -Prompt "Introduzca el Grupo donde deese crear los usuarios"
    $MultiUsers = Read-Host -Prompt "Introduzca los usuarios a crear separados por comas"
    $Multipwd = Read-Host -Prompt "Introduzca Password para los usuarios anteriormente indicados" -AsSecureString
    
    
    $GrupoList = Get-LocalGroup | Select-Object -Property "Name"
    ForEach ($Grupoyaexiste in $GrupoList){
    
    $Grupoyaexiste = $GrupoList.Name
    }
    
    if($Grupoyaexiste -eq $MultiGrupo){
    
    "El grupo se ha comprobado que Existe"
    
    }
    
    else{
    
    
    $CreateGroup = New-LocalGroup -Name $MultiGrupo -Description $MultiGrupo
    
    
    }
    
    
    $Multiusers= $Multiusers -split ','
    
    
    ForEach($userM in $MultiUsers){
    
    
    New-LocalUser $userM -Password $Multipwd -Description $UserM
    
    
    
    Add-LocalGroupMember -Group $MultiGrupo -Member $UserM
    
    }
    
    
    
    }
    
    MultiNewMCCUser
    