# vAppClone to Another Catalog
How to move vApps between VDCs

Enter vApp name - the vApp container source name

Enter new vApp name - the name for the new vApp container

Enter Catalog name - needs to exist already

Option to deploy after cloning if selected to deploy the vApp will be in a started state

The new vApp will be deployed and all residing VMs are an exact clone of the orginials (same IP, MAC, GUIDs etc).  The network will also be in a fenced state, meaning that 
the vApp is isolated ensuring there is no conflict with the original machines
