# eTGSave #
# ------------------------------
# Save Telegram Message v6.2
# by: Chloe Renae & Edmar Lozada
# ------------------------------
:local eRand do={:local n [/system resource irq get 0 count];:return ([pick $n ([:len $n]-2) [:len $n]])};
:local iDate do={:local d [/system clock get date];:local cD [:pic $d 4 6];:local cY [:pick $d 7 11];
  :local cM [pick (100+([find "..anebarprayunulugepctovec" [:pick [:pick $d 0 3] 1 3]]/2)) 1 3];:return "$cY$cM$cD"};
:local iTime do={:local t [/system clock get time];:local r "";
  :for i from=0 to=([:len $t]-1) do={:local x [:pick $t $i];:if ($x!=":") do={:set r "$r$x"};};:return $r};

:local tMsg $1;
:if (([:len $tBot]=0) || ([:len $tGrp]=0) || ([:len $tMsg]=0)) do={
  :log warning "(eTGSave) error: input empty"; :return 0;
};
:local tName ("TG_".[$iDate]."_".[$iTime]."_".[$eRand]);
:local tSave (":local tData {\r\n".\
              "  \"tBot\"=\"$tBot\";\r\n".\
              "  \"tGrp\"=\"$tGrp\";\r\n".\
              "  \"tMsg\"=\"$tMsg\" \r\n".\
              "}; :return \$tData\r\n");
/system script add name=$tName source=$tSave owner="telegram savedata" comment="telegram_savedata: $tGrp";
:local n 5;:while (($n>0) and ([/system script find name=$tName]="")) do={:set n ($n-1);:delay 1s};
:if ($n=0) do={
  :log warning "(eTGSave) error: /system-script NOT saved => name:[$tName]";
} else={
  /system scheduler set [find name=eTGHandler] disabled=no;
};
# ------------------------------
