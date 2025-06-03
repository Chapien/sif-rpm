#!/usr/bin/env sh
eval `ssh-agent`
ssh-add

mkdir -p /home/$USER/Utilities/Staging
cd /home/$USER/Utilities/Staging

if ! test -d "sif-rpm"; then
    echo "No repo!"
    exit 1
fi

if test -d "SIF"; then
    cd SIF
else
    git clone git@github.com:BlueManCZ/SIF.git
    cd SIF
fi

STATUS=$(git pull)

if [[ $STATUS = "Already up to date."]]
    exit 0
fi

COMMIT=$(git rev-list --count --all)

tar -cvzf sif-$COMMIT.tar.gz sif.py database.json README.md fix-wm-class.sh LICENSE

mv -f sif-$COMMIT.tar.gz /home/$USER/Utilities/Staging/sif-rpm
cd /home/$USER/Utilities/Staging/sif-rpm

git add -A
git commit -m "Mirroring update to SIF."
git push