## Storage Profile Usage ##

This directory contains sample scripts making use of the vCloud Director API directly to query your storage profile usage.

To run the ruby scripts you will need to set the following environment variables containing your Skyscape Cloud user credentials:
```
VCD_ORG=1-2-33-456789
VCD_USERNAME=1234.5.67890
VCD_PASSWORD=Secret
```
The scripts were developed and tested using the [Chef Development Kit](https://downloads.chef.io/chef-dk/) and were executed by running:
```
chef exec ruby storage_profile.rb
```