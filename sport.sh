#####################
# Set my parameters #
#####################

# My Garmin Connect username
mygarminusername="USERNAME"
# My Garmin Connect password
mygarminpassword="PASSWORD"
# My number of past activities to export from Garmin Conncet. Hint: Garmin API limit is 1000 max.
mynumberofexports="20"
# My GoldenCheetah backup folder
mybackupfolder=(~/GoogleDrive/Sport/GoldenCheetah/Backup/)
# My Athletelibrary folder
myathletelibraryfolder=(~/GoogleDrive/Sport/GoldenCheetah/AthleteLibrary/Johannes/)
# My Garmin Connect export script folder
mygarminconnectexportscriptfolder=(~/GoogleDrive/Sport/GoldenCheetah/GarminConnectScript/)
# My Garmin Connect exported activity folder
mygarminconnectexportsfolder=(~/GoogleDrive/Sport/GoldenCheetah/GarminConnectExports/Johannes/)

############################################
# Downloads activities from Garmin Connect #
############################################

python $mygarminconnectexportscriptfolder/gcexport.py -d $mygarminconnectexportsfolder -c "$mynumberofexports" -f original -u --username "$mygarminusername" --password "$mygarminpassword"

#####################################################
# Cleaning json as not used and required for backup #
#####################################################

cd $mygarminconnectexportsfolder
rm *.json

##############################
# Open GoldenCheetah finally #
##############################

open -a GoldenCheetah

########################
# User action required #
########################

echo    Golden Cheeath opens
echo    Import at background runs
echo    ---------------------------------------
echo    ----------- ACTION REQUIRED -----------
echo    ---------------------------------------
echo    Edit your downloaded activities
echo    Save all edited activites
echo    Create a backup?

######################
# Waiting for answer #
######################

read -p "[y] = yes. [n] = no " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

######################
# Kill GoldenCheetah #
######################

pkill GoldenCheetah

##################
# Backup Section #
##################

######################
# Grab Date und Year #
######################

todaysdate=$(date +%Y%m%d)
todaysyear=$(date +%Y)

##############
# ZIP backup #
##############

# Keep history of 5 backups
cd $mybackupfolder
ls -dt *.zip | tail -n +5 | xargs rm -rf

# Zips entire athleteslibrary folder and backups on daily basis
zip -r -9 -x ~/GoogleDrive/Sport/GoldenCheetah/AthleteLibrary/Johannes/cache/\* ~/GoogleDrive/Sport/GoldenCheetah/AthleteLibrary/Johannes/imports/\* -o $mybackupfolder/"$todaysdate".zip $myathletelibraryfolder

###############################
# Archive exported activities #
###############################

# Check and create Year Folder
mkdir $mygarminconnectexportsfolder/$todaysyear/

# move previous files to archive
mv $mygarminconnectexportsfolder/*.fit $mygarminconnectexportsfolder/$todaysyear/