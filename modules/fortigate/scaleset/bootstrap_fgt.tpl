## This is an example of FortiGate configuration. The following configuration is necessary for the Terraform example, but users can assign different values for them and add additional settings as needed.

## In this design, Port1 acts as the public port for internet communication, while Port2 functions as the private port for communication with Azure GWLB. Users can adjust these settings to suit your project needs.

config system interface
edit ${ coalesce(public_interface_name, "port1")}
set alias public
set mode dhcp  --->应该不需要！！
set allowaccess ping https ssh
next
edit ${ coalesce(private_interface_name, "port2") }
set alias private
set mode dhcp
set allowaccess ping https ssh --->应该不需要！！
set defaultgw disable  ---应该不需要！！
next
end

config system vxlan
    edit "extvxlan"
        set interface ${ coalesce(private_interface_name, "port2") }
        set vni 801
        set dstport 2001
        set remote-ip ${gwlb_frontend_ip_address}
    next
    edit "intvxlan"
        set interface ${ coalesce(private_interface_name, "port2") }
        set vni 800
        set dstport 2000
        set remote-ip ${gwlb_frontend_ip_address}
    next
end
config system interface
    edit ${coalesce(private_interface_name, "port2")}
        set vdom "root"   --->应该不需要！！
        set mode dhcp   --->应该不需要！！
        set allowaccess probe-response
        set description "Provider"
        set defaultgw disable
        set mtu-override enable
        set mtu 1570
    next
    edit "extvxlan"
        set vdom "root"
        set type vxlan
        set snmp-index 7
        set interface ${coalesce(private_interface_name, "port2")}
    next
    edit "intvxlan"
        set vdom "root"
        set type vxlan
        set snmp-index 8
        set interface ${coalesce(private_interface_name, "port2")}
    next
end
config system virtual-wire-pair
    edit "vxlanvwpair"
        set member "extvxlan" "intvxlan"
    next
end
config firewall policy
    edit 1
        set name "int-ext_vxlan"
        set srcintf "extvxlan" "intvxlan"
        set dstintf "extvxlan" "intvxlan"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set ssl-ssh-profile "certificate-inspection"
        set ips-sensor "default"
        set logtraffic all
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
    edit 1
        set dst 168.63.129.16 255.255.255.255
        set gateway ${private_interface_gateway_ip_address}
        set device ${coalesce(private_interface_name, "port2")}
    next
end

config router static
    edit 2
        set dst 0.0.0.0/0
        set gateway ${public_interface_gateway_ip_address}
        set device ${coalesce(public_interface_name, "port1")}

${custom_config}