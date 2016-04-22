##taken from www.elmundio.net

function Set-CIVM
{
    [cmdletbinding()]
    param
    (
        [Parameter(ParameterSetName="pipeline",ValueFromPipeline=$true,Mandatory=$true)]$vm,
        [Parameter()][Int]$MemoryMB=0,
        [Parameter()][Int]$NumCpu=0
    )
 
    Process
    {
        if ($vm -is [System.String])
        {
            $vm = get-civm $vm
        }
 
        $vmHardware = $vm.ExtensionData.GetVirtualHardwareSection()
 
        #Get the XML with the values we need to change
        $hardwareContentType = "application/vnd.vmware.vcloud.virtualHardwareSection+xml"
        $webclient = New-Object system.net.webclient
        $webclient.Headers.Add("x-vcloud-authorization",$vmHardware.Client.SessionKey)
        $webclient.Headers.Add("accept","${hardwareContentType};version=5.1")
        [xml]$hardwareConfXML = $webclient.DownloadString($vmhardware.href)
 
        if($MemoryMB -ne 0){
            $memoryNode = $hardwareConfXML.VirtualHardwareSection.item | where {$_.resourcetype -eq 4}
            $memoryNode.VirtualQuantity = "${MemoryMB}"
            $memoryNode.ElementName = "${MemoryMB} MB of memory"
        }
 
        if($NumCpu -ne 0){
            $CPUNode = $hardwareConfXML.VirtualHardwareSection.item | where {$_.resourcetype -eq 3}
            $CPUNode.VirtualQuantity = "${NumCpu}"
            $CPUNode.ElementName = "${NumCpu} virtual CPU(s)"
        }
 
        # PUT the data back through vCloud API
        $request = [System.Net.WebRequest]::Create($vmHardware.href);
        $request.Headers.Add("x-vCloud-authorization",$vmHardware.Client.SessionKey)
        $request.Accept="application/vnd.vmware.vcloud.task+xml;version=5.1"
        $request.Method="PUT"
        $request.ContentType = $hardwareContentType
        $postData = $hardwareConfXML.virtualhardwaresection.outerxml
        $xmlString = $postData.replace([Environment]::NewLine ,"") # remove junk newline characters
        [byte[]]$xmlEnc = [System.Text.Encoding]::UTF8.GetBytes($xmlString)
        $request.ContentLength = $xmlEnc.length
        [System.IO.Stream]$requestStream = $request.GetRequestStream()
        $requestStream.write($xmlEnc, 0, $xmlEnc.Length)
        $requestStream.Close()
        $response = $request.GetResponse()
        $responseStream = $response.getResponseStream()
        $streamReader = new-object System.IO.StreamReader($responseStream)
        $result = $streamReader.ReadtoEnd()
        $streamReader.close()
        $response.close()
    }
}