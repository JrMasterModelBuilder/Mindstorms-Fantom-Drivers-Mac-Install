# LEGO Mindstorms Fantom Drivers Mac Install Script

A script to install the LEGO Mindstorms Fantom drivers on modern macOS versions.


## Overview

The trouble with the native installer package, is that the installer tries to install a legacy codeless kernel extension named `Fantom.kext`. There are several problems with this.

- `Fantom.kext` depends on the legacy 32-bit `com.apple.kernel.iokit` which has not shipped with macOS for some time.
- `Fantom.kext` has no code signature, so it cannot be loaded on 10.10+ without disabling security feature.
- The installer attempts to install to `/System/Library/Extensions/Fantom.kext`, which is a directory protected by System Integrity Protection, or SIP, so it fails to even install on 10.11+ without SIP being disabled.
- It also installs an unnecessary `StartupItems` to try to load the kernel extension, which is useless since it cannot be loaded anyway.

Ultimately, this kernel extension appears to be completely unnecessary, as nothing actually appears to fail without it. The other parts of the driver are however needed to communicate with the Mindstorms brick.

- `/Library/Application Support/National Instruments`
- `/Library/Frameworks/Fantom.framework`
- `/Library/Frameworks/VISA.framework`
- `/Library/Preferences/NIvisa`

This script will manually install only the necessary files from the official PKG installer, preserving the correct permissions, and ignoring the useless files.


## Usage

1. Download the `legodriverinstaller.sh` script.
2. Obtain the official PKG installer file.
3. Open a terminal to the directory of the `legodriverinstaller.sh` script.
4. Give the script executable permissions so it can be run.
```bash
chmod +x ./legodriverinstaller.sh
```
5. Run the script, passing the path to the PKG installer.
```bash
sudo ./legodriverinstaller.sh 'MAC legodriver.pkg'
```
6. Profit.


## License

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

See [LICENSE.txt](LICENSE.txt)
