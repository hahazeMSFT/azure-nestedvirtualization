
# Nested Virtualization Environment - Automated

### Description 

This repository contains steps/information that automates the creation of a nested virtualization environment that can be used to troubleshoot or fix Azure VM/VHD related  issues. 

The process uses an [Azure ARM Template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) to deploy VM with a combination of [Custom Script Extension (CSE)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows) and [Desire State Configuration (DSC)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-overview) to get nested virtualization environment configured.

The aim of this is to deploy a nested virtualization environment with the least effort.

### Process

Two common ways to deploy this solution are;

1.  Use the `Deploy to Azure` button below to deploy environment straight into your subscription. 

    <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fhazelnestpublicstore.blob.core.windows.net%2Fpublic%2Fnestedvirtdsc.json" target="_blank"><img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
    </a>

    ![Imgur](https://i.imgur.com/DMsgBnS.gif)

    ![https://i.imgur.com/jGUHtoL.png](https://i.imgur.com/jGUHtoL.png)

    **You can also use `PowerShell`, `CLI` and `Templates` feature in the Poratl to deploy template.**

<br/>
<br/>

2. Add the `install-module.ps1` as a CSE and the `NestedVirtDSC.ps1.zip` using function `NestVirtualizationConfiguration` as DSC respectively to a VM creation process  or an existing VM that is capable of nested virtualization. 

    ![https://i.imgur.com/Kr9e2ZJ.png](https://i.imgur.com/Kr9e2ZJ.png)


<hr/>