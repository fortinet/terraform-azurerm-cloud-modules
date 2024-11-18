## 1.0.2 (Unreleased)

## 1.0.1 (November 15, 2024)

BUGFIXES:

* Fixed an issue when modifying the VM instance count after deployment.
* Removed automatically generated files on certain OS systems, retaining only .lic files in the License folder.
* Resolved a bug in the reselect_master() function after upgrading to the latest Azure function dependencies.
* Enhanced the logic for the initial trigger of the Azure function to prevent timeout issues.

IMPROVEMENTS:

* Added support for both user_data and custom_data in VMSS.
* Introduced support for user-defined VXLAN tunnel ports and identifiers.
* Enabled support for user-defined ports in auto-scaling.
* Updated the supported FortOS versions for different license plans.

## 1.0.0 (Septem 9, 2024)

* Initial release