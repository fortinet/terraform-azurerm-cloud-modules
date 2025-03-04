## This is an example of FortiGate configuration. The following configuration is necessary for the Terraform examples, but users can assign different values for them and add additional settings as needed.

## In this design, Port1 acts as the public port for internet communication, while Port2 functions as the private port for communication with internal load balancers. Users can adjust these settings to suit your project needs.

config system sdn-connector
	edit AzureSDN
		set type azure
	end
end

config vpn ssl settings
    set port 7443
end

config sys global
    set hostname "fgtvmss"
    set admin-sport 443
end

config system interface
    edit ${coalesce(public_interface_name, "port1")}
        set alias public
        set allowaccess ping https ssh probe-response
    next
end

config system interface
    edit ${coalesce(private_interface_name, "port2")}
        set alias private
        set allowaccess probe-response
        set description "Provider"
        set defaultgw disable
        set mtu-override enable
        set mtu 1570
    next
end

config router static
    edit 0
        set dst 168.63.129.16 255.255.255.255
        set gateway ${private_interface_gateway_ip_address}
        set device ${coalesce(private_interface_name, "port2")}
    next
    edit 0
        set dst 0.0.0.0/0
        set gateway ${public_interface_gateway_ip_address}
        set device ${coalesce(public_interface_name, "port1")}
    next
    edit 0
        set dst 168.63.129.16 255.255.255.255
        set gateway ${public_interface_gateway_ip_address}
        set device ${coalesce(public_interface_name, "port1")}
    next
end

${custom_config}