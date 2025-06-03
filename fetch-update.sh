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
echo $STATUS
if [ "$STATUS" = "Already up to date." ]; then
    exit 0
fi

COMMIT=$(git rev-list --count --all)
sed "s/_VERSION_/$COMMIT/g" template.spec > SPEC/sif.spec
mkdir sif-$COMMIT
cp sif.py sif-$COMMIT
cp database.json sif-$COMMIT
cp README.md sif-$COMMIT
cp fix-wm-class.sh sif-$COMMIT
cp LICENSE sif-$COMMIT

tar -cvzf sif-$COMMIT.tar.gz sif-$COMMIT

rm -rf sif-$COMMIT

mv -f sif-$COMMIT.tar.gz /home/$USER/Utilities/Staging/sif-rpm/SOURCES
cd /home/$USER/Utilities/Staging/sif-rpm

git add -A
git commit -m "Mirroring update to SIF."
git push