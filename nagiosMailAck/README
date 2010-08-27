Latest Version: NagiosMailACK version 1.1


What It Is?

Using this you can Acknowledge any Host or Service Notification
mailed to your nagios-admin mail-id by just forwarding that same
Notification mail with prefixing a custom string to its generated subject
and sending it to a GMail Id owned by you.

You can use the same GMail ID for any number of Nagios Servers; as 
before installing this service over any machine you'll configure the Ruby 
Script in it as stated below in #{Configuration Required} Section; where
you'll be setting a 'nagID' variable's value, which you can set different
for your different boxes... ad while forwarding the Notification mail,
use the 'nagID' assigned to that server to prefix the custom Subject in
the manner described later as Example in #{Configuration Required} Section.



######################################
Configuration Required
######################################
you need to make some changes to 'nagMailACK.rb' script
open the script in any text-editor
in starting of the script, there are few data-members declared
and assigned values
here
[]set your custom Nagios ID by changing value of variable
nagID = 'myNagiosBox1'

[]set your Credentials for GMail ID used for Nagios as
CONFIG = {
  :host     => 'imap.gmail.com',
  :username => 'urNagiosMailID@gmail.com',
  :password => 'urNagiosPassword',
  :port     => 993,
  :ssl      => true
}

[]by default this service will check for ACK every 15min, to change
search for line 
"sleep(900) #15min [time_in_sec]"
in the "nagMailACK.rb" file and change that 900 with the number of seconds 
interval you want

now whenever you forward a Notification mail to this 
gMail Id you need to prefix the subject with '<NagID> ack '
Example: myNagiosBox1 ack Fwd: ** PROBLEM Host Alert: hostNo_1 is DOWN **

so just click to forward the received Notification Mail and prefix its generated subject line with
[nagiosBoxID]<space>ack<space> 
so that it looks like our example above

[]be sure "nagios.cmd" file, normally located at
'/usr/local/nagios/var/rw/nagios.cmd' has write permission enabled for
this Ruby Script and outgoing port 993 connections are unblocked

######################################
######################################

######################################
Installation
######################################
NOTE: the 'install.sh' script has been written for Linux Boxes
like Fedora/CentOS etc. having "/etc/init.d/" Service Directory
and utility "chkconfig"
In any case having other O.S.; just configure the "nagMailACK.rb"
Ruby Script as per above instructions thats you will need at all.
And as per settings of your O.S. set that Ruby Script to execute
as a system daemon; can even execute as a normal app...

to install after making required configuration, you just need
to run following command in its extracted dir
#sh install.sh

######################################
######################################

######################################
Files Structure and Info
######################################
currently we have 5 files in the Service Package TAR
[] install.sh
-this script is to install all other scripts at required locations
-installing service script for this, at
  /etc/init.d/nagMailAck
-configuring it to auto-start, and starting it

[] nagMailAck
-this is the service script which gets installed at /etc/init.d

[] nagMailACK.rb
-this is the main Ruby Script, accessing GMail a/c, fetching required subject and ack nagios

[] nagMailAck.sh
-this script is used by Service Script to call above Ruby Script as background process

[] README
-you are reading it
######################################
######################################
