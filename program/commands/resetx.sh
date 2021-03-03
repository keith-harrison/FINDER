sed -i -e  "s/$(sed 's:/:\\/:g' /work/SRAFILE.txt)/@SRRNUMBER/g" /program/commands/command.sh
sed -i -e  "s/$(sed 's:/:\\/:g' /work/SPECIES.txt)/@SPECIES/g" /program/commands/command.sh