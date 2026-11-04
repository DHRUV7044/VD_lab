set -e
set -x

rex -dp_comm_string 1,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexaUtVN8j np_rM1term::mt1_cut - rVia1,1,x rPSDcont,1,t rPOLYcont,1,T rNSDcont,1,t - L1T0,1,I

rex -dp_comm_string 2,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexa4xnvrB np_rPOLYterm::poly_cut - PMOS_MOS_27_mgvia,1,z NMOS_MOS_21_mgvia,1,z rPOLYcont,1,x

rex -dp_comm_string 3,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexa3TMrIv np_rM3term::mt3_cut - rVia3,1,x rVia2NoCapInd,1,T

rex -dp_comm_string 4,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexaZzbBHS np_rM2term::mt2_cut - rVia2NoCapInd,1,x rVia1,1,T

rex -dp_comm_string 5,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexajZ3Rpt np_rM4term::mt4_cut - rVia4,1,x rVia3,1,T

rex -dp_comm_string 6,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexaygUnWw np_rM5term::mt5_cut - rVia5,1,x rVia4,1,T

rex -dp_comm_string 7,server3.eced.svnit.ac.in,43701 -V -m -pd -I# -tech /tools/cadence/FOUNDRY/analog/180nm/pv/assura/rcx_RF -map p2elayermapfile -N NET -e2 -Ply np_rPOLYterm -rP res.mod -mp mprexatQTxQP np_rM6term::mt6_cut - rVia5,1,T

rexmerge -V -N NET -n mprexa4xnvrB,mprexaUtVN8j,mprexaZzbBHS,mprexa3TMrIv,mprexajZ3Rpt,mprexaygUnWw,mprexatQTxQP -b np_rPOLYterm::Rnp_rPOLYterm.dev2,np_rM1term::Rnp_rM1term.dev2,np_rM2term::Rnp_rM2term.dev2,np_rM3term::Rnp_rM3term.dev2,np_rM4term::Rnp_rM4term.dev2,np_rM5term::Rnp_rM5term.dev2,np_rM6term::Rnp_rM6term.dev2 -l ,L1T0,,,,, np_rPOLYterm.res,np_rM1term.res,np_rM2term.res,np_rM3term.res,np_rM4term.res,np_rM5term.res,np_rM6term.res

