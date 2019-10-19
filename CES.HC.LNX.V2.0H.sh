#!/bin/bash
#Author:CES.HC.RHEL
#Created Date:2015-08-13
#Main Function:Collect AIX formation.
#Environment:RHEL 5.X/6.x
#Logical:
#Description for variable and function:
#Version:2.0

export LANG=C


#HCLogTime=`date +%Y%m%d%H%M%S`
HCLogTime=`date +%Y%m%d`
HCHost=`hostname`
HCWorkDir="/tmp"
HCLogDir="$HCWorkDir/$HCHost$HCLogTime"
mkdir -p "$HCLogDir"
cd $HCWorkDir

if [ -f /etc/redhat-release ]
then
   cat /etc/redhat-release | grep "5\."
   if [ $? = 0 ]
   then
     OSType="RHEL 5"
     OSLevel="5.X"
   else
     OSType="RHEL 6"
     OSLevel="6.X"
   fi    
else
  OSType="NotSupport"
  OSLevel="0.X"
fi

HCLogDirFile0="$HCLogDir/hclnx.0.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
#echo "OSType:" `lsb_release -i | awk '{print $3}'`                   >> $HCLogDirFile0 2>&1
#echo "OSLevel:" `lsb_release -r | awk '{print $2}'`                  >> $HCLogDirFile0 2>&1
echo "OSType: $OSType"                                               >> $HCLogDirFile0 2>&1
echo "OSLevel: $OSLevel"                                             >> $HCLogDirFile0 2>&1
echo "HostName:" `hostname`                                          >> $HCLogDirFile0 2>&1
echo "OS_UUID:"`dmidecode -t 1 | grep UUID | awk '{print $2}'`       >> $HCLogDirFile0 2>&1
echo "OS Time:"`date '+%Y-%m-%d %H:%M:%S'`                           >> $HCLogDirFile0 2>&1
echo "IP Addr:"`hostname -i`                                         >> $HCLogDirFile0 2>&1
echo "OS UTC:"`date | awk '{print $5}'`                              >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

if [ "$OSType" = "NotSupport" ]
then
  echo "Notice: The OS not support, exit"
  exit 0
fi

HCLogDirFile0="$HCLogDir/hclnx.dmidecode-instance.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
dmidecode | grep ^Handle | awk  '{print $2,$5}'                      >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.dmidecode.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
dmidecode                                                            >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.rpmqa.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
rpm -qa                                                              >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.os.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
echo "hostname: `hostname`"                                          >> $HCLogDirFile0 2>&1
echo "ipaddr: `hostname -i`"                                         >> $HCLogDirFile0 2>&1
#echo "OSRelease: `lsb_release -r | awk '{print $2}'`"                >> $HCLogDirFile0 2>&1
echo "OSRelease: $OSLevel"                                           >> $HCLogDirFile0 2>&1
echo "OSKernel: `uname -r`"                                          >> $HCLogDirFile0 2>&1
echo "RunLevel: `who -r | awk '{print $2}'`"                         >> $HCLogDirFile0 2>&1
echo "uptime: `cat /proc/uptime | awk '{print $1/60}'`"              >> $HCLogDirFile0 2>&1
echo "OSTime: `date '+%Y-%m-%d %H:%M:%S'`"                           >> $HCLogDirFile0 2>&1
echo "OSUTC: `date | awk '{print $5}'`"                              >> $HCLogDirFile0 2>&1
CRKrl=`cat /boot/grub/grub.conf | grep crashkernel | awk '{print $1}'`
if [ -z $CRKrl ]
then
  echo "kdump: Disable"                                              >> $HCLogDirFile0 2>&1
else
  echo "kdump: Enable"                                               >> $HCLogDirFile0 2>&1
fi
ntp -p >> /dev/null 2>&1
if [ $? -ne 0 ]
then
  echo "NTP: Invalid"                                                >> $HCLogDirFile0 2>&1
else
  echo "NTP: Normal"                                                 >> $HCLogDirFile0 2>&1
fi
SSHROOT=`cat /etc/ssh/sshd_config | grep -v "#" | grep -v "^$" | grep PermitRootLogin`
if [ -z $SSHROOT ]
then
  echo "SSH: No Permit Root Login"                                   >> $HCLogDirFile0 2>&1
else
  echo "SSH: Permit Root Login"                                      >> $HCLogDirFile0 2>&1
fi
CTRLALTDEL=`cat /etc/inittab | grep -v "#" | grep -v "^$" | grep ctrlaltdel | awk '{print $1}'`
if [ -z $CTRLALTDEL ]
then
  echo "Ctrl-Alt-Del: No Permit Ctrl-Alt-Del"                        >> $HCLogDirFile0 2>&1
else
  echo "Ctrl-Alt-Del: Permit Ctrl-Alt-Del"                           >> $HCLogDirFile0 2>&1
fi
OFILES=`ulimit -a | grep -E "open files" | awk -F")"  '{print $2}'`
if [ $OFILES -gt 1024 ]
then
  echo "ulimit open files: OK"                                       >> $HCLogDirFile0 2>&1
else
  echo "ulimit open files: Err"                                      >> $HCLogDirFile0 2>&1
fi
MAXP=`ulimit -a | grep -E "max user processes" | awk -F")"  '{print $2}'`
if [ $MAXP -gt 1024 ]
then
  echo "ulimit max user processes: OK"                               >> $HCLogDirFile0 2>&1
else
  echo "ulimit max user processes: Err"                              >> $HCLogDirFile0 2>&1
fi
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.lsmod.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
lsmod                                                                >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sysctl.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sysctl -a                                                            >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.chkconfig.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
chkconfig --list                                                     >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.service.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
service --status-all                                                 >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.cpuinfo.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /proc/cpuinfo                                                    >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.meminfo.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /proc/meminfo                                                    >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-u.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -u 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-q.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -q 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-r.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -r 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-b1.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -B 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.vmstat.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
vmstat 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.iostat.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
iostat  -x 5 1                                                       >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.ps.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
ps H -A -o cmd,stat,ppid,pid,tid,%cpu,nice,%mem,vsz,rss,user,time    >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.fdisk.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
fdisk -l 2>/dev/null                                                 >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.vgs.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
vgs                                                                  >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.pvs.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
pvs                                                                  >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.lvs.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
lvs                                                                  >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.fstab.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /etc/fstab | grep -v ^#                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.dumpe2fs.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
for i in `blkid | grep UUID  | grep mapper  | awk -F: '{print $1}'`
do
echo "value:$i"                                                      >> $HCLogDirFile0 2>&1
echo "----$i----begin----"                                           >> $HCLogDirFile0 2>&1
dumpe2fs $i                                                          >> $HCLogDirFile0 2>&1
echo "----$i----end------"                                           >> $HCLogDirFile0 2>&1
done                                                   
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-b2.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -b 5 12                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.df-h.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
df -h                                                                >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.df-i.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
df -i                                                                >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.lspci.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
lspci                                                                >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.ethtool.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
for i in `netstat -in  | grep -vE "Kernel|Iface|lo" | awk '{print $1}'`
do
echo "value:$i"                                                      >> $HCLogDirFile0 2>&1
echo "----------------"                                              >> $HCLogDirFile0 2>&1
ethtool $i                                                           >> $HCLogDirFile0 2>&1
echo "----------------"                                              >> $HCLogDirFile0 2>&1
done                                                   
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.sar-n.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
sar -n DEV 5 12                                                      >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.ifconfig.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
ifconfig                                                             >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.netstat-rn.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
netstat -rn                                                          >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.messages.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /var/log/messages                                                >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.dmesg.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /var/log/dmesg                                                   >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.secure.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /var/log/secure                                                  >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.cron.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /var/log/cron                                                    >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.audit.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
cat /var/log/audit/audit.log                                         >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hclnx.ulimit.log"
> $HCLogDirFile0
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
ulimit -a                                                            >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

#some information backup
rpm -qa --queryformat "%-35{NAME} %-35{DISTRIBUTION} %{VERSION}-%{RELEASE}\n" | sort -k 1,2 -t " " -i > $HCLogDir/$HCHost.$HCLogTime.rpm-version.log
#multipath -ll                                                        > $HCLogDir/$HCHost.$HCLogTime.multipath-ll.log
rpm -qa --last                                                       > $HCLogDir/$HCHost.$HCLogTime.rpm-qa-last.log
netstat -s                                                           > $HCLogDir/$HCHost.$HCLogTime.netstat-s.log
/sbin/dmsetup ls --tree                                              > $HCLogDir/$HCHost.$HCLogTime.dmsetup-ls-tree.log
/sbin/dmsetup table                                                  > $HCLogDir/$HCHost.$HCLogTime.dmsetup-table.log
/sbin/dmsetup info                                                   > $HCLogDir/$HCHost.$HCLogTime.dmsetup-info.log
ls -al /etc/rc3.d/                                                   > $HCLogDir/$HCHost.$HCLogTime.ls-al.rc3.d.log
ls -al /etc/rc5.d/                                                   > $HCLogDir/$HCHost.$HCLogTime.ls-al.rc5.d.log
pstree                                                               > $HCLogDir/$HCHost.$HCLogTime.pstree.log
ps alx                                                               > $HCLogDir/$HCHost.$HCLogTime.ps-alx.log
mount                                                                > $HCLogDir/$HCHost.$HCLogTime.mount.log
blkid                                                                > $HCLogDir/$HCHost.$HCLogTime.lsmcblkidode.log
pvdisplay                                                            > $HCLogDir/$HCHost.$HCLogTime.pvdisplay.log
vgdisplay                                                            > $HCLogDir/$HCHost.$HCLogTime.vgdisplay.log
lvdisplay                                                            > $HCLogDir/$HCHost.$HCLogTime.lvdisplay.log
lspci -vvv                                                           > $HCLogDir/$HCHost.$HCLogTime.lspci-vvv.log
lspci -vmm                                                           > $HCLogDir/$HCHost.$HCLogTime.lspci-vmm.log
ip addr list                                                         > $HCLogDir/$HCHost.$HCLogTime.ipaddlist.log
cat /etc/crontab                                                     > $HCLogDir/$HCHost.$HCLogTime.etc.crontab.txt
cat /etc/aliases                                                     > $HCLogDir/$HCHost.$HCLogTime.etc.aliases.txt
cat /etc/blkid/blkid.tab                                             > $HCLogDir/$HCHost.$HCLogTime.etc.blkid.tab.txt
cat /etc/exports                                                     > $HCLogDir/$HCHost.$HCLogTime.etc.exports.txt
cat /etc/environment                                                 > $HCLogDir/$HCHost.$HCLogTime.etc.environment.txt
cat /etc/filesystems                                                 > $HCLogDir/$HCHost.$HCLogTime.etc.filesystems.txt
cat /etc/issue                                                       > $HCLogDir/$HCHost.$HCLogTime.etc.issue.txt
cat /etc/inittab                                                     > $HCLogDir/$HCHost.$HCLogTime.etc.inittab.txt
cat /etc/issue.net                                                   > $HCLogDir/$HCHost.$HCLogTime.etc.issue.net.txt
cat /etc/sysconfig/i18n                                              > $HCLogDir/$HCHost.$HCLogTime.etc.sysconfig.i18n.txt
cat /etc/sysconfig/network                                           > $HCLogDir/$HCHost.$HCLogTime.etc.sysconfig.network.txt
cat /etc/sysconfig/kdump                                             > $HCLogDir/$HCHost.$HCLogTime.etc.sysconfig.kdump.txt
cat /etc/udev/udev.conf                                              > $HCLogDir/$HCHost.$HCLogTime.etc.udev.conf.txt
cat /proc/cmdline                                                    > $HCLogDir/$HCHost.$HCLogTime.proc.cmdline.txt
cat /proc/buddyinfo                                                  > $HCLogDir/$HCHost.$HCLogTime.proc.buddyinfo.txt
cat /proc/iomem                                                      > $HCLogDir/$HCHost.$HCLogTime.proc.iomem.txt
cat /proc/locks                                                      > $HCLogDir/$HCHost.$HCLogTime.proc.locks.txt
cat /proc/devices                                                    > $HCLogDir/$HCHost.$HCLogTime.proc.devices.txt
cat /proc/diskstats                                                  > $HCLogDir/$HCHost.$HCLogTime.proc.diskstats.txt
cat /proc/dma                                                        > $HCLogDir/$HCHost.$HCLogTime.proc.dma.txt
cat /proc/filesystems                                                > $HCLogDir/$HCHost.$HCLogTime.proc.filesystems.txt
cat /proc/ioports                                                    > $HCLogDir/$HCHost.$HCLogTime.proc.ioports.txt
cat /proc/loadavg                                                    > $HCLogDir/$HCHost.$HCLogTime.proc.loadavg.txt
cat /proc/mdstat                                                     > $HCLogDir/$HCHost.$HCLogTime.proc.mdstat.txt
cat /proc/modules                                                    > $HCLogDir/$HCHost.$HCLogTime.proc.modules.txt
cat /proc/partitions                                                 > $HCLogDir/$HCHost.$HCLogTime.proc.partitions.txt
#cat /proc/pagetypeinfo                                               > $HCLogDir/$HCHost.$HCLogTime.proc.pagetypeinfo.txt
cat /proc/slabinfo                                                   > $HCLogDir/$HCHost.$HCLogTime.proc.slabinfo.txt
cat /proc/vmstat                                                     > $HCLogDir/$HCHost.$HCLogTime.proc.vmstat.txt
cat /proc/zoneinfo                                                   > $HCLogDir/$HCHost.$HCLogTime.proc.zoneinfo.txt
cat /proc/mounts                                                     > $HCLogDir/$HCHost.$HCLogTime.proc.mounts.txt
#cat /etc/multipah.conf                                               > $HCLogDir/$HCHost.$HCLogTime.etc.multipah.conf.txt
cat /etc/resolv.conf                                                 > $HCLogDir/$HCHost.$HCLogTime.etc.resolv.conf.txt
cat /etc/selinux/config                                              > $HCLogDir/$HCHost.$HCLogTime.etc.selinux.config.txt
#cat /etc/vsftp/vsftp.conf                                            > $HCLogDir/$HCHost.$HCLogTime.etc.vsftp.conf.txt
cat /etc/rc.local                                                    > $HCLogDir/$HCHost.$HCLogTime.etc.rc.local.txt
cat /etc/lvm/lvm.conf                                                > $HCLogDir/$HCHost.$HCLogTime.etc.lvm.conf.txt
cat /etc/lvm/cache/.cache                                            > $HCLogDir/$HCHost.$HCLogTime.etc.lvm.cache.txt
lsb_release -a                                                       > $HCLogDir/$HCHost.$HCLogTime.lsb_release.log
uname -a                                                             > $HCLogDir/$HCHost.$HCLogTime.uname-a.log
dmidecode                                                            > $HCLogDir/$HCHost.$HCLogTime.dmidecode.log
cat /etc/hosts                                                       > $HCLogDir/$HCHost.$HCLogTime.host.txt
cat /etc/security/limits.conf                                        > $HCLogDir/$HCHost.$HCLogTime.limits.txt
cat /etc/passwd                                                      > $HCLogDir/$HCHost.$HCLogTime.password.txt
cat /etc/group                                                       > $HCLogDir/$HCHost.$HCLogTime.group.txt
cat /etc/shadow                                                      > $HCLogDir/$HCHost.$HCLogTime.shadow.txt
cat /etc/profile                                                     > $HCLogDir/$HCHost.$HCLogTime.profile.txt
cat /etc/pam.d/passwd                                                > $HCLogDir/$HCHost.$HCLogTime.pam-password.txt
#cat /etc/pam.d/password-auth                                        > $HCLogDir/$HCHost.$HCLogTime.pam-password-auth.txt
#cat /etc/pam.d/password-auth-ac                                     > $HCLogDir/$HCHost.$HCLogTime.pam-password-auth-ac.txt
cat /etc/ssh/sshd_config                                             > $HCLogDir/$HCHost.$HCLogTime.sshd_config.txt
cat /etc/ntp.conf                                                    > $HCLogDir/$HCHost.$HCLogTime.ntp.conf.txt
#cat /etc/rsyslog.conf                                               > $HCLogDir/$HCHost.$HCLogTime.rsyslog.txt
#cat /etc/syslog.conf                                                 > $HCLogDir/$HCHost.$HCLogTime.rsyslog.txt
cat /etc/services                                                    > $HCLogDir/$HCHost.$HCLogTime.services.txt
netstat -na | grep  LISTEN                                           > $HCLogDir/$HCHost.$HCLogTime.netstat-LISTEN.txt
crontab -l                                                           > $HCLogDir/$HCHost.$HCLogTime.crontab.txt
lsof                                                                 > $HCLogDir/$HCHost.$HCLogTime.lsof.log
cat /etc/sysconfig/network-scripts/ifcfg-*                           > $HCLogDir/$HCHost.$HCLogTime.ifcfg.txt
cat /etc/sysconfig/network                                           > $HCLogDir/$HCHost.$HCLogTime.network.txt
netstat -na                                                          > $HCLogDir/$HCHost.$HCLogTime.netstat-a.log
cat /etc/sysctl.conf                                                 > $HCLogDir/$HCHost.$HCLogTime.etc-sysctl.txt
sysctl  -a                                                           > $HCLogDir/$HCHost.$HCLogTime.sysctl-a.log
cat /boot/grub/device.map                                            > $HCLogDir/$HCHost.$HCLogTime.device-map.txt
cat /boot/grub/grub.conf                                             > $HCLogDir/$HCHost.$HCLogTime.grub-conf.txt
cat /root/.bash_history                                              > $HCLogDir/$HCHost.$HCLogTime.root-base_history.txt
history                                                              > $HCLogDir/$HCHost.$HCLogTime.history.log
#tree /sys                                                            > $HCLogDir/$HCHost.$HCLogTime.tree-sys.log
pvs                                                                  > $HCLogDir/$HCHost.$HCLogTime.pvs.log
vgs                                                                  > $HCLogDir/$HCHost.$HCLogTime.vgs.log
lvs                                                                  > $HCLogDir/$HCHost.$HCLogTime.lvs.log
blkid                                                                > $HCLogDir/$HCHost.$HCLogTime.blkid.log

echo "########smartctl####BEGIN########"                             > $HCLogDir/$HCHost.$HCLogTime.smartctl.log
for i in `fdisk -l 2>/dev/null | grep ^Disk | awk '{print $2}' | sed s/://g`	
do	
	echo "value:$i"                                                    >> $HCLogDir/$HCHost.$HCLogTime.smartctl.log
	echo "----BEGIN----"                                               >> $HCLogDir/$HCHost.$HCLogTime.smartctl.log
	smartctl --all $i                                                  >> $HCLogDir/$HCHost.$HCLogTime.smartctl.log
	echo "----END----"                                                 >> $HCLogDir/$HCHost.$HCLogTime.smartctl.log
done
echo "########smartctl####END########"                               >> $HCLogDir/$HCHost.$HCLogTime.smartctl.log

echo "########lvmbackup####BEGIN########"                             > $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log
if [ -d /etc/lvm/backup ]
then	
  for i in `ls /etc/lvm/backup`	
  do	
	  echo "value:$i"                                                   >> $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log
	  echo "----BEGIN----"                                              >> $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log
	  cat /etc/lvm/backup/$i                                            >> $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log
	  echo "----END----"                                                >> $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log
  done
fi
echo "########lvmbackup####END########"                               >> $HCLogDir/$HCHost.$HCLogTime.lvmbackup.log

echo "########HBAwwwn####BEGIN########"                               > $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log
if [ -d /sys/class/fc_host ]  
then	
  for i in `ls /sys/class/fc_host`	
  do	
	  echo "value:$i"                                                   >> $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log
	  echo "----BEGIN----"                                              >> $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log
	  cat /sys/class/fc_host/$i/port_name                               >> $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log
	  echo "----END----"                                                >> $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log
  done
fi
echo "########HBAwwwn####END########"                                >> $HCLogDir/$HCHost.$HCLogTime.HBAwwwn.log

echo "########rpm -qi####BEGIN########"                              > $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
for i in `rpm -qa`	
do	
  echo "************"                                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
	echo "value:$i"                                                    >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
	echo "----BEGIN----"                                               >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
	 rpm -qi $i                                                        >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
	echo "----END----"                                                 >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
  echo "************"                                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log
done
echo "########rpm -qi####END########"                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-qi.log

echo "########rpm -V####BEGIN########"                              > $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
for i in `rpm -qa`
do	
  echo "************"                                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
	echo "value:$i"                                                    >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
	echo "----BEGIN----"                                               >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
	 rpm -V $i                                                        >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
	echo "----END----"                                                 >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
  echo "************"                                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log
done
echo "########rpm -qi####END########"                                >> $HCLogDir/$HCHost.$HCLogTime.rpm-V.log


cd $HCWorkDir
tar zcvf $HCHost.$HCLogTime.tar.gz ./$HCHost$HCLogTime

rm -rf ./$HCHost$HCLogTime
echo "Please pick the file $HCHost.$HCLogTime.tar.gz"
