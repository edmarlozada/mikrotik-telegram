# eTGHandler #
# ------------------------------
# Telegram Handler v6.2
# by: Chloe Renae & Edmar Lozada
# ------------------------------
:if ([/system script find owner="telegram savedata"]!="") do={
  :local gTGList [:toarray ""];
  :foreach nRec in=[/system script find owner="telegram savedata"] do={ :set ($gTGList->[:len $gTGList]) $nRec };
  :local iCtr [:len [$gTGList]]; :if ($iCtr>20) do={ set iCtr 20 };
  :if ([/ping 1.1.1.1 count=1]=0) do={ :if ([/ping 8.8.8.8 count=2]=0) do={
    :set iCtr 0; :log warning "(eTGHandler)) error: no internet [ping=0]";
  }};
  :while ($iCtr>0) do={
    :local nRec ($gTGList->($iCtr-1));
    :local cSName [/system script get $nRec name];
    :local tData [[:parse [/system script get $nRec source]]];
    :local tBot ($tData->"tBot"); local tGrp ($tData->"tGrp"); local tMsg ($tData->"tMsg");
    :local eTGSendAPI [:parse [/system script get sc-eTGSendAPI source]];
    :local iRet [$eTGSendAPI tBot=$tBot tGrp=$tGrp $tMsg];
    :if ($iRet=-9) do={
      /system script remove $nRec;
    } else={
      :log warning "(eTGHandler) telegram sent failed cSName:[$cSName]";
    };
    :set iCtr ($iCtr-1); :delay 2s;
  }
};
:if ([/system script find owner="telegram savedata"]="") do={
  /system scheduler set [find name=eTGHandler] disabled=yes;
};
# ------------------------------
