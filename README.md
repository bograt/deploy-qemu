# deploy-qemu
A simple script to set up a VM as a MacOS "app" with qemu

## Purpose
This was something I did for possible internal use to add VMs for non-technical macOS users.
It's not really necessary since there are GUI frontends for qemu available on macOS such as UTM, but I thought this would be neat since it deploys the VM as if it's an app, with a desktop icon and everything.

## What it does
1. checks if you've got qemu, and if not, installs it via homebrew, which it will install if you don't have that either.
2. prepares an image for your VM
3. runs qemu, booting from an install ISO
4. after installation is complete, saves a launch script in the proper directory structure for macOS applications
5. converts icon into proper format and applies it to the app
6. creates a shortcut on the Desktop

## Limitations and TODO
- everything is hardcoded atm
- since everything is hardcoded, it assumes CPU architecture is x86_64, and also assumes filenames
