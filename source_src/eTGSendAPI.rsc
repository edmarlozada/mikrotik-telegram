# eTGSendAPI #
# ------------------------------
# Send Telegram Message API v6.2
# by: Chloe Renae & Edmar Lozada
# ------------------------------
:local tMsg $1; :local gTGResult;
:local iURL ("https://api.telegram.org"."/bot$tBot/sendmessage\?chat_id=$tGrp&text=$tMsg");
:local iCtr 3; :while ($iCtr > 0) do={
  :do {
    :set gTGResult ([/tool fetch url=$iURL as-value output=user]);
  } on-error={
    set iCtr 0;
  };
  :local iStatus ($gTGResult->"status");
  :if ($iStatus="finished") do={
    :set iCtr -9; };
  :if (($iCtr > 0) and ($iStatus!="finished")) do={
    :set iCtr ($iCtr-1) };
  :if (($iCtr = 0) and ($iStatus!="finished")) do={
    :log warning "(eTGSendAPI) error: sending failed => [$iCtr] [$iStatus]" };
};
:return $iCtr;
# ------------------------------
