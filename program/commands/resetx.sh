sed -i -e  "s/$(sed 's:/:\\/:g' /work/title.txt)/@TITLE/g" /program/commands/command.sh
sed -i -e  "s/$(sed 's:/:\\/:g' /work/SRAFILE.txt)/@SRRNUMBER/g" /program/commands/command.sh
if test -f "/work/SPECIES.txt"; then
sed -i -e  "s/$(sed 's:/:\\/:g' /work/SPECIES.txt)/@SPECIES/g" /program/commands/command.sh
fi
rm /work/SPECIES.txt
rm /work/title.txt