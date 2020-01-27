configuration NestVirtualizationConfiguration
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName xDHCpServer
    Import-DscResource -ModuleName xHyper-V
    
    Node localhost
    {
        LocalConfigurationManager
            {
                DebugMode            = "ForceModuleImport"
                ActionAfterReboot    = 'ContinueConfiguration'
                AllowModuleOverwrite = $true
                RebootNodeIfNeeded   = $true
                ConfigurationMode    = "ApplyAndAutoCorrect"
            }
        WindowsFeatureSet ServerRolesInstallation
            {
                Name                    = @("DHCP","Hyper-V","RSAT-DHCP","RSAT-Hyper-V-Tools","Hyper-V-Tools","Hyper-V-PowerShell")
                Ensure                  = 'Present'
                IncludeAllSubFeature    = $true
            }
        PendingReboot AfterRolesInstallation
            {
                Name       = "ConfigMgr"
                DependsOn  = "[WindowsFeatureSet]ServerRolesInstallation"
                SkipCcmClientSDK = $false
            }
        xDhcpServerScope Scope
            {
                ScopeId = '192.168.0.0'
                Ensure = 'Present'
                IPEndRange = '192.168.0.100'
                IPStartRange = '192.168.0.50'
                Name = 'InternalNAT'
                SubnetMask = '255.255.255.0'
                State = 'Active'
                AddressFamily = 'IPv4'
                DependsOn  = "[PendingReboot]AfterRolesInstallation"
            }
        xDhcpServerOption Option
            {
                Ensure = 'Present'
                ScopeID = '192.168.0.0'
                DnsServerIPAddress = '168.63.129.16'
                AddressFamily = 'IPv4'
                Router = '192.168.0.1'
                DependsOn  = "[xDhcpServerScope]Scope"
            }
        xVMSwitch switch 
            { 
            Name = "InternalNAT"
            Ensure = 'Present'
            Type = 'Internal'
            DependsOn  = "[PendingReboot]AfterRolesInstallation"
            }
        Script NatConfig
            {
            SetScript = {
                    Remove-NetNat -Name "InternalNat" -AsJob
                    Remove-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -AsJob
                    $ifIndex =(Get-NetAdapter | ? {$_.name -eq "vEthernet (InternalNAT)"}).ifIndex
                    New-NetIPAddress -IPAddress 192.168.0.1 -InterfaceIndex $ifIndex -PrefixLength 24
                    New-NetNat –Name InternalNAT -InternalIPInterfaceAddressPrefix 192.168.0.0/24
                    Add-NetNatStaticMapping -NatName "InternalNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 192.168.0.50 -InternalPort 3389 -ExternalPort 50000
                }
            TestScript = {(Get-NetNat | ? {$_.Name -eq "InternalNat" -and $_.InternalIPInterfaceAddressPrefix -eq "192.168.0.0/24"}) -and (Get-NetIPAddress | ? {$_.IPAddress -eq "192.168.0.1" -and $_.InterfaceIndex -eq "$ifIndex"})}
            GetScript = {@{'Result' = (Get-NetNat | ? {$_.Name -eq "InternalNat" -and $_.InternalIPInterfaceAddressPrefix -eq "192.168.0.0/24"}) -and (Get-NetIPAddress | ? {$_.IPAddress -eq "192.168.0.1" -and $_.InterfaceIndex -eq "$ifIndex"})}}
            DependsOn = "[xVMSwitch]switch"
        }
    }
}