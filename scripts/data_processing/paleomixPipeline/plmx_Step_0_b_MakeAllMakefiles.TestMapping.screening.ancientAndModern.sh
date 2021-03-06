########### THIS SCRIPT (SHELL) WILL MAKE 1 makefile for every sample to be used in paleomix ########
# note you have to run this with source not sh because it uses cd (or submit as a job)
############  directories ########
gitDir=/u/home/a/ab08028/klohmueldata/annabel_data/GalapagosRails
# scripts:
scriptDir=$gitDir/scripts/data_processing


########### file locations: ########
SCRATCH=/u/flashscratch/a/ab08028
wd=$SCRATCH/GalapagosRails
fastqs=$wd/fastqs
makefileDir=$scriptDir/paleomixPipeline/makefiles
modernTemplate=$makefileDir/modernMakefiles-GalapagosRails/makefile_template.modernDNA.testMultGenomes.birds.yaml
ancientTemplate=$makefileDir/ancientMakefiles-GalapagosRails/makefile_template.aDNA.noIndelR.testMultGenomes.birds.yaml
ancHeaders=$wd/samples/jaime.Bird.Screen.txt

modHeaders=$wd/samples/jaime.Bird.Screen.modern.txt # can find out from Jaime which samples are modern and use here

#mkdir -p $makefileDir/ancientMakefiles-GalapagosRails
#mkdir -p $makefileDir/modernMakefiles-GalapagosRails
########### ancient makefiles ########
# instead of START/END, using while read list of samples
cat $ancHeaders | while read header
do
echo $header
# note the need for double quotation marks for sed
# make a new version of the makefile
######## *** ALWAYS MAKE SURE SETTINGS ARE APPROPRIATE *** ###########
# calling /bin/cp because my cp is aliased to be interactive
/bin/cp $ancientTemplate $makefileDir/ancientMakefiles-GalapagosRails/${header}.paleomix.makefile.yaml
newMake=$makefileDir/ancientMakefiles-GalapagosRails/${header}.paleomix.makefile.yaml
# for now NAME OF TARGET and SAMPLE are going to be the same
sed -i'' "s/NAME_OF_TARGET:/$header:/g" $newMake
sed -i'' "s/NAME_OF_SAMPLE:/$header:/g" $newMake
sed -i'' "s/NAME_OF_LIBRARY:/${header}_1a:/g" $newMake
# for now just naming Lane: Lane 1 because just one lane of novaseq
sed -i'' "s/NAME_OF_LANE:/Lane_1:/g" $newMake
# use different delims (|) to avoid filepath slash confusion:
sed -i'' 's|: PATH_WITH_WILDCARDS|: '${fastqs}\/${header}_S*_L*_R{Pair}_*fastq.gz'|g' $newMake

# clear variables
newMake=''
done
############## modern makefiles ###########
cat $modHeaders | while read header
do
echo $header
# note the need for double quotation marks for sed
# make a new version of the makefile
######## *** ALWAYS MAKE SURE SETTINGS ARE APPROPRIATE *** ###########
# calling /bin/cp because my cp is aliased to be interactive
/bin/cp $modernTemplate $makefileDir/modernMakefiles-GalapagosRails/${header}.paleomix.makefile.yaml
newMake=$makefileDir/ancientMakefiles-GalapagosRails/${header}.paleomix.makefile.yaml
# for now NAME OF TARGET and SAMPLE are going to be the same
sed -i'' "s/NAME_OF_TARGET:/$header:/g" $newMake
sed -i'' "s/NAME_OF_SAMPLE:/$header:/g" $newMake
sed -i'' "s/NAME_OF_LIBRARY:/${header}_1a:/g" $newMake
# for now just naming Lane: Lane 1 because just one lane of novaseq
sed -i'' "s/NAME_OF_LANE:/Lane_1:/g" $newMake
# use different delims (|) to avoid filepath slash confusion:
sed -i'' 's|: PATH_WITH_WILDCARDS|: '${fastqs}\/${header}_S*_L*_R{Pair}_*fastq.gz'|g' $newMake

# clear variables
newMake=''
done
