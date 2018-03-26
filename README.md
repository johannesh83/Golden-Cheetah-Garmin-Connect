# Golden-Cheetah-Garmin-Connect
You are a runner, cyclist or triathlete? You love Golden Cheetah? You track your activities with Garmin devices? You want to download all of them from Garmin Connect?

Okay, last one got already answered within here: [garmin-connect-export](https://github.com/JohannesHeinrich/garmin-connect-export)

Alright, where´s the problem?!? Rise a feature request and ask for new Golden Cheetah functionality! But exactly this is easier said than done:

1. Garmin charges an expensive one-time administrative fee to cover their extensive engineering and server support they require for running the Connect program.
2. Golden Cheetah is an open source application and there might be no chance of any payment to Garmin for its use at all.
3. As Garmin does also not offer alternatives the chances for a new Golden Cheetah feature are really low.

But now, you want to archive, cloud-backup and import automatically into Golden Cheetah? There are tons of alternatives and workarounds. Here is mine.

# Download, archive, backup, auto-import!
Apple claims writing a shell script is like riding a bike: "You fall off and scrape your knees a lot at first. With a bit more experience, you become comfortable riding them around..." Awesome! For the rest I totally agree. "Shell scripting is perfect for creating small pieces of code that connect other tools together."

## Tooling
Before we are diving into details some insights on my tooling: Mac user, running their latest OSX. Additional to that my preferred cloud storage is Google Drive. The latter would not make any difference to a Dropbox, Box.com or another typical cloud storage.

### What else you need
If it did not yet happen you need to download the following.

- [Golden Cheetah](http://goldencheetah.org/)
- [Python](https://www.python.org/downloads/)
- [My shell script.](https://github.com/JohannesHeinrich/Golden-Cheetah-Garmin-Connect/blob/master/sport.sh) **Continue reading for details.**
- [Download script for Garmin Connect data](https://github.com/JohannesHeinrich/garmin-connect-export)

## Initial configuration
Follow these steps for the initial configuration.

### Folder structure
If you decide to create these folders in your preferred cloud storage, for example a Google Drive, they get synced automatically in the background from your local client to your cloud storage.

- One folder for your backups: `~/GoogleDrive/Sport/GoldenCheetah/Backup/`
- Another one for your Golden Cheetah Athletes Library: `~/Documents/GoldenCheetah/AthleteLibrary/Johannes/`
- And another one for your exports from Garmin Connect to auto-import them to Golden Cheetah: `~/GoogleDrive/Sport/Garmin/Johannes/`


### Golden Cheetah
Configuring our awesome performance software step by step.

- Unzip and install Golden Cheetah.
- Open it.
- Create a new athlete.
- Change Golden Cheetahs athletes directory to the folder you just created: Open *Preference*, *General* and there it is. Save it.
- Close GoldenCheetah.
- Open it again.
- If you have to create your athlete again. Do it. It will re-create all subfolders in the new athlete directory.
- Configure your auto import folder: Go to *Preference*, *General*, *Tab: auto imports*. Save it.
- That´s it for Golden Cheetah. Close it.

### My shell script:
```
#####################
# Set my parameters #
#####################

# My Garmin Connect username
mygarminusername="USERNAME"
# My Garmin Connect password
mygarminpassword="PASSWORD"
# My number of past activities to export from Garmin Conncet
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
```

#### Setting parameters
- Set your Garmin Connect username: `mygarminusername="yourusername"`
- Set your Garmin Connect password: `mygarminpassword="yourgarminconnectpassword"`
- Set your number of past activities to export from Garmin Connect: `mynumberofexports="10"`
- Reference to your GoldenCheetah backup folder: `mybackupfolder=(~/GoogleDrive/Sport/GoldenCheetah/Backup/)`
- Reference to your Athletelibrary folder: `myathletelibraryfolder=(~/Documents/GoldenCheetah/AthleteLibrary/Johannes/)`
- Reference to your Garmin Connect export script folder: `mygarminconnectexportscriptfolder=(~/GoogleDrive/Sport/GoldenCheetah/GarminConnectScript/)`
- Reference to your Garmin Connect export folder: `mygarminconnectexportsfolder=(~/GoogleDrive/Sport/GoldenCheetah/GarminConnectExports/Johannes/)`

## Run it
Running the script is easy. There are various ways. Very old school with a simple terminal command: `sh sport.sh`. Or make sure that Python is installed and just double-click your *.sh.

### What the script does
The following section explains in detail what the rest of the script does. But first: You don´t have to adjust anything else there. Everything got already configured with setting the parameters.

1. Downloads activities from Garmin Connect
2. Cleans json as not used and required for backup
3. Opens GoldenCheetah finally
4. Request user input if a backup shall be taken
5. Waits for answer
6. Kills GoldenCheetah if still open
7. Starts backup section
8. Grabs Date und Year
9. Keeps history of most recent 5 backups
10. Zips entire athleteslibrary folder and backups on daily basis
11. Archives exported activities
12. Checks and creates Year Folder
13. Moves previous files to archive

## How to recover a backup
The most important folder is your athlete directory. Everything in there gets "backuped" and can easily get recovered with overwriting a newly created athlete:
1. Download, unzip, install and open GoldenCheetah.
2. Create a new athlete.
3. Change athlete directory.
4. Close GoldenCheetah.
5. Open GoldenCheetah again. Just to be on the safe side.
6. Unzip latest ZIP from your backups.
7. Replace new athlete folder with your Backup.
8. Open Golden Cheetah.
9. Backup recovered.

# Contributions
Contributions are warmly welcome, particularly if this script stops working with Garmin Connect. You may consider opening a GitHub issue first. New features, however simple, are encouraged. Your feedback is highly appreciated!

# Thank You
Other than that, thx for using this script.

# DISCLAIMER
No Guarantee

This script does NOT guarantee to get all your data or even download it correctly. Against my Garmin Connect account it works quite fine and smooth, but different Garmin Connect account settings or different data types could potentially cause problems.

Garmin Connect API

This is NOT an official feature of Garmin Connect, Garmin may very well make changes to their APIs that breaks this script (and they certainly did since this project got created for several times).

Golden Cheetah

This is NOT an official feature of Golden Cheetah, Golden Cheetah may very well make changes that breaks this script.

THIS SCRIPT IS FOR PERSONAL USE ONLY

It simulates a standard user session (i.e., in the browser), logging in using cookies and an authorization ticket. This makes the script pretty brittle. If you're looking for a more reliable option, particularly if you wish to use this for some production service, Garmin does offer a paid API service.

Security Disclaimer

The way as the shell script is described has litte to no change of running securely. Passwords are stored plain in the script itself. It definitely has a lot of room for improvements. My intention is to keep it as simple and pragmatic for you. That is the basis to adjust it according your personal paranoia level. The most secure way would be to type it in every time you run the script.

License
-------
[MIT](https://github.com/JohannesHeinrich/Golden-Cheetah-Garmin-Connect/blob/master/LICENSE) &copy; 2018 Johannes Heinrich