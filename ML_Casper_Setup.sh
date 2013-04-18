#!/bin/bash
##Integer Group 10.8 build post-image script.  This is the set of customizations we use to run after Casper has imaged a machine. Please see readme for a full detailed report of the functionality of this script.  
##Author: Joseph Currin
##Date Created: 2-6-13
##Last Modified: 3-26-13
##Code contributed from Ryan Colley-Factory Labs and Steve Wood-Integer

## Check if script has already run
if [ -e /Library/Receipts/InitialSetup.pkg ]
     then
     	/bin/echo "***initial setup script has already been run so we are exiting***"
        exit 0
     fi

##Log to debug file
set –xv; exec 1>/Library/Logs/InitialSetup.txt 2>&1
/bin/echo "***10.8 initial setup script has started***"
/bin/date

##Update dyld library cache
/usr/bin/update_dyld_shared_cache -force
/bin/echo "***updated dyld library cache***"

##Disable Startup Assistant
sudo touch /var/db/.AppleSetupDone
sudo touch /Library/Receipts/.SetupRegComplete
/bin/echo "***welcome off***"

##Determine if computer model is a Laptop or Desktop and apply power management settings
computermodel=`system_profiler SPHardwareDataType | awk '/Model Name:/ { print $3 }'`
/bin/echo "$computermodel"
case $computermodel in

	MacBook ) # Model is a laptop (MacBook Pro, MacBook, and MacBook Air)

				/bin/echo "***applying laptop power management set***"
				/usr/bin/pmset -a disksleep 10 womp 1 powerbutton 0 lidwake 0 acwake 0 halfdim 1 sms 1 hibernatemode 3 ttyskeepawake 1
				/usr/bin/pmset -b displaysleep 15 sleep 30 lessbright 1
				/usr/bin/pmset -c displaysleep 60 sleep 0 lessbright 0

				;;

	Mac ) # Model is a desktop (MacPro and Macmini)

				/bin/echo "***applying desktop power management set***"
				/usr/bin/pmset displaysleep 60 sleep 0 autorestart 1 womp 1 powerbutton 0 hibernatemode 0 ttyskeepawake 1 repeat wakeorpoweron MTWRF "05:00:00"

                 ;;

	iMac ) # Model is a desktop

				/bin/echo "***applying desktop power management set***"
				/usr/bin/pmset displaysleep 60 sleep 0 autorestart 1 womp 1 powerbutton 0 hibernatemode 0 ttyskeepawake 1 repeat wakeorpoweron MTWRF "05:00:00"
				
				;;
  
esac

##Enable Support for Assistive Devices in Universal Access
/usr/bin/touch /private/var/db/.AccessibilityAPIEnabled
/bin/echo "***enabled support for assistive devices***"

##Set network time server and timezone
/usr/sbin/systemsetup -setusingnetworktime on
/usr/sbin/systemsetup -setnetworktimeserver time.apple.com
/usr/sbin/systemsetup -settimezone America/Denver
/bin/echo "***setup time server and timezone to Denver***"

##Cleanup Installer Logs
/bin/rm -fr /Installation\ Log
/bin/echo "***removed old installation logs***"

##Stop iCloud login from Launching
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
/bin/echo "***disabled icloud setup***"

##Kill Dock Fixup
rm -R /Library/Preferences/com.apple.dockfixup.plist
/bin/echo "***removed dock fixup plist***"

##Turn off Time Machine use disk prompts
defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
/bin/echo "***disabled time machine disk prompts***"

##Disable Fast User Switching
defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool FALSE
/bin/echo "***fast user switching off***"

##Turn off Bluetooth
defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState -bool FALSE
/bin/echo "***bluetooth off***"

##Turn off Natural Scrolling
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/.GlobalPreferences.plist com.apple.swipescrolldirection -boolean FALSE
/bin/echo "***natural scrolling off***"

##Redirect Software Update Server
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://sus.company.com/content/catalogs/others/index-mountainlion-lion-snowleopard-leopard.merged-1_integer.sucatalog
/bin/echo "***SUS to company server***"

##Turn off DS_Store file creation on network volumes
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores true
/bin/echo "***DS_Store file creation off***"

##Disable the save window state at logout
/usr/bin/defaults write com.apple.loginwindow "TALLogoutSavesState" -bool FALSE
/bin/echo "***saved window state off***"

##Auto brightness adjustment off
/usr/bin/defaults write com.apple.BezelServices "dAuto" -bool false
/bin/echo "***auto brightness off***"

##Unlock System Preferences for non admins
sudo /usr/libexec/PlistBuddy -c "Set :rights:system.preferences:group everyone" /etc/authorization
/bin/echo "***non-admins can unlock system preferences***"

##Unlock Print & Scan Preference pane
sudo /usr/libexec/PlistBuddy -c "Set :rights:system.preferences.printing:group everyone" /etc/authorization
/bin/echo "***non-admins can install printers***"

##Allow non-admins to run software updates
/usr/libexec/PlistBuddy -c "Set :rights:system.install.app-store-software:rule allow" /etc/authorization
/usr/libexec/PlistBuddy -c "Set :rights:system.install.apple-software:rule allow" /etc/authorization
/usr/libexec/PlistBuddy -c "Set :rights:com.apple.SoftwareUpdate.scan:rule allow" /etc/authorization
/bin/echo "***non-admins can install os updates***"

##Set Finder to Column View
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.finder "AlwaysOpenWindowsInColumnView" -bool true
/bin/echo "***enabled finder column view***"

##Move the mini launcher to keep the icloud prompts from happening on new user setup
mv /System/Library/CoreServices/Setup\ Assistant.app/Contents/SharedSupport/MiniLauncher /System/Library/CoreServices/Setup\ Assistant.app/Contents/SharedSupport/MiniLauncher.backup
/bin/echo "***mini launcher off***"

##Create Administrator account and first delete the user folder just in case a bad installer added it first
rm -R /Users/integeradmin/
/usr/sbin/jamf createAccount -username integeradmin -realname "Admin" -password "password" -home "/Users/admin" -picture "/Library/User Pictures/Animals/A Grandi.jpg" -admin
/bin/echo "***created admin accounts***"

##Enable root account
/usr/sbin/dsenableroot -u 'admin' -p 'password' -r 'password'
/bin/echo "***enabled root***"

##Enable SSH
/usr/sbin/systemsetup -setremotelogin on
/bin/echo "***enabled ssh login***"

##Start ARD Agent
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users integeradmin -privs -all -restart -agent
/bin/echo "***ard on***"

##Set GateKeeper to allow apps to launch from anywhere
spctl --master-disable
/bin/echo "***gatekeeper off***"

##Enforce Casper management, flush previous policies and re-apply
/usr/sbin/jamf flushPolicyHistory
/usr/sbin/jamf manage
/usr/sbin/jamf enroll
/usr/sbin/jamf policy
/usr/sbin/jamf recon
/bin/echo "***enabled casper***"

##Repair Permissions
/usr/sbin/jamf fixPermissions
/bin/echo "***repaired disk permissions***"

##Remove rouge user folders.
rm -R /Users/build/
rm -R /Users/Root/
rm -R /Users/root/
rm -R /Users/user/
/bin/echo "***removed rogue user directories***"

##Remove apples info files.
rm -R /System/Library/User\ Template/Non_localized/Downloads/About\ Downloads.lpdf
rm -R /System/Library/User\ Template/Non_localized/Documents/About\ Stacks.lpdf
/bin/echo "***removed apple user template files***"

##setup VPN
vpnUuid=`uuidgen`
serverName="remote.server.com"
labelName="Company VPN"
userName=`scutil --get ComputerName`
userName=`echo $userName | tr '[A-Z]' '[a-z]'`
firstName=`echo $userName | cut -b1`
lastName=`echo $userName | grep -o " .*" | tr -d ' '`
userName=$firstName$lastName
/usr/bin/security add-generic-password -a "$groupName" -l "$labelName" -D "IPSec Shared Secret" -w "$sharedSecret" -s "$vpnUuid".SS -T /System/Library/Frameworks/SystemConfiguration.framework/Resources/SCHelper -T /Applications/System\ Preferences.app -T /System/Library/CoreServices/SystemUIServer.app -T /usr/sbin/pppd -T /usr/sbin/racoon /Library/Keychains/System.keychain
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:DNS dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:IPv4 dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:IPv4:ConfigMethod string PPP" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:IPv6 dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:IPv6:ConfigMethod string Automatic" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:Interface dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:Interface:SubType string PPTP" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:Interface:Type string PPP" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:ACSPEnabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:AuthName string $userName" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CCPEnabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CCPMPPE128Enabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CCPMPPE40Enabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommDisplayTerminalWindow integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommRedialCount integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommRedialEnabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommRedialInterval integer 5" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommRemoteAddress string $serverName" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:CommUseTerminalScript integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DialOnDemand integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DisconnectOnFastUserSwitch integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DisconnectOnIdle integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DisconnectOnIdleTimer integer 600" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DisconnectOnLogout integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:DisconnectOnSleep integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:IPCPCompressionVJ integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:IdleReminder integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:IdleReminderTimer integer 1800" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:LCPEchoEnabled integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:LCPEchoFailure integer 15" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:LCPEchoInterval integer 20" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:Logfile string /var/log/ppp.log" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:PPP:VerboseLogging integer 0" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:Proxies dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:Proxies:FTPPassive integer 1" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:SMB dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :NetworkServices:$vpnUuid:UserDefinedName string $labelName" /Library/Preferences/SystemConfiguration/preferences.plist
autoUuid=`/usr/libexec/Plistbuddy -c "Print :Sets" /Library/Preferences/SystemConfiguration/preferences.plist | grep -B1 -m1 Automatic | grep Dict | awk '{ print $1 }'`
/usr/libexec/PlistBuddy -c "Add :Sets:$autoUuid:Network:Service:$vpnUuid dict" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :Sets:$autoUuid:Network:Service:$vpnUuid:__LINK__ string \/NetworkServices\/$vpnUuid" /Library/Preferences/SystemConfiguration/preferences.plist
/usr/libexec/PlistBuddy -c "Add :Sets:$autoUuid:Network:Global:IPv4:ServiceOrder: string $vpnUuid" /Library/Preferences/SystemConfiguration/preferences.plist
bin/echo "***installed vpn configuration***"


## Remove system log just in case our passwords are there.
/bin/rm -rf /var/log/system.log
/bin/echo "***deleted system log***"

## Write dummy receipt, to prevent script from running again.
touch /Library/Receipts/InitialSetup.pkg
/bin/echo "***created initial setup installer receipt***"

##set the login window to show username and password field
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -boolean YES
/bin/echo "***username field on***"

##Echo a status
/bin/echo "***10.8 initial setup script has completed***"
/bin/date

##Reboot
/sbin/shutdown -r now