d=$1
h2s=$2
i=$3
genVar=$4
method=$5
dir=d_$d/genVar_$genVar/h2s_$h2s/sim_$i

make threshold d=$d n=1200 h2s=$h2s dc=10 genVar=$genVar chr=22 i=$i outdir=/home/shussain/FADS/extended/hapmap3 name="hapmap3ceu22"
#make move dir=$dir h2s=$1

#
#			--nonlinear exp \
#			--expbase $(base) \
#			--proportionNonlinear 0
