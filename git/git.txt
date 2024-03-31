----------------------------------------------------------------- GIT SETUP -------------------------------------------------------------------------------

git config --global user.name "Winston"

git config --global user.email "mabenwinston@gmial.com"

git init 

git clone <url>

git add .
git add <file_name>

git commit -m "message for commit"

git remote add origin <url> [Here origin is remote repo name]

git push origin <branch_name>

git pull origin <branch_name>

git fetch origin <branch_name>

----------------------------------------------------------------- GIT REVERT & RESET --------------------------------------------------------------------------

git revert <commit-id>

git revert HEAD~3 [revert last 3 commits]

git reset --hard [undo with changes removed]
git reset --soft [undo with changes preserved]



----------------------------------------------------------------- GIT TRACKING ------------------------------------------------------------------------------

git diff --staged [Track the changes that have staged but not committed]

git diff HEAD [Track the changes after committing a file]

git diff <branch 1> < branch 2>

git blame <file_name> [Display the modification on each line of a file]

git status

git log

git tag

git tag <tag_name>

git tag -d <tag_name>

----------------------------------------------------------------- GIT STASH ----------------------------------------------------------------------------------

git stash save "<Message>"

git stash list

git stash apply [reapply the changes to your working copy and keep them in your stash]

git stash show

git stash pop [removes the changes from your stash and reapplies them to your working copy]

git stash pop stash@{2}

git stash drop

git stash drop stash@{1}

git stash branch <new_branch_name> stash@{1} [create a new branch of out of a stash]

git stash clear

git stash branch <branch_name> [create a new branch of a latest stash]

git cherry-pick <commit id>

** By default, "git stash pop" will re-apply the most recently created stash: stash@{0}
** Cherry picking is the act of picking a commit from a branch and applying it to another.

----------------------------------------------------------------- GIT BRANCH ---------------------------------------------------------------------------------

git branch -a [show all local and remote branches]

git branch <branch_name> [create a new branch]

git branch <new_branch> <tag_name> [create new branch from a tag]

git branch <new_branch> <commit-id> 

git checkout -b <new_branch> <old_branch> [create a new branch from existing branch]

git checkout <branch_name>

git branch -d <branch_name>

git branch -m <old_name> <new_name>

git push origin -d <branch_name> [delete a remote branch]


----------------------------------------------------------------- GIT MERGE & REBASE ------------------------------------------------------------------------

git merge <branch_name>

git branch --merged [shows the merged branches]

git rebase <branch_name>

git rebase HEAD~4 [transform latest 4 commits as a single commit]


** Merge conflict arise when same line within a file is edited or when a file is deleted in one branch and edited in another.
** To untract certain file add its entry in ".gitignore" file

---------------------------------------------------------------------------------------------------------------------------------------------------------------


git diff --diff-filter=AMR --name-only  $PREVIOUS_TAG $BRANCH_NAME Online | xargs -n 1 -I '{}' cp --parents -r '{}' ${INST_HOME}

git diff --diff-filter=AMR --name-only  '''+PREVIOUS_TAG+''' origin/$BRANCH_NAME Online | xargs -n 1 -I {} cp --parent -r {} incremental