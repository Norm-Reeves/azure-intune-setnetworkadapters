# Set IP & DNS to DHCP
Get-NetAdapter | Set-NetIPInterface -Dhcp Enabled

# Set DNS server settings to automatically obtain (DHCP)
Set-DnsClientServerAddress -InterfaceAlias * -ResetServerAddresse

# Clear WINS server addresses
$networkAdapters = Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE"
# Set WINS server addresses for each network adapter
foreach ($adapter in $networkAdapters) {
    $params = @{
        WINSPrimaryServer = ""
        WINSSecondaryServer = ""
    }
    
    # Invoke the SetWINSServer method for each adapter
    Invoke-CimMethod -InputObject $adapter -MethodName SetWINSServer -Arguments $params
}


# Disables IPv6 on all adapters
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6

netsh interface ip set wins name="Ethernet" source=dhcp

# Set NetBIOS over TCP/IP to default on all adapters
Get-NetAdapter | Set-NetTCPSetting -NetBios over TCP/IP Default

# Enable LMHOSTS lookup
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableLMHOSTS" -Value 1

# Flush DNS cache
ipconfig /flushdns
