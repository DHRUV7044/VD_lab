set -e
set -x

rex -dp_comm_string 1,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexa3Gc3SY np_rM1term::mt1_cut - rVia1,1,x rPSDcont,1,t rPOLYcont,1,T rNSDcont,1,t - L1T0,1,I

rex -dp_comm_string 2,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexaSN7SmT np_rPOLYterm::poly_cut - PMOS_MOS_27_mgvia,1,z NMOS_MOS_21_mgvia,1,z rPOLYcont,1,x

rex -dp_comm_string 3,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexa7EOVO9 np_rM3term::mt3_cut - rVia3,1,x rVia2NoCapInd,1,T

rex -dp_comm_string 4,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexa3JgUIj np_rM4term::mt4_cut - rVia4,1,x rVia3,1,T

rex -dp_comm_string 5,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexadakYy3 np_rM2term::mt2_cut - rVia2NoCapInd,1,x rVia1,1,T

rex -dp_comm_string 6,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexan6j0AL np_rM5term::mt5_cut - rVia5,1,x rVia4,1,T

rex -dp_comm_string 7,vlsilab-client44.eced.svnit.ac.in,34255 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexaChQP7j np_rM6term::mt6_cut - rVia5,1,T

rexmerge -V -N NET -n mprexaSN7SmT,mprexa3Gc3SY,mprexadakYy3,mprexa7EOVO9,mprexa3JgUIj,mprexan6j0AL,mprexaChQP7j -b np_rPOLYterm::Rnp_rPOLYterm.dev2,np_rM1term::Rnp_rM1term.dev2,np_rM2term::Rnp_rM2term.dev2,np_rM3term::Rnp_rM3term.dev2,np_rM4term::Rnp_rM4term.dev2,np_rM5term::Rnp_rM5term.dev2,np_rM6term::Rnp_rM6term.dev2 -l ,L1T0,,,,, np_rPOLYterm.res,np_rM1term.res,np_rM2term.res,np_rM3term.res,np_rM4term.res,np_rM5term.res,np_rM6term.res

