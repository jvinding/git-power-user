## Configuration & Handy Commands

* https://github.com/jvinding/Environment/blob/master/dot_files/gitconfig
* https://github.com/jvinding/Environment/blob/master/plugins/git
* Shell Prompt
    * https://denysdovhan.com/spaceship-prompt/
    * https://github.com/magicmonty/bash-git-prompt
* Commands for use in scripts
    * `cd "$(git rev-parse --show-cdup)".`
        * `--show-cdup` shows relative path, e.g. `../../`, `.` on the end is for when you're already in the repos root
    * `branch=$(git symbolic-ref --short HEAD 2> /dev/null)`
    * `tracked_branch=$(git config --get branch.$(git symbolic-ref --short HEAD).merge)`
* `git co -`
* `git push -u`
* `git diff --cached`
* aliases

```
[alias]
    co=checkout
    pr = pull --rebase --autostash
    s = status -sb
    b = branch
    dc = diff --cached
    fa = fetch --all
    l = log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)[%an]%Creset' --abbrev-commit --date=human
    ls = ls-files --exclude-standard
    lsm = ls-files --exclude-standard -m
    lso = ls-files --exclude-standard -o
    lsi = ls-files --exclude-standard -io
    lsc = !"git ls-files --unmerged | awk '{print $4}' | sort -u"
    lsd = ls-files --deleted
    pat = !git push --all && git push --tags
```

* Whitespace
    * `git diff -w`
    * For repo
        * `.gitattributes`
            * `text=auto`
            * `*.png binary`
            * `*.sln text eol=crlf`
    * For self only
        * `git config --global core.autocrlf true`
            * For windows users, converts both ways
        * `git config --global core.autocrlf input`
            * For Mac/Linux users
        * `core.whitespace`
            * `git config --global core.whitespace trailing-space,space-before-tab,tab-in-indent`
                * Shows red in diffs
            * `git rebase --whitespace=fix HEAD^`
                * *DANGER: Changes history. Don't use on pushed commits*

## 3rd-Party Tools

* Hub
    * https://github.com/github/hub
    * create pull request at the command-line
    * clone github repos easily
* diff-so-fancy
    * install with homebrew
    * https://github.com/so-fancy/diff-so-fancy

```
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
```
* Kaleidoscope
    * https://www.kaleidoscopeapp.com/
    * In-app menu: `Kaleidoscope` > `Integration...` -> `Command Line Tool`
    * Demo notes
        1. `./scripts/conflict-setup.sh`

```
[merge]
    conflictstyle = diff3
    tool = Kaleidoscope
[mergetool "Kaleidoscope"]
    cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
    trustexitcode = true
```

## Get out of trouble

* `git reset`
    * `<filename>`
        * unstages `<filename>`
        * can also use `.` to unstage everything ietarting in the CWD
    * `--hard` *DANGEROUS can lose work*
    * `--soft` *DANGER: Changes history. Don't use on pushed commits*
        * accidentally commited on `master` instead of a feature branch?
        * `git reset --soft HEAD^`
* `git add --patch` && `git stash save --include-untracked --keep-index` (a.k.a.: `-uk`)
    * Demo notes
        * `./scripts/stash-setup.sh`
        * `git add --patch stash0.txt`
        * `s` to split
        * stage first line only
        * what I'm about to commit is different that what I've tested.
        * `git stash save -uk`
        * now you can run tests just on the changes you've staged to commit
* `git commit --amend`
    * *DANGER: Changes history. Don't use on pushed commits*
    * can be used to change commit message
    * can be used to change the commit diff
    * Demo Notes
        * `./scripts/stash-setup.sh`
        * `git commit -m'message' stash0.txt`
        * `git commit --amend`
            * add better commit message
        * `git add stash2.txt`
        * `git commit --amend`
        * Stage files to add to previous commit, then run this to add it
* `git rebase --interactive`
    * *DANGER: Changes history. Don't use on pushed commits*
    * Demo notes
        1. `./scripts/rebase-setup.sh`
        2. reorder
            1. `git rebase --interactive <commit>^`
            2. group commits for each file
        3. Squash
            1. `git rebase --interactive <commit>^`
            2. "fixup" vs "squash"
* `git cherry-pick <commit>`
* committed on detached head
    * `git reflog`
    * `git cherry-pick <commit>`
* Find commit where a file was deleted
    * `git log --diff-filter=D --summary`
    * `git log --diff-filter=D --summary -- '*.json'`
* `git rebase --exec`
    * Demo notes
        1. `./scripts/bisect-setup.sh`
        2. run `git rebase --exec scripts/bisect-test.sh`
* `git bisect`
    * Demo notes
        1. `./scripts/bisect-setup.sh`
    * `git bisect good <hash>`
    * `git bisect bad <hash>`
    * Run test
        * Demo notes
            1. `./bisect-test.sh && echo "good"`
    * `git bisect bad` or `git bisect good` until done
    * `git show` to show the bad commit
    * `git bisect reset`
    * extras
        * `git bisect log`
        * `git bisect visualize`

## Other git commands

* Remove file from git
    * add to `.gitignore`
    * `git rm --cached <file>`
* assume

```
[alias]
    ls-assumed = !"git ls-files -v | grep '^[a-z]' | cut -c3-"
    assume = update-index --assume-unchanged
    unassume = update-index --no-assume-unchanged
```

* `git submodule`
    * NEVER EVER EVER USE `git submodule` if you value your sanity.
