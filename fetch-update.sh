#!/usr/bin/env sh
eval `ssh-agent`
ssh-add

echo "Updating sif-rpm."
mkdir -p /home/$USER/repos
cd /home/$USER/repos

echo "Making sure the repo is where we expect it to be."
if ! test -d "sif-rpm"; then
    echo "No repo!"
    exit 1
fi

echo "Checking if we already have the SIF repo"
if test -d "SIF"; then
    echo "Found SIF repo"
    echo "Pulling latest from SIF..."
    cd SIF
    STATUS=$(git pull)
    if [ "$STATUS" = "Already up to date." ]; then
        echo $STATUS
        exit 0
    fi
else
    echo "SIF not found."
    echo "Cloning SIF repo..."
    git clone git@github.com:BlueManCZ/SIF.git
    cd SIF
fi

COMMIT=$(git rev-list --count --all)
echo "Sif Version $COMMIT"
echo "Preparing to compress sif-steam-$COMMIT..."
mkdir sif-steam-$COMMIT
cp sif.py sif-steam-$COMMIT
cp database.json sif-steam-$COMMIT
cp README.md sif-steam-$COMMIT
cp fix-wm-class.sh sif-steam-$COMMIT
cp LICENSE sif-steam-$COMMIT

echo "Compressing sif-steam-$COMMIT..."
tar -cvzf sif-steam-$COMMIT.tar.gz sif-steam-$COMMIT
if [ $? -eq 0 ]; then
    echo "Successfully compressed sif-steam-$COMMIT!"
else
    echo "Failed to compress sif-steam-$COMMIT..."
    exit 1
fi

echo "Removing sif-steam-$COMMIT temporary directory"
rm -rf sif-steam-$COMMIT

echo "Moving source tar.gz to this repo."
mv -f sif-steam-$COMMIT.tar.gz /home/$USER/repos/sif-rpm/SOURCES
cd /home/$USER/repos/sif-rpm
echo "Updating spec file version"
sed "s/_VERSION_/$COMMIT/g" template.spec > /home/$USER/repos/sif-rpm/SPECS/sif-steam.spec
echo "Spec file updated."
git add -A
git commit -m "Mirroring update to SIF."
git push
if [ $? -eq 0 ]; then
    echo "Successfully updated SIF build source and pushed to git!"
    exit 0
else
    echo "Git push failed."
    exit 1
fi