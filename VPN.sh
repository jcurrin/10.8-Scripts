#!/bin/sh

#  VPN.sh
#  Last modified 4/18/13
#  
#  Code contributed by Ryan Colley-Factory Labs
#  This variation will add VPN into networking preferences for Mac OS systems.  It will take the comptuer name and apply given name to the username field for VPN.

##setup VPN
vpnUuid=`uuidgen`
serverName="vpn.server.com"
labelName="Company VPN"
userName=`whoami`
userName=`echo $userName`
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

exit 0
