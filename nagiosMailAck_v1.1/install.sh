#local variables
nagPath=/usr/local/bin/nagMailAck
nagScr=nagMailAck.sh
rubyScr=nagMailACK.rb
perlScr=nagiosACK.pl

#making sure dir exists
`mkdir -p $nagPath`

#copying scripts to desired path
`cp ./$rubyScr $nagPath/`
`cp ./$perlScr $nagPath/`
`cp ./$nagScr $nagPath/`
#`chmod 111 $nagPath/$rubyScr`
`chmod 755 $nagPath/$nagScr`

#installing/configuring nagios_mail_ack service
`cp ./nagMailAck /etc/init.d/`
`chmod 755 /etc/init.d/nagMailAck`
`chkconfig --add nagMailAck`
`chkconfig --level 2345 nagMailAck on`
`echo "/etc/init.d/nagMailAck start"`

`chmod 777 /usr/local/nagios/var/rw/nagios.cmd`
