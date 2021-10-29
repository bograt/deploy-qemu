#!/bin/bash
# establish working directory
cwd=$(cd "$(dirname "$0")"; pwd -P)

# check if qemu and homebrew are installed; install if not
if ! command -v qemu-img &> /dev/null
then
	if ! command -v brew &> /dev/null
	then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	brew install qemu
fi

# prepare install image
qemu-img create -f qcow2 "$cwd"/debian.img 30G

# mount iso and install to image
## 2 cores, 4G RAM, hvf accelerated
qemu-system-x86_64 -m 4G -cdrom "$cwd"/debian-11.0.0-amd64-DVD-1.iso -drive file="$cwd"/debian.img,format=qcow2 -boot d -accel hvf -smp 2

# make app directory structure 
appdir="/Applications/Debian.app/Contents/MacOS/"
mkdir -p "$appdir"

# move image to app directory
mv "$cwd"/debian.img "$appdir"

# make script in app directory
cat <<'EOF' > "$appdir"Debian
#!/bin/bash
cwd=$(cd "$(dirname "$0")"; pwd -P)
/usr/local/bin/qemu-system-x86_64 -m 4G -drive file="$cwd"/debian.img,format=qcow2 -boot c -accel hvf -smp 2
exit 0
EOF

# make executable
chmod +x "$appdir"Debian

# Sets an icon on file or directory
iconSource=$cwd/Debian.png
iconDestination=/Applications/Debian.app
icon=/tmp/`basename $iconSource`
rsrc=/tmp/icon.rsrc

# Create icon from the iconSource
cp $iconSource $icon

# Add icon to image file, meaning use itself as the icon
sips -i $icon

# Take that icon and put it into a rsrc file
DeRez -only icns $icon > $rsrc

# Apply the rsrc file to
SetFile -a C $iconDestination

if [ -f $iconDestination ]; then
    # Destination is a file
    Rez -append $rsrc -o $iconDestination
elif [ -d $iconDestination ]; then
    # Destination is a directory
    # Create the magical Icon\r file
    touch $iconDestination/$'Icon\r'
    Rez -append $rsrc -o $iconDestination/Icon?
    SetFile -a V $iconDestination/Icon?
fi

# add desktop shortcut
ln -s /Applications/Debian.app "$HOME"/Desktop/
