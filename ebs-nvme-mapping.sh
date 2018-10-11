#!/bin/bash

PATH="${PATH}:/usr/sbin"

for blkdev in $( nvme list | awk '/^\/dev/ { print $1 }' ) ; do
  mapping='/dev/'"$(nvme id-ctrl --raw-binary "${blkdev}" | cut -c3073-3104 | sed 's/\s*$//')"
  if [[ "${mapping}" == "/dev/sda1" ]]; then
    ( test -b "${blkdev}p1" && test -L "${mapping}" ) || ln -s "${blkdev}p1" "${mapping}"
  elif [[ "${mapping}" == /dev/* ]]; then
    ( test -b "${blkdev}" && test -L "${mapping}" ) || ln -s "${blkdev}" "${mapping}"
  fi
done
