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

%{ if fgt_custom_data_file_path != "" }
${ file(fgt_custom_data_file_path) }
%{ endif }

%{ if fgt_license_fortiflex != "" }
execute vm-license ${fgt_license_fortiflex}
%{ endif }

%{ if fgt_license_file_path != "" }
--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(fgt_license_file_path)}

%{ endif }
--===============0086047718136476635==--