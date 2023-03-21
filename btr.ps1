<#
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Script: Brad The Ripper
░░░░░░░░░░░░░▒▓▒░░░░░░░░░░░░░░ Version: Beta_1.0
░░░░░░░░░░░░▒███▒░░░░░░░░░░░░░ Date: 8-2-16
░░░░░░░░░░░░▓███▓░░░░░░░░░░░░░ Auth: Brad Lindsley  
░░░░░░░░░░░░▓███▓░░░░░░░░░░░░░ Contact: brad.lindsley@gmail.com
░░░░░░░░░░░░▓███▓░░░░░░░░░░░░░ Powershell Version: 5
░░░░░░░░░░░░▓███▓░░░░░░░░░░░░░
░░░░▓██▓░░░░▓███▓░░░░▓██▓░░░░░
░░▒▓███▓░░░░▓███▓░░░░▓███▓▒░░░
░▒▓████▓░░░░▓███▓░░░░▓████▓▒░░
░▓████▓░░░░░▓███▓░░░░░▓████▓░░
▓████▓░░░░░░▓███▓░░░░░░▓████▓░
▓████▓░░░░░░▓███▓░░░░░░░▓████▓
▓████▓░░░░░░▓███▓░░░░░░░▓████▓
▓████▓░░░░░░░███▒░░░░░░░▓████▓
▓████▓░░░░░░░▒▓▒░░░░░░░░▓████▓
▓█████▒░░░░░░░░░░░░░░░░░█████▓
░▓█████▒░░░░░░░░░░░░░░▒█████▓░
░░▓██████▒░░░░░░░░░░░▒██████▓░
░░░▓███████▓▒░░░░░▒▓███████▓░░
░░░░░▓███████████████████▓░░░░
░░░░░░░▓████████████████▓░░░░░
░░░░░░░░░░▓██████████▓▒░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#>
#config
$config_logo=1
$config_net_info=1
$config_users=1
$config_temp=1
$config_mounted_drives=1
$config_user_directory_listing=1
$config_IOI=1
$config_POI=1
$config_downloaded=1
$config_autoruns=1
$config_sys_internal_sys_info=1
$config_shimcache=1
$config_tasks=1
#global Variables

$reports= "Reports\"
$date= Get-Date -Format MM-dd-yy-HH-mm-ss
$filename= "$date" + "-btr.txt"
$users=gci C:\Users
$script_path = $(get-location).Path

#forensic Details
#Items,names,projects,etc of interest
$IOI= @("raptor" , "tree")

#programs of interest (i.e. peer to peer, filesharing, tor, etc)
$POI= @("dropbox", "drive" , "Redline", "chrome" )

#######################start script#########################################

function main
{

if ( $config_logo -eq 1)
    {
    logo
    }
if ( $config_net_info -eq 1)
    {
    net_info
    }

if ( $config_users -eq 1)
    {
    users
    }
if ( $config_temp -eq 1)
    {
    temp
    }
if ( $config_mounted_drives -eq 1)
    {
    mounted_drives
    }
if ( $config_user_directory_listing -eq 1)
    {
    user_directory_listing
    }
if ( $config_IOI -eq 1)
    {
    IOI
    }
if ( $config_POI-eq 1)
    {
    POI
    }
if ( $config_downloaded -eq 1)
    {
    downloaded
    }
    if ( $config_tasks -eq 1 )
    {
    tasks
    }
#####PLUGINS#####
    if ( $config_autoruns -eq 1)
    {
    autoruns
    }
    if ( $config_sys_internal_sys_info -eq 1)
    {
    sys_internal_sys_info
    }
    if ( $config_shimcache -eq 1 )
    {
    shimcache
    }


}


#creates box around text items for report
function prettybox
{
Param(
[string]$text)
$top="*" * 49
$bottom="*"*49
$count= $text | measure-object -character | select -expandproperty characters
$number= 50-$count
$divide=$number/2
$space=""
$middle= "*" * $divide + $text + "*" * $divide
$space | Add-Content "$reports\$filename"
$top | Add-Content "$reports\$filename"
$middle | Add-Content "$reports\$filename"
$bottom | Add-Content "$reports\$filename"
$space | Add-Content "$reports\$filename"
}

function file_scan_dump
{
Param(
[string]$directory
)
    $scan=gci -Recurse $directory -ErrorAction SilentlyContinue | select Fullname,LastAccessTime,LastWriteTime
    $header="Path" + ",Last Access Time" + ",LastWriteTime" +",hash" | Add-Content "$reports\$filename" 
        foreach ( $file in $scan )
        {
           $scan_filepath=($file).FullName
           $scan_name_hash=Get-FileHash $scan_filepath -Algorithm MD5 | select Hash
           ($file).Fullname + "," + ($file).LastAccessTime + ","  + ($file).LastWriteTime + "," + ($scan_name_hash).Hash | Add-Content "$reports\$filename" 
        }
}



#fun with terrible program name
function logo
{
echo "
  ___.___    ____         _____________
  \  \\  \   ,, |___     |       '\\\\\\
   \  \\  \ /<   ?       |        ' ____|_
    --\//,- \_.  /_____  |        '||::::::
        o- /   \_/    '\ |        '||_____|
        | \ '   o       \'________|_____|
        |  )-   #     <  ___/____|___\___
        `_/'------------|    _    '  <<<:|
            /________\| |_________'___o_o| 
 ____   ____    ____  ___        ______  __ __    ___      ____   ____  ____  ____   ___  ____  
|    \ |    \  /    ||   \      |      ||  |  |  /  _]    |    \ |    ||    \|    \ /  _]|    \ 
|  o  )|  D  )|  o  ||    \     |      ||  |  | /  [_     |  D  ) |  | |  o  )  o  )  [_ |  D  )
|     ||    / |     ||  D  |    |_|  |_||  _  ||    _]    |    /  |  | |   _/|   _/    _]|    / 
|  O  ||    \ |  _  ||     |      |  |  |  |  ||   [_     |    \  |  | |  |  |  | |   [_ |    \ 
|     ||  .  \|  |  ||     |      |  |  |  |  ||     |    |  .  \ |  | |  |  |  | |     ||  .  \
|_____||__|\_||__|__||_____|      |__|  |__|__||_____|    |__|\_||____||__|  |__| |_____||__|\_|" | Add-Content "$reports\$filename"

}

#network connection information at time of running scan
function net_info
{
prettybox -text "net_info"
$hostname=hostname
$netinfo=ipconfig /all | Add-Content "$reports\$filename"
$net_stat1=netstat -a | Add-Content "$reports\$filename"
$net_stat2=netstat -f | Add-Content "$reports\$filename"
$net_stat3=netstat -b | Add-Content "$reports\$filename"
$net_stat4=netstat -n | Add-Content "$reports\$filename"
$net_stat5=netstat -o | Add-Content "$reports\$filename"
}

#users on the box
function users
{
prettybox -text "Users"
$users=gci C:\Users
$users | Add-Content "$reports\$filename"
}

#temporary files per user
function temp
{
prettybox -text temp
foreach ( $user in $users )
    {
    file_scan_dump -directory "c:\Users\$user\AppData\Local\Temp"
    }
}

function tasks
{
prettybox -text "Scheduled Tasks"
Get-Content C:\Windows\Tasks\SCHEDLGU.TXT | Add-Content "$reports\$filename"
}
#any  mounted drives during scan
function mounted_drives
{
prettybox -text "Mounted Drives"
gwmi win32_volume | select DriveLetter,Caption | Add-Content "$reports\$filename"
}

#basic fornesic of all files in user folders for backup
function user_directory_listing
{
prettybox -text "User Directory File Listing"
file_scan_dump -directory "C:\Users\"

}

#Items of interest backend
function IOI
{
prettybox -text "Items of Inturest"
echo "Items of Interest" |  Add-Content "$reports\$filename"
echo "Items looked for: $IOI" |  Add-Content "$reports\$filename"
Foreach ($item in $IOI) 
    {
    #add Timestamping
    #add hashing
    $IOI_scan=gci -Recurse c:\ -ErrorAction SilentlyContinue | findstr "$item" | Add-Content "$reports\$filename"
    }
}

#Programs of interest backend
function POI
{
prettybox -text "Programs of Interest"
echo "Programs looked for: $POI" |  Add-Content "$reports\$filename"
Foreach ($program in $POI) 
    {
    #add Timestamping
    #add hashing
    #add if exsists look for still ounted folder
    $POI_scan=gci -Recurse "c:\Program Files" -ErrorAction SilentlyContinue | findstr -i "$program" | Add-Content "$reports\$filename"
    }
}

#Downloads folder per user
function downloaded
{
prettybox -text "downloaded content"
foreach ( $user in $users )
    {
    file_scan_dump -directory "c:\Users\$user\Downloads"
    }
}

#hashtag:savetheplanet
function recycle
{
prettybox -text Recycle_bin

}

#startup folder
function startup_items
{
prettybox -text "Startup Folder"
foreach ( $user in $users )
    {
    $startup_item= gci -Recurse "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu" -ErrorAction SilentlyContinue | select Fullname,LastAccessTime,LastWriteTime | Add-Content "$reports\$filename"
    
}
}

function programs_installed
{
prettybox -text "installed programs"
gci 'C:\Program Files' -Recurse -ErrorAction SilentlyContinue | findstr *.exe
#add Hash
}

function shellbag
{
prettybox -text "Shellbag"


}

function MRU
{
prettybox -text "MRU"
#add Add MRU
}

function amcache
{
prettybox -text AMCache
#Add AMCache
}

function browser_history
{
#prettybox -text Browser History
#ADD BROWSER HISTORY

}

#Ceck for certs?

#Prefetch? Accessfile list

#Event Log Dump
    #Errors
    #Connections
    #
###################################################################################
#                            3rd party Plugins                                    #
###################################################################################

#Sysinternals content
function autoruns
{
prettybox -text "autoruns"
Plugins\SysinternalsSuite\autorunsc.exe -a ibdwostw -h | Add-Content "$reports\$filename"
}

function sys_internal_sys_info
{
prettybox -text "Sys info + Installed Programs\Updates"
Plugins\SysinternalsSuite\psinfo.exe -s -nobanner | Add-Content "$reports\$filename"
}

#mandiant

function shimcache
{
prettybox -text "shimcache"
Plugins\Mandiant\ShimCacheParser.exe -l -o C:\Users\raptor\Desktop\btr\Plugins\Mandiant\cache\shim.csv
$shim= Get-Content C:\Users\raptor\Desktop\btr\Plugins\Mandiant\cache\shim.csv
$shim | Add-Content "$reports\$filename"
echo "Programs of interest" | Add-Content "$reports\$filename"
foreach ( $program in $POI )
    {
       $shim | findstr $program | Add-Content "$reports\$filename"
    }
}

function redline_nonmem
{

C:\Users\raptor\Desktop\btr\Plugins\Mandiant\redline_nonmem\RunRedlineAudit.bat


}

function redline_mem
{
C:\Users\raptor\Desktop\btr\Plugins\Mandiant\redline_mem\RunRedlineAudit.bat

}

#TIMESTOMPER CHECK
#>
main
