# mikrotik-telegram v6.2
Mikrotik script to send telegram message. Save message if sending failed. Resend saved message on interval.
- send telegram message (eTGSend)
- save message if the send fails (eTGSave)
- remove all saved messages (eTGRemoveAll)
- resend saved message (eTGHandler)

Saved Data Location:
- /system scripts source

Resend Saved:
- interval = 5mins (change accordingly)
- if [empty] saved message, disable handler

Parameters:
- Bot = "xxxxx" ( Bot API Token )
- Grp = "xxxxx" ( Group Chat ID )
- Msg = "xxxxx" ( telegram message )

Sample Send Message:

{
:local TGBot "xxxxx";
:local TGGrp "xxxxx";
:local TGMsg "Test1";
:local eTGSend [:parse [/system script get sc-eTGSend source]];
$eTGSend tBot=$TGBot tGrp=$TGGrp $TGMsg;
}

How to install:
- Open "telegram_msg_send_with_save.rsc".
- Select all then copy.
- Paste to winbox terminal.

Author:
- Chloe Renae & Edmar Lozada

Facebook Contact:
- https://www.facebook.com/chloe.renae.9
