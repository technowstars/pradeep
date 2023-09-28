Set-Location 'C:\Users\Public\Downloads'
New-Item mytextfile.txt
Add-Content mytextfile.txt -Value "this is for testing install"
#Invoke-WebRequest https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.2.1/npp.8.2.1.Installer.exe -OutFile c:\Users\Public\Downloads\npp.8.2.1.Installer.exe
#Start-Process c:\Users\Public\Downloads\npp.8.2.1.Installer.exe /S -NoNewWindow -Wait -PassThru

New-Item gitactions.bat
Add-Content gitactions.bat -Value "git config --global user.name 'qxz4999'"
Add-Content gitactions.bat -Value "git config --global user.email 'pradeep.kumara@partner.bmw.de'"
Add-Content gitactions.bat -Value "git clone https://qxz4999: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@atc-github.azure.cloud.bmw/sflp/r3da_factory_explorer_kit_extension.git"
Add-Content gitactions.bat -Value "git pull"
& Start-Process .\gitactions.bat

Invoke-WebRequest https://qxz4999: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@atc-github.azure.cloud.bmw/sflp/r3da_factory_explorer_kit_extension/blob/master/.github/workflows/main.yml -OutFile c:\Users\Public\Downloads\main.yml