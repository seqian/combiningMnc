rm /home/wang/Documents/bin/combining/combiningRunsLogs/*.log

for seed in PCCBuckner10; do # 
for desiredDataset in mcsa; do # 

if [ $desiredDataset == "mcsa" ]; then
	inputFolder=/data/data02/wang/input/20130612_mcsa/fMRIStat/${seed}
elif [ $desiredDataset == "adni" ]; then
	inputFolder=/data/data03/wang/input/20140422_ADNI/fMRIStat/${seed}
fi

logsLocation="/home/wang/Documents/bin/combining/combiningRunsLogs/"
if [ ! -d "$logsLocation" ]; then mkdir $logsLocation; fi
echo matlab -nodisplay -r "seed = '$seed'; desiredDataset = '$desiredDataset'; inputFolder = '$inputFolder'; run /home/wang/Documents/bin/combining/combiningRuns.m"
qsub -j y -o $logsLocation/${seed}_${desiredDataset}.log -V -cwd -q long.q << TheyAreLostOnAMagicalIsland
	source /opt/minc/init.sh
	matlab -nodisplay -r "seed = '$seed'; desiredDataset = '$desiredDataset'; inputFolder = '$inputFolder'; run /home/wang/Documents/bin/combining/combiningRuns.m"
TheyAreLostOnAMagicalIsland

done; done
