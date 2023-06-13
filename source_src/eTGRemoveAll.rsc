# eTGRemoveAll #
# ------------------------------
# Remove all Telegram Messages v6.2
# by: Chloe Renae & Edmar Lozada
# ------------------------------
:foreach nRec in=[/system script find owner="telegram savedata"] do={ /system script remove $nRec };
# ------------------------------
