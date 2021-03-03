sed -i -e  "s/@SRRNUMBER/$(sed 's:/:\\/:g' /work/SRAFILE.txt)/g" /program/commands/command.sh
sed -i -e  "s/@SPECIES/$(sed 's:/:\\/:g' /work/SPECIES.txt)/g" /program/commands/command.sh