#!/bin/bash
#!/bin/bash
NAME="yoti-connect-1.0.0-edge.zip"
SDK_RELATIVE_PATH="sdk"
curl https://github.com/getyoti/php/archive/master.zip -O -L
unzip master.zip -d sdk
mv sdk/php-master/src/* sdk
rm -rf sdk/php-master


if [ ! -d "./yoti-connect" ]; then
    echo "ERROR: Must be in directory containing ./yoti-connect folder"
    exit
fi

if [ ! -d "$SDK_RELATIVE_PATH" ]; then
    "ERROR: Could not find SDK in $SDK_RELATIVE_PATH"
    exit
fi

echo "Packing plugin ..."

# move sdk symlink (used in symlink-plugin-to-site.sh)
sym_exist=0
if [ -L "./yoti-connect/site/sdk" ]; then
    mv "./yoti-connect/site/sdk" "./__sdk-sym";
    sym_exist=1
fi

cp -R "$SDK_RELATIVE_PATH" "./yoti-connect/site/sdk"
cd yoti-connect && zip -r "$NAME" . -i "*" && mv "$NAME" .. && cd ..
rm -rf "./yoti-connect/site/sdk"

# move symlink back
if [ $sym_exist ]; then
    mv "./__sdk-sym" "./yoti-connect/site/sdk"
fi

rm -rf sdk

echo "Plugin packed. File $NAME created."
echo ""