Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 
Install-PackageProvider -Name NuGet -Force 
Install-Module -Name ComputerManagementDsc -Force -SkipPublisherCheck
Install-Module -Name xDHCpServer -Force -SkipPublisherCheck
Install-Module -Name xHyper-V -Force -SkipPublisherCheck