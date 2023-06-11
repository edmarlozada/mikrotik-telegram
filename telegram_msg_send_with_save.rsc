# ==============================
# mikrotik-telegram v6.2
# Mikrotik script to send telegram message.
# Save message if the send fails.
# Resend saved message on interval.
#  - send telegram message (eTGSend)
#  - save message if the send fails (eTGSave)
#  - resend saved message (eTGHandler)
# Author:
# - Chloe Renae & Edmar Lozada
# - Gcash (0909-3887889)
# Facebook Contact:
# - https://www.facebook.com/chloe.renae.9
# Saved Data Location:
#  - /system script source
# Sending Saved:
#  - interval = 5mins
#  - if [empty] saved message, disable handler
# Parameters:
#  - tBot="xxxxx" ( Bot API Token )
#  - tGrp="xxxxx" ( Group Chat ID )
#  - tMsg "xxxxx" ( telegram message )
# Sample Send Message:
#    :local eTGSend [:parse [/system script get sc-eTGSend source]]
#    $eTGSend tBot=$tBot tGrp=$tGrp $tMsg
# Howto Install:
#  - open as txt file
#  - select all, copy
#  - paste to winbox terminal
# ------------------------------
# send telegram message example:
# {
#  :local tBot "xxxxx" ( Bot API Token );
#  :local tGrp "xxxxx" ( Group Chat ID );
#  :local eTGSend [:parse [/system script get sc-eTGSend source]];
#  $eTGSend tBot=$tBot tGrp=$tGrp "R : v12345 (123456) 999.00";
# }
# ------------------------------
/{:local iVer v6.2;
:put "(telegram $iVer) Installing...";

# === sc-eTGSendAPI === #
{ :local eName "eTGSendAPI"
  :local eSource "# $eName #\r
# ------------------------------\r
# Send Telegram Message API $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
:local tMsg \$1; :local gTGResult;
:local iURL (\"https://api.telegram.org\".\"/bot\$tBot/sendmessage\\?chat_id=\$tGrp&text=\$tMsg\");
:local iCtr 3; :while (\$iCtr > 0) do={
  :do {
    :set gTGResult ([/tool fetch url=\$iURL as-value output=user]);
  } on-error={
    set iCtr 0;
  };
  :local iStatus (\$gTGResult->\"status\");
  :if (\$iStatus=\"finished\") do={
    :set iCtr -9; };
  :if ((\$iCtr > 0) and (\$iStatus!=\"finished\")) do={
    :set iCtr (\$iCtr-1) };
  :if ((\$iCtr = 0) and (\$iStatus!=\"finished\")) do={
    :log warning \"($eName) error: sending failed => [\$iCtr] [\$iStatus]\" };
};
:return \$iCtr;\r
# ------------------------------\r\n"
:if ([/system script find name="sc-$eName"]="") do={ /system script add name="sc-$eName" }
/system script set [find name="sc-$eName"] source=$eSource owner="telegram function" comment="telegram_function-01: $eName"
}


# === sc-eTGSave === #
{ :local eName "eTGSave"
  :local eSource "# $eName #\r
# ------------------------------\r
# Save Telegram Message $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
:local eRand do={:local n [/system resource irq get 0 count];:return ([pick \$n ([:len \$n]-2) [:len \$n]])};
:local iDate do={:local d [/system clock get date];:local cD [:pic \$d 4 6];:local cY [:pick \$d 7 11];
  :local cM [pick (100+([find \"..anebarprayunulugepctovec\" [:pick [:pick \$d 0 3] 1 3]]/2)) 1 3];:return \"\$cY\$cM\$cD\"};
:local iTime do={:local t [/system clock get time];:local r \"\";
  :for i from=0 to=([:len \$t]-1) do={:local x [:pick \$t \$i];:if (\$x!=\":\") do={:set r \"\$r\$x\"};};:return \$r};

:local tMsg \$1;
:if (([:len \$tBot]=0) || ([:len \$tGrp]=0) || ([:len \$tMsg]=0)) do={
  :log warning \"($eName) error: input empty\"; :return 0;
};
:local tName (\"TG_\".[\$iDate].\"_\".[\$iTime].\"_\".[\$eRand]);
:local tSave (\":local tData {\\r\\n\".\\
              \"  \\\"tBot\\\"=\\\"\$tBot\\\";\\r\\n\".\\
              \"  \\\"tGrp\\\"=\\\"\$tGrp\\\";\\r\\n\".\\
              \"  \\\"tMsg\\\"=\\\"\$tMsg\\\" \\r\\n\".\\
              \"}; :return \\\$tData\\r\\n\");
/system script add name=\$tName source=\$tSave owner=\"telegram savedata\" comment=\"telegram_savedata: \$tGrp\";
:local n 5;:while ((\$n>0) and ([/system script find name=\$tName]=\"\")) do={:set n (\$n-1);:delay 1s};
:if (\$n=0) do={
  :log warning \"($eName) error: /system-script NOT saved => name:[\$tName]\";
} else={
  /system scheduler set [find name=eTGHandler] disabled=no;
};\r
# ------------------------------\r\n"
:if ([/system script find name="sc-$eName"]="") do={ /system script add name="sc-$eName" }
/system script set [find name="sc-$eName"] source=$eSource owner="telegram function" comment="telegram_function-02: $eName"
}


# === sc-eTGRemoveAll === #
{ :local eName "eTGRemoveAll"
  :local eSource "# $eName #\r
# ------------------------------\r
# Remove all Telegram Messages $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
:foreach nRec in=[/system script find owner=\"telegram savedata\"] do={ /system script remove \$nRec };
# ------------------------------\r\n"
:if ([/system script find name="sc-$eName"]="") do={ /system script add name="sc-$eName" }
/system script set [find name="sc-$eName"] source=$eSource owner="telegram function" comment="telegram_function-03: $eName"
}


# === sc-eTGSend === #
{ :local eName "eTGSend"
  :local eSource "# $eName #\r
# ------------------------------\r
# Send Telegram Message $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
:local tMsg \$1; :local iCtr 3;
:if (([:len \$tBot]=0) || ([:len \$tGrp]=0) || ([:len \$tMsg]=0)) do={
  :log warning \"($eName) error: input empty\"; :return 0;
};
:if ([/ping 1.1.1.1 count=1]=0) do={ :if ([/ping 8.8.8.8 count=2]=0) do={
  :set iCtr 0; :log warning \"($eName) error: no internet [ping=0]\";
}};
:if (\$iCtr > 0) do={
  :local eTGSendAPI [:parse [/system script get sc-eTGSendAPI source]];
  :set iCtr [\$eTGSendAPI tBot=\$tBot tGrp=\$tGrp \$tMsg];
};
:if (\$iCtr=0) do={
  :local eTGSave [:parse [/system script get sc-eTGSave source]];
  \$eTGSave tBot=\$tBot tGrp=\$tGrp \$tMsg;
};\r
# ------------------------------\r\n"
:if ([/system script find name="sc-$eName"]="") do={ /system script add name="sc-$eName" }
/system script set [find name="sc-$eName"] source=$eSource owner="telegram function" comment="telegram_function-04: $eName"
}


# === eTGHandler === #
{ :local eName "eTGHandler"
  :local sEvent "# $eName #\r
# ------------------------------\r
# Telegram Handler $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
:if ([/system script find owner=\"telegram savedata\"]!=\"\") do={
  :local gTGList [:toarray \"\"];
  :foreach nRec in=[/system script find owner=\"telegram savedata\"] do={ :set (\$gTGList->[:len \$gTGList]) \$nRec };
  :local iCtr [:len [\$gTGList]]; :if (\$iCtr>20) do={ set iCtr 20 };
  :if ([/ping 1.1.1.1 count=1]=0) do={ :if ([/ping 8.8.8.8 count=2]=0) do={
    :set iCtr 0; :log warning \"($eName)) error: no internet [ping=0]\";
  }};
  :while (\$iCtr>0) do={
    :local nRec (\$gTGList->(\$iCtr-1));
    :local cSName [/system script get \$nRec name];
    :local tData [[:parse [/system script get \$nRec source]]];
    :local tBot (\$tData->\"tBot\"); local tGrp (\$tData->\"tGrp\"); local tMsg (\$tData->\"tMsg\");
    :local eTGSendAPI [:parse [/system script get sc-eTGSendAPI source]];
    :local iRet [\$eTGSendAPI tBot=\$tBot tGrp=\$tGrp \$tMsg];
    :if (\$iRet=-9) do={
      /system script remove \$nRec;
    } else={
      :log warning \"($eName) telegram sent failed cSName:[\$cSName]\";
    };
    :set iCtr (\$iCtr-1); :delay 2s;
  }
};
:if ([/system script find owner=\"telegram savedata\"]=\"\") do={
  /system scheduler set [find name=eTGHandler] disabled=yes;
};\r
# ------------------------------\r\n"
:if ([/system scheduler find name=$eName]="") do={ /system scheduler add name=$eName }
/system scheduler  set [find name=$eName] on-event=$sEvent \
 disabled=yes interval=5m comment="system_scheduler: Telegram Handler"
}

# ------------------------------
}
