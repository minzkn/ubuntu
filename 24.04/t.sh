#!/bin/sh


if grep -q '\<fuse\>' "/proc/misc"
then
  if [ ! -e "/dev/fuse" ]; then
    echo "/dev/fuse" c 10 $(grep '\<fuse\>' "/proc/misc" | cut -f 1 -d' ')
  fi
fi

if grep -q '\<kvm\>' "/proc/misc"
then
  if [ ! -e "/dev/kvm" ]; then
    echo "/dev/kvm" c 10 $(grep '\<kvm\>' "/proc/misc" | cut -f 1 -d' ')
  fi
fi
