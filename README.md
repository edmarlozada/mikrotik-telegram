# mikrotik-telegram
Mikrotik script to send telegram message. Save message if sending failed. Resend saved message on interval.
- send telegram message (eTGSend)
- save message if the send fails (eTGSave)
- resend saved message (eTGHandler)

Saved Data Location:
- /system scripts source

Resend Saved:
- interval = 5mins
- if [empty] saved message, disable handler

Parameters:
- tBot="xxxxx" ( Bot API Token )
- tGrp="xxxxx" ( Group Chat ID )
- tMsg "xxxxx" ( telegram message )

Sample Send Message:

	{
	:local eTGSend [:parse [/system script get sc-eTGSend source]]
	$eTGSend tBot=$tBot tGrp=$tGrp $tMsg
	}

Howto Install:
- open as txt file
- select all & copy
- paste to winbox terminal

Author:
- Chloe Renae & Edmar Lozada
- Gcash (0909-3887889)

Facebook Contact:
- https://www.facebook.com/chloe.renae.9

Facebook JuanFi Group:
- https://www.facebook.com/groups/1172413279934139

