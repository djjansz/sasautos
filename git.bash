# run the cygwin septup and install bash, vim, cmkae, python, kde base apps, and the x windowing stystem and then check that they are working
info startx 
# start the x windowing system
startx
# run the cygwin setup and get all of the Git applications in the section "Development" after installing, view the help
git
# this is the same as
git --help
# see all subcommands of Git
git help --all
# help on a specific subcommand
git merge --help
# some subcommands have options, such as the amend option of the commit subcommand
git commit --amend
#short options only have a single hyphen 
git commit -m "fixed typo"
git commit --message="fixed typo"
#turn a folder into a git repository
cd ~/LFM*
git init
#add files individually to the repository
git add autoexec.sas
# add all files in the current directory to the repository
git add .
# check the status of the addition
git status
# fully qualified commit with author and commit log entry
git commit -m "Initial contents of the LFM" \ --author =" David Januszewski <david.januszewski@rsagroup.ca>"
# sort by descending (r for reverse) time modified with a long listing of file attributes (l)
ls -trl
# create a new file in vim
vim
# press i for insert mode, enter some text, press escape to go to command mode and enter :w filename1.txt, then press Shift+ZZ while in command mode
cat filename1.txt
# Set the git editor environment variable to vim so that we use vim with git
export GIT_EDITOR=vim
# You can set global author names that override other configuration settings
export GIT_AUTHOR_NAME="David Januszewski"
export GIT_AUTHOR_EMAIL="david.januszewski@rsagroup.ca"
# You can save your identity in a configuration file
git config user.name "David Januszewski"
git config user.email "david.januszewski@rsagroup.ca"
# Edit a file with vim - i for insert mode, esc for command mode, dd to delete a row, o to open a line above, x to delete, h,j,k,l are to navigate
vim RSA_GLM_F*
# add a comment or else it might abort the commit if no metadata is provided
git commit RSA_GLM_Formats.sas -m "SAS Formats for the LFM"
# view the history of commits
git log
# show more about one individual commit by using the commit ID
git show e0c845c4ebb27dc21f1666ea1dc825b5f0b0b501
# rename the Atlantic folder to get rid of the ampersand which Linux does not like. Then add the Atlantics LFM program folder.
gvfs-rename "LFM_AT_R&D" "LFM_AT_RD"
cd /cygdrive/e/sas/rfsl/RSA/RSA_PA/programs/LFM_AT_RD
git init
git add .
git commit .
#after commiting, add a line in quotes? at the top (no comment character #)
 git show-branch --more=9
git show 962df80caa726beee4174846edbf4b81fc1f7049
#adding and deleting files
git rm Build*
git add Contents*
git rm Buil*
#now start creating a new program and commit it
touch 'CW Datasets Used as Inputs.sas'
vim CW*
git add CW*
git commit -m 'adding the first program'
# Now clone the directory by going to the root directory and clone/copy the directory with the command git clone
cd ..
git clone LFM_AT_RD LFM_AT_CORE
# use git config -l to see all of the global variables
git config -l
# use git unset to remove a global configuration value
git config --unset --global user.email  
# You can also create aliases for large commands in a similar fashon as with bash
git config --global alias.show-graph \ 'log --graph --abbrev-commit --pretty = oneline' 
# create a folder and repository for the SAS-Git example
mkdir ~/Git
touch ~/Git/git.bash
# add the first version to the bash program and save it
vim ~/Git/git.bash
# configure the system so that it uses someones name when committing files to
git config -global user.name "Dave Januszewski"
git config --global user.name "Dave Januszewski"
git config --global user.email "david.januszewski@rsagroup.ca"
git config --global user.name "David Januszewski"
git init
git add git.bash
git commit -m "added git.bash"
git log
git status
mkdir doc
#add a subdirectory to the Git repository
echo This directory contains examples of using Git with SAS > doc/readme.txt
git status
# create a file that tells Git which files not to track - a gitignore file
touch .gitignore
# on a separate line, add *.egp, *.sas7bdat, *.sas7bcat, *docx, *.doc, *txt, *.xlsx, *.xlsxm, *.accdb, *.mdb
vim .gitignore
git add .gitignore
git status
git commit -m "add a gitignore file so that we do not track sas datasets"
git log
# mark a major milestone with tag version 1
git tag 1.0
# create a new branch and give it a name
git branch sasprogit
# check out the new branch and edit it without editing the original branch
git checkout sasprogit
# create a new branch to make some changes without touching the original version
git branch sasprogit
# checkout the new branch
git checkout sasprogit
# edit a fil in the new branch and commit the changes
vim git.bash
git commit -am "create a new branch and modify the code"
git status
git add .
git status
* view the differences from a recent commit
git diff HEAD
# switch back to the master after you are satisified with the changes
git checkout master
git log
# if we are satisfied with the changes in sasprogit then merge the branch with the master
git merge sasprogit
# delete the branch that was used to test changes
git branch -d sasprogit
