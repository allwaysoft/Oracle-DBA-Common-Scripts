#!/usr/bin/ksh
#Author:CES.HC.AIX.2.0.K
#Created Date:2015-07-15
#Main Function:Collect AIX formation.
#Environment:AIX
#Logical:
#Description for variable and function:
#Version:2.0

export LANG=C

if [ -z "$1" ]
then
  echo "The WorkDir not input, now set to /tmp"
  HCWorkDir="/tmp"
elif [ -d "$1" ]
then
  HCWorkDir="$1"
else
  echo "The WorkDir not not incorrect, now set to /tmp"
  HCWorkDir="/tmp"
fi

HCLogTime=`date +%Y%m%d%H%M%S`
#HCLogTime=`date +%Y%m%d`

HCHost=`hostname`
HCLogDir="$HCWorkDir/$HCHost$HCLogTime"
mkdir -p "$HCLogDir"

DTSTR1=`date +"%m%d0000"`
DTSTR2=$(echo `date +"%y"` - 1 | bc)
ERRDTSTR=`echo $DTSTR1$DTSTR2`

cd $HCWorkDir

OSLevelMajor=`uname -v | awk '{print $1}'`
MachineTYPE=`uname -uM | awk -F"IBM," '{print $2}' | awk '{print $1}'`
MachineSN=`uname -uM | awk -F"IBM," '{print $3}' | awk '{print $1}'`
ParName=`lparstat -i | grep "Partition Name"  | awk -F": " '{print $2}'`
ParNum=`lparstat -i | grep "Partition Number"  | awk -F": " '{print $2}'`

HCLogDirFile0="$HCLogDir/hcaix.0.log"
> $HCLogDirFile0
IPHost=`hostname`
IPAddr=`host $IPHost |awk '{print $3}'`
echo "########Basic####BEGIN########"                                >> $HCLogDirFile0 2>&1
echo "OSType:AIX"                                                    >> $HCLogDirFile0 2>&1
echo "OSLevel:"`oslevel`                                             >> $HCLogDirFile0 2>&1
if [ $OSLevelMajor -eq 5 ]
then
echo "OS_UUID: "$MachineTYPE"_"$MachineSN"_"$ParName"_"$ParNum   >> $HCLogDirFile0 2>&1
else
echo "OS_UUID:"`lsattr -El sys0 | grep os_uuid | awk '{print $2}'`"_"$MachineSN"_"$ParNum   >> $HCLogDirFile0 2>&1
fi
echo "OS Time:"`date '+%Y-%m-%d %H:%M:%S'`                           >> $HCLogDirFile0 2>&1
echo "HostName:$IPHost"                                              >> $HCLogDirFile0 2>&1
echo "IP Addr:$IPAddr"                                               >> $HCLogDirFile0 2>&1
echo "OS UTC:"`date |awk '{print $5}'`                               >> $HCLogDirFile0 2>&1
echo "########Basic####END########"                                  >> $HCLogDirFile0 2>&1

HCLogDirFile1="$HCLogDir/hcaix.adddev.log"
> $HCLogDirFile1
echo "########lsdev####BEGIN########"                                >> $HCLogDirFile1 2>&1
lsdev -F 'name:status:class:subclass:location:physloc:description'   >> $HCLogDirFile1 2>&1
echo "partition0:Available:PowerPC:AIX:::Partition"                  >> $HCLogDirFile1 2>&1
bootlist -m normal -o | awk '{print "boot"NR":Available:boot:AIX::"$1":"$2"."$3}'  >> $HCLogDirFile1 2>&1
echo "sysdumpdev0:Available:PowerPC:AIX:::sysdumpdev"                >> $HCLogDirFile1 2>&1
echo "vmo0:Available:PowerPC:AIX:::OS Parameter"                     >> $HCLogDirFile1 2>&1
echo "ulimit0:Available:PowerPC:AIX:::OS Parameter"                  >> $HCLogDirFile1 2>&1
echo "no0:Available:PowerPC:AIX:::OS Parameter"                      >> $HCLogDirFile1 2>&1
echo "OS0:Available:PowerPC:AIX:::OS Parameter"                      >> $HCLogDirFile1 2>&1
echo "########lsdev####END########"                                  >> $HCLogDirFile1 2>&1

HCLogDirFile2="$HCLogDir/hcaix.lsattr-lscfg.log"
> $HCLogDirFile2
for i in `lsdev | awk '{print $1}'`
do
echo "########lsattr&&lscfg####BEGIN########"                       >> $HCLogDirFile2 2>&1
echo "value:$i"                                                     >> $HCLogDirFile2 2>&1
echo "********lsattr****BEGIN********"                              >> $HCLogDirFile2 2>&1
lsattr -El $i                                                       >> $HCLogDirFile2 2>&1
echo "********lsattr****END********"                                >> $HCLogDirFile2 2>&1
echo "\n"                                                           >> $HCLogDirFile2 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile2 2>&1
lscfg -vpl $i                                                       >> $HCLogDirFile2 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile2 2>&1
echo "########lsattr&&lscfg####END########"                         >> $HCLogDirFile2 2>&1
echo "\n"                                                           >> $HCLogDirFile2 2>&1
echo "\n"                                                           >> $HCLogDirFile2 2>&1
done

HCLogDirFile3="$HCLogDir/hcaix.sysdumpdev.log"
> $HCLogDirFile3
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile3 2>&1
echo "value:sysdumpdev0"                                            >> $HCLogDirFile3 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile3 2>&1
sysdumpdev -l                                                       >> $HCLogDirFile3 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile3 2>&1
echo "\n"                                                           >> $HCLogDirFile3 2>&1
echo "********lscfg1****BEGIN********"                              >> $HCLogDirFile3 2>&1
DUMPDEVSIZE=`sysdumpdev -e | awk '{print $7/1024/1024}'`
echo "Estimated dump size(MB): $DUMPDEVSIZE"                        >> $HCLogDirFile3 2>&1
echo "********lscfg1****END********"                                >> $HCLogDirFile3 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile3 2>&1

HCLogDirFile4="$HCLogDir/hcaix.vmo.log"
> $HCLogDirFile4
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile4 2>&1
echo "value:vmo0"                                                   >> $HCLogDirFile4 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile4 2>&1
vmo -a                                                              >> $HCLogDirFile4 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile4 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile4 2>&1

HCLogDirFile5="$HCLogDir/hcaix.no.log"
> $HCLogDirFile5
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile5 2>&1
echo "value:no0"                                                    >> $HCLogDirFile5 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile5 2>&1
no -a                                                               >> $HCLogDirFile5 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile5 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile5 2>&1


HCLogDirFile6="$HCLogDir/hcaix.ulimit.log"
> $HCLogDirFile6
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile6 2>&1
echo "value:ulimit0"                                                >> $HCLogDirFile6 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile6 2>&1
ulimit -a                                                           >> $HCLogDirFile6 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile6 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile6 2>&1

HCLogDirFile7="$HCLogDir/hcaix.os.log"
> $HCLogDirFile7
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile7 2>&1
echo "value:os0"                                                    >> $HCLogDirFile7 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile7 2>&1
echo "hostName:`hostname"                                           >> $HCLogDirFile7 2>&1
echo "osLevel:`oslevel -s"                                          >> $HCLogDirFile7 2>&1
OSLCPU=`vmstat | grep System | awk '{print $3}' | awk -F= '{print$2}'`
OSMEM=`vmstat | grep System | awk '{print $4}' | awk -F= '{print$2}'`
echo "Logic CPU:$OSLCPU"                                            >> $HCLogDirFile7 2>&1
echo "Memory:$OSMEM"                                                >> $HCLogDirFile7 2>&1
OSSMT=`smtctl | grep ^proc0 | awk '{print $3}'`
echo "SMT:$OSSMT"                                                   >> $HCLogDirFile7 2>&1
if [ -f /var/adm/ras/vgbackuplog ]
then
  LastBackupTime=`alog -o -f /var/adm/ras/vgbackuplog | grep mksysb | head -n 1 | awk -F";" '{print $3}'`
  if [ -z $LastBackupTime ]
  then
    OSBACK="NO"
  else
    OSBACK=`echo "OK,"$LastBackupTime`
  fi
else
  OSBACK="NO"
fi
echo "SYS Backup:$OSBACK"                                           >> $HCLogDirFile7 2>&1
echo "Uptime:`uptime | awk '{print $3}' | awk -F, '{print $1}'`"    >> $HCLogDirFile7 2>&1
echo "Page Space:`lsps -s | grep MB | awk '{print $1}'`"            >> $HCLogDirFile7 2>&1
echo "IP Addr:$IPAddr"                                               >> $HCLogDirFile7 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile7 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile7 7>&1

HCLogDirFile8="$HCLogDir/hcaix.vmstat.log"
> $HCLogDirFile8
echo "########vmstat####BEGIN########"                              >> $HCLogDirFile8 2>&1
vmstat 5 12                                                        >> $HCLogDirFile8 2>&1
#vmstat 1 12                                                         >> $HCLogDirFile8 2>&1
echo "########vmstat####END########"                                >> $HCLogDirFile8 2>&1

HCLogDirFile9="$HCLogDir/hcaix.iostat.log"
> $HCLogDirFile9
echo "########iostat####BEGIN########"                              >> $HCLogDirFile9 2>&1
iostat -a 5 12                                                     >> $HCLogDirFile9 2>&1
#iostat -a 1 12                                                      >> $HCLogDirFile9 2>&1
echo "########iostat####END########"                                >> $HCLogDirFile9 2>&1

HCLogDirFile10="$HCLogDir/hcaix.vgpvlv.log"
> $HCLogDirFile10
echo "########lvpv####BEGIN########"                                >> $HCLogDirFile10 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile10 2>&1
for i in `lsvg -o`
do
echo "$i:VG:OS"                                                     >> $HCLogDirFile10 2>&1
for j in `lsvg -p $i | grep -v : | grep -v PV_NAME | awk '{print $1}'`
do
echo "$j:PV:$i"                                                     >> $HCLogDirFile10 2>&1
done
for k in `lsvg -l $i | grep -v : | grep -vE "^LV NAME" | awk '{print $1}'`
do
echo "$k:LV:$i"                                                     >> $HCLogDirFile10 2>&1
done
done
echo "********lscfg****END********"                                 >> $HCLogDirFile10 2>&1
echo "########lvpv####END########"                                  >> $HCLogDirFile10 2>&1

HCLogDirFile11="$HCLogDir/hcaix.vgpvlvattr.log"
> $HCLogDirFile11
for i in `lsvg -o`
do
echo "########lsvg####BEGIN########"                                >> $HCLogDirFile11 2>&1
echo "value:$i"                                                     >> $HCLogDirFile11 2>&1
echo "----lscfg----BEGIN----"                                       >> $HCLogDirFile11 2>&1
echo "CES_AIXLVM_TYPE:    VG"                                       >> $HCLogDirFile11 2>&1
lsvg $i                                                             >> $HCLogDirFile11 2>&1
echo "----lscfg----END----"                                         >> $HCLogDirFile11 2>&1
echo "########lsvg####END########"                                  >> $HCLogDirFile11 2>&1
echo "\n"                                                           >> $HCLogDirFile11 2>&1
for j in `lsvg -o | lsvg -ip | grep -v : | grep -v PV_NAME | awk '{print $1}'`
do
echo "########lsvg####BEGIN########"                                >> $HCLogDirFile11 2>&1
echo "value:$j"                                                     >> $HCLogDirFile11 2>&1
echo "----lscfg----BEGIN----"                                       >> $HCLogDirFile11 2>&1
echo "CES_AIXLVM_TYPE:    PV"                                       >> $HCLogDirFile11 2>&1
lspv $j                                                             >> $HCLogDirFile11 2>&1
echo "----lscfg----END----"                                         >> $HCLogDirFile11 2>&1
echo "########lsvg####END########"                                  >> $HCLogDirFile11 2>&1
echo "\n"                                                           >> $HCLogDirFile11 2>&1
done
for k in `lsvg -o | lsvg -il | grep -v : | grep -vE "^LV NAME" | awk '{print $1}'`
do
echo "########lsvg####BEGIN########"                                >> $HCLogDirFile11 2>&1
echo "value:$k"                                                     >> $HCLogDirFile11 2>&1
echo "----lscfg----BEGIN----"                                       >> $HCLogDirFile11 2>&1
echo "CES_AIXLVM_TYPE:    LV"                                       >> $HCLogDirFile11 2>&1
lslv $k                                                             >> $HCLogDirFile11 2>&1
echo "----lscfg----END----"                                         >> $HCLogDirFile11 2>&1
echo "########lsvg####END########"                                  >> $HCLogDirFile11 2>&1
echo "\n"                                                           >> $HCLogDirFile11 2>&1
done
done

HCLogDirFile12="$HCLogDir/hcaix.pvlvmap.log"
> $HCLogDirFile12
echo "########lslv####BEGIN########"                               >> $HCLogDirFile12 2>&1
lsvg -o | lsvg -ip | grep hdisk | awk '{print $1}'|xargs -i lspv -M {}  >> $HCLogDirFile12 2>&1
echo "########lslv####END########"                                 >> $HCLogDirFile12 2>&1

HCLogDirFile13="$HCLogDir/hcaix.lsfs.log"
> $HCLogDirFile13
echo "########lspv####BEGIN########"                               >> $HCLogDirFile13 2>&1
lsfs                                                               >> $HCLogDirFile13 2>&1
echo "########lspv####END########"                                 >> $HCLogDirFile13 2>&1

HCLogDirFile14="$HCLogDir/hcaix.df-m.log"
> $HCLogDirFile14
echo "########df####BEGIN########"                                 >> $HCLogDirFile14 2>&1
df -m                                                              >> $HCLogDirFile14 2>&1
lsps -a | grep yes | awk '{print $1"  "$4"    NA    "$5"    NA    NA    "$2}'  >> $HCLogDirFile14 2>&1
echo "########df####END########"                                   >> $HCLogDirFile14 2>&1

HCLogDirFile15="$HCLogDir/hcaix.errpt-a.log"
> $HCLogDirFile15
echo "########errpt####BEGIN########"                              >> $HCLogDirFile15 2>&1
errpt -a -s $ERRDTSTR                                              >> $HCLogDirFile15 2>&1
echo "########errpt####END########"                                >> $HCLogDirFile15 2>&1

HCLogDirFile16="$HCLogDir/hcaix.netstat-rn.log"
> $HCLogDirFile16
echo "########netstat####BEGIN########"                            >> $HCLogDirFile16 2>&1
netstat -rn | grep -vE "^Routing|^Destination|^Route|::"           >> $HCLogDirFile16 2>&1
echo "########netstat####END########"                              >> $HCLogDirFile16 2>&1

HCLogDirFile17="$HCLogDir/hcaix.netstat-in.log"
> $HCLogDirFile17
echo "########netstat####BEGIN########"                            >> $HCLogDirFile17 2>&1
netstat -in | grep -vE "^Name|::" | grep -v link | awk '{print "IP:"$1":"$2":"$3":"$4}'        >> $HCLogDirFile17 2>&1
netstat -in | grep -vE "^Name|::" | grep link | awk '{print "MAC:"$1":"$2":"$3":"$4}'          >> $HCLogDirFile17 2>&1
echo "########netstat####END########"                              >> $HCLogDirFile17 2>&1

HCLogDirFile19="$HCLogDir/hcaix.netstat-an-tcp.log"
> $HCLogDirFile19
echo "########netstat####BEGIN########"                            >> $HCLogDirFile19 2>&1
netstat -an | grep -E "tcp|udp"                                    >> $HCLogDirFile19 2>&1
echo "########netstat####END########"                              >> $HCLogDirFile19 2>&1

HCLogDirFile20="$HCLogDir/hcaix.netstat-an-socket.log"
> $HCLogDirFile20
echo "########netstat####BEGIN########"                            >> $HCLogDirFile20 2>&1
netstat -an | grep "^f"                                            >> $HCLogDirFile20 2>&1
echo "########netstat####END########"                              >> $HCLogDirFile20 2>&1

HCLogDirFile21="$HCLogDir/hcaix.netstat-v.log"
> $HCLogDirFile21
for k in 0 1 2 3 4 5 6 7 8 9 10 11 12
do
echo "########netstat####BEGIN####$k####"                          >> $HCLogDirFile21 2>&1 
for i in `lsdev -Ccadapter| grep ent | awk '{print $1}'`
do
echo "********$i****BEGIN********"                                 >> $HCLogDirFile21 2>&1
echo "value:$i"                                                    >> $HCLogDirFile21 2>&1
echo "--------attr----BEGIN--------"                               >> $HCLogDirFile21 2>&1
netstat -v $i                                                      >> $HCLogDirFile21 2>&1
echo "--------attr----END--------"                                 >> $HCLogDirFile21 2>&1
echo "********$i****END********"                                   >> $HCLogDirFile21 2>&1
done
echo "########netstat####END####$k####"                            >> $HCLogDirFile21 2>&1
#sleep 1
sleep 5
done

HCLogDirFile22="$HCLogDir/hcaix.lparstat-i.log"
> $HCLogDirFile22
echo "########lscfg####BEGIN########"                               >> $HCLogDirFile22 2>&1
echo "value:partition0"                                             >> $HCLogDirFile22 2>&1
echo "********lscfg****BEGIN********"                               >> $HCLogDirFile22 2>&1
lparstat -i                                                         >> $HCLogDirFile22 2>&1
echo "********lscfg****END********"                                 >> $HCLogDirFile22 2>&1
echo "########lscfg####END########"                                 >> $HCLogDirFile22 2>&1

HCLogDirFile23="$HCLogDir/hcaix.lssrc-a.log"
> $HCLogDirFile23
echo "########lssrc####BEGIN########"                               >> $HCLogDirFile23 2>&1
lssrc -a                                                            >> $HCLogDirFile23 2>&1
echo "########lssrc####END########"                                 >> $HCLogDirFile23 2>&1

HCLogDirFile24="$HCLogDir/hcaix.boot.log"
> $HCLogDirFile24
echo "########boot####BEGIN########"                                >> $HCLogDirFile24 2>&1
bosdebug                                                            >> $HCLogDirFile24 2>&1
osBootInfo=`bootinfo -K`
echo "bootinfo -K               $osBootInfo"                        >> $HCLogDirFile24 2>&1
osLsUnix=`ls -l /unix | awk -F"->" '{print $2}'`
echo "/unix                    $osLsUnix"                          >> $HCLogDirFile24 2>&1
osLsBoot=`ls -l /usr/lib/boot/unix | awk -F"->" '{print $2}'`
echo "/usr/lib/boot/unix       $osLsBoot"                          >> $HCLogDirFile24 2>&1
sumUnix=`sum /unix`
bootSum=`cat /etc/bosboot.sum`
if [ "$sumUnix" = "$sumUnix" ]
then
echo "bosboot.sum VS sum /unix  OK"                                 >> $HCLogDirFile24 2>&1
else
echo "bosboot.sum VS sum /unix  NO"                                 >> $HCLogDirFile24 2>&1
fi
echo "########boot####END########"                                  >> $HCLogDirFile24 2>&1

HCLogDirFile0="$HCLogDir/hcaix.lssrc-ls-clstrmgrES.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
lssrc -ls clstrmgrES                                                 >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.clRGinfo.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/clRGinfo                              >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.clshowsrv-v.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/clshowsrv -v                          >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.cltopinfo-m.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/cltopinfo -m                          >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.cldisp.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/cldisp                                >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.cltopinfo.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/cltopinfo                             >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.cltopinfo.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
/usr/es/sbin/cluster/utilities/cltopinfo                             >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.ps-a.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
ps -A -m -o comm,stat,ppid,pid,tid,pcpu,nice,pmem,vsz,rssize,user,time  >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1

HCLogDirFile0="$HCLogDir/hcaix.cluster.log"
> $HCLogDirFile0
IPHost=`hostname`
echo "############BEGIN########"                                     >> $HCLogDirFile0 2>&1
tail -n 2000 /var/hacmp/adm/cluster.log                              >> $HCLogDirFile0 2>&1
echo "############END########"                                       >> $HCLogDirFile0 2>&1


#some information backup
prtconf                                                             > $HCLogDir/$HCHost.$HCLogTime.prtconf.log
lsmcode -Ar                                                         > $HCLogDir/$HCHost.$HCLogTime.lsmcode.log
cat /etc/filesystems                                                > $HCLogDir/$HCHost.$HCLogTime.filesystems.txt
cat /etc/hosts                                                      > $HCLogDir/$HCHost.$HCLogTime.hosts.txt
cat /etc/security/limits                                            > $HCLogDir/$HCHost.$HCLogTime.limits.txt
cat /etc/security/user                                              > $HCLogDir/$HCHost.$HCLogTime.usr.txt
cat /etc/passwd                                                     > $HCLogDir/$HCHost.$HCLogTime.passwd.txt
cat /etc/ntp.conf                                                   > $HCLogDir/$HCHost.$HCLogTime.ntp.txt
cat /etc/services                                                   > $HCLogDir/$HCHost.$HCLogTime.services.txt
crontab -l                                                          > $HCLogDir/$HCHost.$HCLogTime.crontab.log
#cat /var/hacmp/adm/cluster.log                                      > $HCLogDir/$HCHost.$HCLogTime.cluster.txt


cd $HCWorkDir
tar cvf $HCHost.$HCLogTime.tar ./$HCHost$HCLogTime
gzip $HCHost.$HCLogTime.tar

rm -rf ./$HCHost$HCLogTime
echo "Please pick the file $HCHost.$HCLogTime.tar.gz"

