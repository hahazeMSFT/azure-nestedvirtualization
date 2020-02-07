
# Nested Virtualization Environment - Automated

### Description 

This repository contains steps/information that automates the creation of a nested virtualization environment that can be used to troubleshoot or fix Azure VM/VHD related  issues. 

The process uses an [Azure ARM Template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) to deploy VM with a combination of [Custom Script Extension (CSE)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows) and [Desire State Configuration (DSC)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-overview) to get nested virtualization environment configured.

The aim of this is to deploy a nested virtualization environment with the least effort. The manual process/step can be found in [this article](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-setup-nested-virtualization-for-azure-vm-vhd/ba-p/1115338) on [ITOps Talk](https://itopstalk.com/) community blog.


<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FhahazeMSFT%2Fazure-nestedvirtulaztion%2Fmaster%2Fnestedvirtdsc.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/> 
</a>

### Process

Expand below to see two common ways to deploy this solution.

<details>

<summary>Automate the whole creation and configuration of VM</summary>
</br>

Use the `Deploy to Azure` button below to deploy environment straight into your subscription. 

**You will need to deploy VM into a new Resource group due to VNet/Subnet configuration.**

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FhahazeMSFT%2Fazure-nestedvirtulaztion%2Fmaster%2Fnestedvirtdsc.json" target="_blank"><img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>

The automation does the following in this order 

1.  Deploy a Azure [Spot VM](https://azure.microsoft.com/en-us/pricing/spot/) capable of nested virtualization.
2.  Deploys a CSE that installs modules for the DSC
3.  Deploys DSC to install and configure the DHCP and Hyper-V role on VM


![Image 1](https://i.imgur.com/DMsgBnS.gif)

![Image 2](https://i.imgur.com/jGUHtoL.png)

**You can also use `PowerShell`, `CLI` and `Templates` feature in the Portal to deploy template.**

<br/>
<br/>
</details>


<details>

<summary>Add configuration to a new or existing VM</summary>
</br>

On a new or existing VM you can add the `install-module.ps1` as a CSE and the `NestedVirtDSC.ps1.zip` using function `NestedVirtDSC.ps1\NestVirtualizationConfiguration` as DSC respectively to a VM creation process  or the extension blade of an existing VM that is capable of nested virtualization. 

![Image 3](https://i.imgur.com/Kr9e2ZJ.png)


<hr/>

</details>

