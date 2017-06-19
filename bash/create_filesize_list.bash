bash /home/tae0554/largest/largest.bash /cygdrive/e/sas/rsa_pa /home/tae0554/largest/rsa_pa1.txt
cut -d" " -f2-50 /home/tae0554/largest/rsa_pa1.txt > /home/tae0554/largest/rsa_pa2.txt
find /home/tae0554/largest -name '*.txt' -print0 | xargs -0 sed -i 's/e:\/sas/\/\/ddpsm114/g' 
find /home/tae0554/largest -name '*.txt' -print0 | xargs -0 sed -i 's/\//\\/g'
perl -pi -e 's/^/  /' /home/tae0554/largest/rsa_pa2.txt 
sed 's/ NHODOM01+Use/ /g' < /home/tae0554/largest/rsa_pa2.txt > /home/tae0554/largest/rsa_pa3.txt 
sed 's/Administrators/Admin   /g' < /home/tae0554/largest/rsa_pa3.txt > /home/tae0554/largest/rsa_pa.txt 
rm  /home/tae0554/largest/rsa_pa1.txt;
rm  /home/tae0554/largest/rsa_pa2.txt;
rm  /home/tae0554/largest/rsa_pa2.txt.bak;
cp /home/tae0554/largest/rsa_pa.txt /cygdrive/g/sas/sasuser/tae0554/data/cleanup/rsa_pa.txt;