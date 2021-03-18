#Allows variables to be entered by just changing all occurences below in the shell file to be the inputs.
sed -i -e  "s/@TITLE/$(sed 's:/:\\/:g' /work/title.txt)/g" /program/commands/command.sh
sed -i -e  "s/@SRRNUMBER/$(sed 's:/:\\/:g' /work/SRAFILE.txt)/g" /program/commands/command.sh
if test -f "/work/SPECIES.txt"; then
sed -i -e  "s/@SPECIES/$(sed 's:/:\\/:g' /work/SPECIES.txt)/g" /program/commands/command.sh
fi