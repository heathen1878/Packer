build {
    sources = ["sources.azure-arm.managed-image-build"]

    # Install Windows DotNet Framework features
    #provisioner "powershell" {
    #    inline = [
    #        "Write-Output \"Installing NET Framework\"",
    #        "Install-WindowsFeature -Name \"NET-Framework-Features\" -IncludeAllSubFeature",
    #        "Install-WindowsFeature -Name \"NET-Framework-45-Features\" -IncludeAllSubFeature",
    #    ]
    #}

    provisioner "powershell" {
        environment_vars = [
            "password=${build.Password}"
        ]
        inline = [
            "Write-Output \"Password: $env:password\""
        ]
    }

    provisioner "breakpoint" {
        note = "Allow logon"
    }

    # Managed restart
    #provisioner "windows-restart" {
    #    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    #}

    # Install choco
    provisioner "powershell" {
        inline = [
            "Write-Output \"Installing Chocolatey\"",
            "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        ]
    }

    # Set the PS Gallery as trusted and install Az and other modules
    #provisioner "powershell" {
    #    inline = [
    #        "Write-Output \"Setting PowerShell repository PSGallery as trusted\"",
    #        "Install-PackageProvider -Name NuGet -Force",
    #        "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted",
    #        "Write-Output \"Installing Az Powershell modules\"",
    #        "Install-Module -Name Az -AllowClobber -Confirm:$false",
    #        "Write-Output \"Installing DBA Tools Powershell module\"",
    #        "Install-Module -Name dbatools -AllowClobber -Confirm:$false"
    #    ]
    #}

    # Install packages via choco
    #provisioner "powershell" {
    #    inline = [
    #        "Write-Output \"Installing the latest DotNet 6 SDK\"",
    #        "choco install dotnet-6.0-sdk -y",
    #        "Write-Output \"Installing dotnetcore latest\"",
    #        "choco install dotnetcore-sdk -y",
    #        "Write-Output \"Installing the latest SQL Server 2019 express edition\"",
    #        "choco install sql-server-express -y",
    #        "Write-Output \"Installing the SQL Server 2019 express edition LocalDB\"",
    #        "choco install sqllocaldb -y",
    #        "Write-Output \"Installing the latest Azure Storage Emulator\"",
    #        "choco install azurestorageemulator -y",
    #        "Write-Output \"Installing Firefox\"",
    #        "choco install firefox -y",
    #        "Write-Output \"Installing PostgreSQL ODBC Driver version 13.02.000\"",
    #        "choco install psqlodbc --version=13.02.0000 -y",
    #        "Write-Output \"Installing SQL Package\"",
    #        "choco install sqlpackage -y",
    #        "$SQLPackagePath = \"C:\\ProgramData\\chocolatey\\lib\\sqlpackage\\tools\"",
    #        "$MachinePath = [Environment]::GetEnvironmentVariable(\"PATH\", [EnvironmentVariableTarget]::Machine)",
    #        "if ($MachinePath -notmatch \".+?;$\") {$MachinePath += \";\"}",
    #        # Append the SQLPackage Path
    #        "$MachinePath += \"$($SQLPackagePath);\"",
    #        #Write the variable
    #        "[System.Environment]::SetEnvironmentVariable(\"PATH\", $MachinePath, [EnvironmentVariableTarget]::Machine)",
    #        "Write-Output \"Installing AzCopy\"",
    #        "choco install azcopy10 -y"
    #    ]
    #}

    # Managed restart
    #provisioner "windows-restart" {
    #    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    #}

    # Install Service Fabric 9.0 CU2
    provisioner "powershell" {
        elevated_user = "Packer"
        elevated_password = build.Password
        inline = [
            "Write-Output \"Installing Service Fabric 9.0 CU2\"",
            "choco install service-fabric -y"
        ]
    }

    provisioner "breakpoint" {
        note = "Catch errors"
    }

    # Managed restart
    provisioner "windows-restart" {
        restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    }

    # Install Service Fabric SDK
    provisioner "powershell" {
        inline = [
            "Write-Output \"Installing Azure Service Fabric SDK\"",
            "choco install service-fabric-sdk -y"
        ]
    }

    # Install Mozilla gecko driver
    #provisioner "powershell" {
    #    inline = [
    #        "Write-Output \"Installing the Gecko Driver for Mozilla Firefox\"",
    #        "Invoke-WebRequest https://github.com/Microsoft/almvm/blob/master/labs/vstsextend/selenium/armtemplate/geckodriver.exe?raw=true -OutFile \"C:\\Program Files\\Mozilla Firefox\\geckodriver.exe\""
    #    ]
    #}

    # Install Chrome
    #provisioner "powershell" {
    #    inline = [
    #        "Write-Output \"Installing Google Chrome\"",
    #        "$ChromeURL = \"https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B47D0D7C1-C2D1-5419-CF41-72C2A0088A55%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe\"",
    #        "$Path = $env:TEMP",
    #        "$Installer = \"chrome_installer.exe\"",
    #        "Invoke-WebRequest $ChromeURL -OutFile $Path\\$Installer",
    #        "Start-Process -FilePath $Path\\$Installer -Args \"/silent /install\" -Verb RunAs -Wait",
    #        "Remove-Item $Path\\$Installer"
    #    ]
    #}

    # Managed restart
    #provisioner "windows-restart" {
    #    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    #}

    provisioner "breakpoint" {
        note = "Catch errors"
    }

    provisioner "powershell" {
        inline = [
            "Write-Output \"Running sysprep oobe\"",
            # NOTE: the following *3* lines are only needed if the you have installed the Guest Agent.",
            "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
            "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
            "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
            "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
        ]
    }
    
}