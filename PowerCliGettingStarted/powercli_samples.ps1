$creds = get-credential
$org = "1-1-1-a4f57h"

##Log In to vCloud
connect-ciserver api.vcd.portal.skyscapecloud.com -org $org -credential $creds

##List All vApps
get-civapp

##List All VMs
get-civm

##Deploy vApp


$catalog = get-catalog "Skyscape Catalogue"
$vapptemplate = get-civapptemplate "Skyscape_CentOS_6_4_x64_50GB_Small_v1.0.1" -Catalog $catalog
$vdc = get-orgvdc "Skyscape (IL0-PROD-BASIC)"

new-civapp -name "test_powershell_vapp" -vdc $vdc -vapptemplate $vapptemplate

##Verify New vApp (might take a few minutes to appear)

get-civapp "test-powershell_vapp"

##Verify new vApp VM names

get-civapp "test_powershell_vapp"|get-civm|fl

##Change the VM name

$newvm = get-civapp test_powershell_vapp|get-civm|get-ciview

$newvm.name = "TestVM"

$newvm.updateserverdata()

##Verify Name Change

get-civapp "test_powershell_vapp"|get-civm|fl

##Power On The vApp

get-civapp "test_powershell_vapp"|start-civapp

##Power Off The vApp

get-civapp "test_powershell_vapp"|start-civapp


##Add A VM To The vApp

$vapp = get-civapp "test_powershell_vapp"|get-ciview
$catalog = get-catalog "Skyscape Catalogue"
$vapptemplate = get-civapptemplate "Skyscape_CentOS_6_4_x64_50GB_Small_v1.0.1" -Catalog $catalog|get-ciview

$source = new-object "VMware.VimAutomation.Cloud.Views.SourcedCompositionItemParam"
$source.SourceDelete = $false

$sourcedvmref = new-object "VMware.VimAutomation.Cloud.Views.Reference"
$sourcedvmref.href = $vapptemplate.children.vm[0].href
$sourcedvmref.name = "newvm"

$source.Source = $sourcedvmref


$vapp.RecomposeVApp(@(),@(),$true,$false,@($source),$null,$false,$true,$null,$vapp.name,$null)

##Delete vApp

get-civapp "test_powershell_vapp"|remove-civapp


##Add CPU/RAM
##Add External Script (because PowerCLI doesnt support adding RAM yet)
. .\set-civm.ps1

get-civapp "test_powershell_vapp"| get-civm | set-civm -MemoryMB 1024 -NumCPU 3











