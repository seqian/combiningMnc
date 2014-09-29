for seed in PCCBuckner10; do
for desiredDiag in 1 2 4; do
for desiredDataset in mcsa; do

outputFilebase=~/Downloads/${seed}_${desiredDataset}_diag${desiredDiag}
#outputFilebase=/data/data03/wang/output/20140627_comparisonAverage/${seed}_${desiredDataset}_diag${desiredDiag}

if [ $desiredDataset == "mcsa" ]; then
inputFolder=/data/data02/wang/input/20130612_mcsa/fMRIStat/${seed}/data2/
elif [ $desiredDataset == "adni" ]; then
inputFolder=/data/data03/wang/input/20140422_ADNI/fMRIStat/${seed}/data2/
fi

qsub -j y -o combiningAllSubjectsLogs/${seed}_adni_diag${desiredDiag}.log -V -cwd -q fast.q << TheyAreLostOnAMagicalIsland
	source /opt/minc/init.sh
	matlab -nodisplay -r "seed = '$seed'; desiredDiag = $desiredDiag; desiredDataset = '$desiredDataset'; inputFolder = '$inputFolder'; output_file_base{1} = '$outputFilebase'; run /home/wang/Documents/bin/combining/combiningAllSubjects.m"
TheyAreLostOnAMagicalIsland


done; done; done
