#!/bin/bash

mapfile -d $'\0' array < <(find . -name "*.s" -print0)
ignore=(match)

instructions=(aesd
aese
aesimc
aesmc
bdep
bext
bfmmla
bgrp
fadda
fexpa
fmmla
ftmad
ftsmul
ftssel
histcnt
histseg
"ld1d\t\{ z[0-9][0-9].d \}, p\d\/z, \[x\d\d, z"
"ld1d\t\{ z[0-9][0-9].d \}, p\d\/z, \[x\d, z"
"ld1d\t\{ z[0-9]\.d \}, p\d\/z, \[x\d\d, z"
"ld1d\t\{ z[0-9]\.d \}, p\d\/z, \[x\d, z"
"ld1d\t\{ z[0-9]\.d \}, p\d\/z, \[x\d, \#"
"ld1d\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[x\d, \#"
"ld1d\t\{ z[0-9]\.d \}, p\d\/z, \[x\d\d, \#"
"ld1d\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[x\d\d, \#"
"ld1d\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[z"
"ld1d\t\{ z[0-9]\.d \}, p\d\/z, \[z"
"ld1b\t\{ z[0-9][0-9].d \}, p\d\/z, \[x\d\d, z"
"ld1b\t\{ z[0-9][0-9].d \}, p\d\/z, \[x\d, z"
"ld1b\t\{ z[0-9]\.d \}, p\d\/z, \[x\d\d, z"
"ld1b\t\{ z[0-9]\.d \}, p\d\/z, \[x\d, z"
"ld1b\t\{ z[0-9]\.d \}, p\d\/z, \[x\d, \#"
"ld1b\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[x\d, \#"
"ld1b\t\{ z[0-9]\.d \}, p\d\/z, \[x\d\d, \#"
"ld1b\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[x\d\d, \#"
"ld1b\t\{ z[0-9][0-9]\.d \}, p\d\/z, \[z"
"ld1b\t\{ z[0-9]\.d \}, p\d\/z, \[z"
ld1h
ld1rob
ld1rod
ld1roh
ld1row
ld1sb
ld1sh
ld1sw
ld1w
ldff1b
ldff1d
ldff1h
ldff1sb
ldff1sh
ldff1sw
ldff1w
ldnf1b
ldnf1d
ldnf1h
ldnf1sb
ldnf1sh
ldnf1sw
ldnf1w
ldnt1b
ldnt1d
ldnt1h
ldnt1sb
ldnt1sh
ldnt1sw
ldnt1w
nmatch
pmullb
pmullt
prfb
prfd
prfh
prfw
rax1
rdffr
setffr
sm4e
sm4ekey
smmla
"st1d\t\{ z[0-9][0-9].d \}, p\d, \[x\d\d, z"
"st1d\t\{ z[0-9][0-9].d \}, p\d, \[x\d, z"
"st1d\t\{ z[0-9]\.d \}, p\d, \[x\d\d, z"
"st1d\t\{ z[0-9]\.d \}, p\d, \[x\d, z"
"st1d\t\{ z[0-9]\.d \}, p\d, \[x\d, \#"
"st1d\t\{ z[0-9][0-9]\.d \}, p\d, \[x\d, \#"
"st1d\t\{ z[0-9]\.d \}, p\d, \[x\d\d, \#"
"st1d\t\{ z[0-9][0-9]\.d \}, p\d, \[x\d\d, \#"
"st1d\t\{ z[0-9]\.d \}, p\d, \[z"
"st1d\t\{ z[0-9][0-9]\.d \}, p\d, \[z"
"st1b\t\{ z[0-9][0-9].d \}, p\d, \[x\d\d, z"
"st1b\t\{ z[0-9][0-9].d \}, p\d, \[x\d, z"
"st1b\t\{ z[0-9]\.d \}, p\d, \[x\d\d, z"
"st1b\t\{ z[0-9]\.d \}, p\d, \[x\d, z"
"st1b\t\{ z[0-9]\.d \}, p\d, \[x\d, \#"
"st1b\t\{ z[0-9][0-9]\.d \}, p\d, \[x\d, \#"
"st1b\t\{ z[0-9]\.d \}, p\d, \[x\d\d, \#"
"st1b\t\{ z[0-9][0-9]\.d \}, p\d, \[x\d\d, \#"
"st1b\t\{ z[0-9]\.d \}, p\d, \[z"
"st1b\t\{ z[0-9][0-9]\.d \}, p\d, \[z"
st1h
st1w
stnt1b
stnt1d
stnt1w
ummla
usmmla
wrffr)

for src in "${array[@]}"
do
echo ""
echo "###################################################"
echo "finding illegal instructions in ${src}:"
echo "###################################################"

    for ins in "${instructions[@]}"
    do 
    grep -n -P -C1 "${ins}" "${src}"
    done
done

