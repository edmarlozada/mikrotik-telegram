# eTGSend #
# ------------------------------
# Send Telegram Message v6.2
# by: Chloe Renae & Edmar Lozada
# ------------------------------
:local tMsg $1; :local iCtr 3;
:if (([:len $tBot]=0) || ([:len $tGrp]=0) || ([:len $tMsg]=0)) do={
  :log warning "(eTGSend) error: input empty"; :return 0;
};
:if ([/ping 1.1.1.1 count=1]=0) do={ :if ([/ping 8.8.8.8 count=2]=0) do={
  :set iCtr 0; :log warning "(eTGSend) error: no internet [ping=0]";
}};
:if ($iCtr > 0) do={
  :local eTGSendAPI [:parse [/system script get sc-eTGSendAPI source]];
  :set iCtr [$eTGSendAPI tBot=$tBot tGrp=$tGrp $tMsg];
};
:if ($iCtr=0) do={
  :local eTGSave [:parse [/system script get sc-eTGSave source]];
  $eTGSave tBot=$tBot tGrp=$tGrp $tMsg;
};
# ------------------------------

