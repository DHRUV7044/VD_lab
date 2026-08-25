sip -V -cgnd 1 -s -o -sub 2 -mlc poly,mt1 -n 6 -i 0,6.001 -b 	mt1,poly,diff,sub -t mt3,mt4,mt5,mt6 -j 0.3 -Maxw 4.5 -p mt2,key 0,6 	- mt2.sip
sip -V -cgnd 1 -s -o -sub 2 -mlc mt1,mt2 -n 6 -i 0,6.001 -b 	mt2,mt1,poly,diff,sub -t mt4,mt5,mt6 -j 0.3 -Maxw 4.5 -p mt3,key 0,6 	- mt3.sip
sip -V -cgnd 1 -s -o -sub 2 -mlc mt2,mt3 -n 6 -i 0,6.001 -b 	mt3,mt2,mt1,poly,diff,sub -t mt5,mt6 -j 0.3 -Maxw 4.5 -p mt4,key 0,6 	- mt4.sip
sip -V -cgnd 1 -s -o -sub 2 -mlc mt3,mt4 -n 7.5 -i 0,7.501 -b 	mt4,mt3,mt2,mt1,poly,diff,sub -t mt6 -j 0.3 -Maxw 4.5 -p mt5,key 	0,7.5 - mt5.sip
sip -V -cgnd 1 -s -o -sub 2 -mlc mt4,mt5 -n 15 -i 0,15.001 -b 	mt5,mt4,mt3,mt2,mt1,poly,diff,sub -j 0.44 -Maxw 5.28 -p mt6,key 0,15 	- mt6.sip
sip -V -cgnd 1 -s -o -sub 2 -cp poly,allGate,diff -n 3 -i 0,3.001 	-b diff,sub -t mt1,mt2,mt3,mt4,mt5,mt6 -j 0.18 -Maxw 2.7 -p poly,key 	0,3 - poly.sip
sip -V -cgnd 1 -s -o -sub 2 -mlc poly -n 6 -i 0,6.001 -b 	poly,diff,sub -t mt2,mt3,mt4,mt5,mt6 -j 0.3 -Maxw 4.5 -p mt1,key 0,6 	- mt1.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -b mt4,mt3,mt2,mt1,poly,diff,sub 	-Maxw 5.28 -p mt5,key,mt6,key 0,15,0 - mt5_mt6.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -R mt6 -b 	mt3,mt2,mt1,poly,diff,sub -Maxw 5.28 -p mt4,key,mt6,key 0,15,0 - 	mt4_mt6.sip
sip -V -s -cgnd 1 -sub 2 -h -b mt3,mt2,mt1,poly,diff,sub -t mt6 	-Maxw 4.5 -p mt4,key,mt5,key 0,7.5,0 - mt4_mt5.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -R mt5 -b mt2,mt1,poly,diff,sub 	-t mt6 -Maxw 4.5 -p mt3,key,mt5,key 0,7.5,0 - mt3_mt5.sip
sip -V -s -cgnd 1 -sub 2 -h -b mt2,mt1,poly,diff,sub -t mt5,mt6 	-Maxw 4.5 -p mt3,key,mt4,key 0,6,0 - mt3_mt4.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -R mt4 -b mt1,poly,diff,sub -t 	mt5,mt6 -Maxw 4.5 -p mt2,key,mt4,key 0,6,0 - mt2_mt4.sip
sip -V -s -cgnd 1 -sub 2 -h -b mt1,poly,diff,sub -t mt4,mt5,mt6 	-Maxw 4.5 -p mt2,key,mt3,key 0,6,0 - mt2_mt3.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -R mt3 -b poly,diff,sub -t 	mt4,mt5,mt6 -Maxw 4.5 -p mt1:mt1_cut,key,mt3,key 0,6,0 - mt1_mt3.sip
sip -V -s -cgnd 1 -sub 2 -h -b poly,diff,sub -t mt3,mt4,mt5,mt6 	-Maxw 4.5 -p mt1:mt1_cut,key,mt2,key 0,6,0 - mt1_mt2.sip
sip -V -s -cgnd 1 -sub 2 -L3A -h -R mt2 -b diff,sub -t 	mt3,mt4,mt5,mt6 -k mt1:0.6 -Maxw 4.5 -p poly:poly_cut,key,mt2,key 	0,6,0 - poly_mt2.sip
sip -V -s -cgnd 1 -sub 2 -h -R mt1,poly -b diff,sub -t 	mt2,mt3,mt4,mt5,mt6 -Maxw 4.5 -p poly:poly_cut,key,mt1:mt1_cut,key 	0,6,0 - poly_mt1.sip
