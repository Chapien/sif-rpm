#!/usr/bin/env sh
eval `ssh-agent`
ssh-add

mkdir -p /home/$USER/repos
cd /home/$USER/repos

if ! test -d "sif-rpm"; then
    echo "No repo!"
    exit 1
fi

if test -d "SIF"; then
    cd SIF
    STATUS=$(git pull)
    if [ "$STATUS" = "Already up to date." ]; then
        echo $STATUS
        exit 0
    fi
else
    git clone git@github.com:BlueManCZ/SIF.git
    cd SIF
fi

COMMIT=$(git rev-list --count --all)
sed "s/_VERSION_/$COMMIT/g" template.spec > /home/$USER/repos/sif-rpm/SPECS/sif-steam.spec
mkdir sif-steam-$COMMIT
cp sif.py sif-steam-$COMMIT
cp database.json sif-steam-$COMMIT
cp README.md sif-steam-$COMMIT
cp fix-wm-class.sh sif-steam-$COMMIT
cp LICENSE sif-steam-$COMMIT

tar -cvzf sif-steam-$COMMIT.tar.gz sif-steam-$COMMIT

rm -rf sif-steam-$COMMIT

mv -f sif-steam-$COMMIT.tar.gz /home/$USER/repos/sif-rpm/SOURCES
cd /home/$USER/repos/sif-rpm

git add -A
git commit -m "Mirroring update to SIF."
git push