#!/usr/bin/env ruby
#####################################################################
#AiM: ACK Nagios Notification by Forwarding Notification Mail to
#	Nagios' PrivateGMail A/C with Custom Tweaked Subject
#
#this script access GMail over IMAP and fetches InBox Mails
#then it checks for Sender of Mail
#if Sender=NagiosContact then send Mail Subject to Perl script to ACK
#moves fetched Mail to Archive with a Label, deletes from InBox
#####################################################################
##############################START-SCRIPT##############################
require 'net/imap'

nagID = 'myNagiosBox1'

CONFIG = {
  :host     => 'imap.gmail.com',
  :username => 'urNagiosMailID@gmail.com', #its fake, change it
  :password => 'urNagiosPassword', #its fake, change it
  :port     => 993,
  :ssl      => true
}

#####################################################################
################################MAIN-PART##############################

#puts "Prefix all acknowledgement mails with '" + nagID + " ack ' with both spaces"
#puts "Eg: '"+nagID+" ack Fwd: ** PROBLEM Host Alert testBox is DOWN **'"

## starting infinite loop
loop do

$imap = Net::IMAP.new( CONFIG[:host], CONFIG[:port], CONFIG[:ssl] )
$imap.login( CONFIG[:username], CONFIG[:password] )
printMsg = 'echo "***************logged in " + CONFIG[:username] + "******************" >> /var/log/nagAck.log'
system(printMsg)

# select the INBOX as the mailbox to work on
$imap.select('INBOX')

messages_to_archive = []
@mailbox = "-1"

# retrieve all messages in the INBOX that
# are not marked as DELETED (archived in Gmail-speak)
$imap.search(["NOT", "DELETED"]).each do |message_id|
  # the mailbox the message was sent to
  # addresses take the form of {mailbox}@{host}
  @mailbox = $imap.fetch(message_id, 'ENVELOPE')[0].attr['ENVELOPE'].to[0].mailbox

  # give us a prettier mailbox name -
  # this is the label we'll apply to the message
  @mailbox = @mailbox.gsub(/([_\-\.])+/, ' ').downcase
  @mailbox.gsub!(/\b([a-z])/) { $1.capitalize }  
  
  envelope = $imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
  #if envelope.from[0].mailbox==="abhishek" 
    system("echo 'ackFrom: #{envelope.from[0].mailbox}' >> /var/log/nagAck.log")
    system("echo 'Subject: #{envelope.subject}' >> /var/log/nagAck.log")
    if nagiosACK(envelope.subject,nagID)
      messages_to_archive << message_id
      begin
         #create the mailbox, unless it already exists
         $imap.create(@mailbox) unless $imap.list('', @mailbox)
         rescue Net::IMAP::NoResponseError => error
      end
      #copy the message to the proper mailbox/label
      $imap.copy(message_id, @mailbox)
    end
    system('echo "nagiosACK executed\n=----------=\n" >> /var/log/nagAck.log')
  #end
  #messages_to_archive << message_id
end

# archive the original messages
$imap.store(messages_to_archive, "+FLAGS", [:Deleted]) unless messages_to_archive.empty?

$imap.logout
system('echo "**************************logged out*****************************" >> /var/log/nagAck.log')
#exit(0)
sleep(900) #15min [time_in_sec]
##ending external loop
end
#######################################################################
##############################END-SCRIPT###############################
