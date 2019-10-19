#!/usr/bin/ksh
#Author:CES.HC.FTP.1.0.4
#Created Date:2015-07-15
#Main Function:Collect AIX formation.
#Environment:AIX
#Logical:
#Description for variable and function:
#Version:1.0

export LANG=C

if [ $# -lt 3 -o $# -gt 4 ];then
    echo "Usage:$0 <ftpusername> <ftppasswd> <localPath> [ftpserverIP]"
    exit
fi

[ -d "$3" ] || { echo "Invalid localpath"; exit; }

export ftpserverIP="evo.chinaetek.com"
[ -n "$4" ] && { export ftpserverIP=$4; }

if [ $ftpserverIP = "evo.chinaetek.com" ]
then
  ftpPort="12021"
else
  ftpPort="21"
fi


# TEST FTP Server
##############################################################################
ftpserver=`perl -e 'use Net::FTP;
           $FTP_SERVER="";
           @FTP_SERVERS=($ENV{"ftpserverIP"});
           foreach $myftpserver (@FTP_SERVERS) 
           {   $ftp=Net::FTP->new("$myftpserver",Port=>"$ftpPort",Debug=>0,Timeout=>5) or next;
               $ftp->close(); 
               $FTP_SERVER=$myftpserver;
               last;
           }
           print $FTP_SERVER;'` 

if [ "$ftpserver" = "" ];then
    echo "ERROR 11 ! Comunication  failed."
    exit 11
fi

# upload_function
##############################################################################
ftp_function(){
cd $Local_Path
ftp -n -v -i $ftpserver $ftpPort <<eof >$ftp_log
user $ftpuser $ftppassword
bin
prompt
$ftpcmd $Sour_files
bye  
eof

if [ -s $ftp_log ];then 
   TransferNum=`awk '/^226/' $ftp_log`
   if [ "$TransferNum" = "" ];then 
         ftp_again=1
   else
         ftp_again=0
   fi 
fi

if [ $ftp_again -eq 1 ];then
ftp -n -v -i $ftpserver $ftpPort <<eof >$ftp_log
user $ftpuser $ftppassword
bin
prompt
passive on
$ftpcmd $Sour_files
bye  
eof

if [ -s $ftp_log ];then 
    TransferNum=`awk '/^226/'  $ftp_log`
    if [ "$TransferNum" = "" ];then 
         ftp_again=1
    else
         ftp_again=0
    fi
fi
fi

if [ $ftp_again -eq 0 ];then
    echo "====FTPSuccess====FTP_IP:$ftpserver====FTP_CMD:$ftpcmd==== Files:$Local_Path/$Sour_files->$Sour_files"
    
    mkdir -p ./backup/
    mv $Sour_files ./backup/
    
else
    echo "====FTPFailed====FTP_IP:$ftpserver====FTP_CMD:$ftpcmd==== Files:$Local_Path/$Sour_files->$Sour_files"  
fi
}


# ftp user passed
##############################################################################
ftpuser=$1
ftppassword=$2
ftp_log=$3/ftp_result.log

# FTP && MV
##############################################################################
Sour_files="*.tar.gz"
Local_Path=$3
ftpcmd=mput
ftp_function

