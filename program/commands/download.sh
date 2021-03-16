#dos2unix command used to ensure correct file systems used as can cause issues on windows machine without this even when WSL used
dos2unix /program/commands/command.sh
bash /program/commands/changex.sh && bash /program/commands/command.sh
bash /program/commands/resetx.sh
