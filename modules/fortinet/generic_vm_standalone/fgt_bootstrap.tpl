Content-Type: multipart/mixed; boundary="===============0086047718136476635=="
MIME-Version: 1.0

--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system sdn-connector
	edit AzureSDN
		set type azure
	next
end

%{ if custom_data_file_path != "" }
${ file(custom_data_file_path) }
%{ endif }

%{ if license_fortiflex != "" }
execute vm-license ${license_fortiflex}
execute reboot
%{ endif }

%{ if license_file_path != "" }
--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(license_file_path)}

%{ endif }
--===============0086047718136476635==--
