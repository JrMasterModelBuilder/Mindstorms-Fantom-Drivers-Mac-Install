#!/bin/bash

# Copyright 2017 JrMasterModelBuilder
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

if [ "$#" -ne 1 ] ; then
	echo "$0 PATH_TO_PKG"
	exit 1
fi
if [ "$EUID" -ne 0 ] ; then
	echo "Must be run as root, run with sudo"
	exit 1
fi

pkgpath="$1"
pkgbom="$pkgpath/Contents/Archive.bom"
pkgpax="$pkgpath/Contents/Archive.pax.gz"

if [ ! -f "$pkgbom" ]; then
	echo "File does not exist: $pkgbom"
	exit 1
fi
if [ ! -f "$pkgpax" ]; then
	echo "File does not exist: $pkgpax"
	exit 1
fi

sudodrop=''
if [ "$SUDO_USER" != '' ]; then
	sudodrop="sudo -u $SUDO_USER --"
fi

tmpdir="$($sudodrop mktemp -d -t 'legodriverinstaller')"
tmpdircode=$?
if [ "$tmpdircode" -ne 0 ] ; then
	echo "Error creating temp dir: $tmpdircode"
	exit 1
fi

echo "Temp Dir: $tmpdir"

echo "Extracting: $pkgpax"
tar xf "$pkgpax" -C "$tmpdir"

echo "Reading: $pkgbom"
lsbom "$pkgbom" | while read -r line ; do
	# echo "$line"
	path="$(echo "$line" | cut -d$'\t' -f1)"
	mode="$(echo "$line" | cut -d$'\t' -f2)"
	usergroup="$(echo "$line" | cut -d$'\t' -f3)"
	# echo "$path"
	# echo "$mode"
	# echo "$usergroup"
	fpath="$tmpdir/$path"
	user="$(echo "$usergroup" | cut -d$'/' -f1)"
	group="$(echo "$usergroup" | cut -d$'/' -f2)"
	# echo "$fpath"
	# echo "$user"
	# echo "$group"
	chmod -h "$mode" "$fpath"
	chown -h "$user:$group" "$fpath"
done

echo "Installing components:"
declare -a components=(
	'/Library/Application Support/National Instruments'
	'/Library/Frameworks/Fantom.framework'
	'/Library/Frameworks/VISA.framework'
	'/Library/Preferences/NIvisa'
)
for component in "${components[@]}" ; do
	echo "    $component"
	mv "$tmpdir/$component" "$component"
done

echo "Cleaning up"
rm -rf "$tmpdir"

echo "Done"
exit 0
