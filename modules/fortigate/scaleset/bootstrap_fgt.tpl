## This is an example of FortiGate configuration. The following configuration is necessary for the Terraform example, but users can assign different values for them and add additional settings as needed.

## In this design, Port1 acts as the public port for internet communication, while Port2 functions as the private port for communication with Azure GWLB. Users can adjust these settings to suit your project needs.

config system interface
    edit ${ coalesce(public_interface_name, "port1")}
        set alias public
        set allowaccess ping https ssh
    next
end

config system interface
    edit ${coalesce(private_interface_name, "port2")}
        set alias private
        set allowaccess probe-response https
        set description "Provider"
        set defaultgw disable
        set mtu-override enable
        set mtu 1570
    next
end

config system probe-response
    set port 8008
    set http-probe-value "OK"
    set mode http-probe
end

config firewall address
    edit AzureProbeIP
        set allow-routing enable
        set subnet 168.63.129.16/32
    next
end

config router static
    edit 0
        set dst 168.63.129.16 255.255.255.255
        set gateway ${private_interface_gateway_ip_address}
        set device ${coalesce(private_interface_name, "port2")}
    next
end

config router static
    edit 0
        set dst 0.0.0.0/0
        set gateway ${public_interface_gateway_ip_address}
        set device ${coalesce(public_interface_name, "port1")}
    next
end

${custom_config}