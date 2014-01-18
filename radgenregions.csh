#!/bin/csh
#Written by Charles Smith 06/25/13
#This script will create regional radar mosaics based off the specified latitude and logitude cordinates which are specified
# in the nex2gini section.  From there it will under go post processing which involves inserting the lake and perhaps some #other stuff.

Xvfb :2 -screen 0 1280x1024x24 &
setenv DISPLAY atmo.math.uwm.edu:2.0

python3 /atmo/web/radar/preprocessradarRegional.py

source /opt/gempak/NAWIPS/Gemenviron

set fileNameComposite=rad_`date -u +'%Y%m%d_%H%M'`
echo $fileNameComposite
#remove latest Image
rm /atmo/web/radar/WI_latest_N0R.gif
rm /atmo/web/radar/NIA_latest_N0R.gif
rm /atmo/web/radar/SIA_latest_N0R.gif
rm /atmo/web/radar/OH_latest_N0R.gif
rm /atmo/web/radar/MIDWEST_latest_N0R.gif
rm /atmo/web/radar/wigrid.gem
rm /atmo/web/radar/niagrid.gem
rm /atmo/web/radar/siagrid.gem
rm /atmo/web/radar/ohgrid.gem
rm /atmo/web/radar/spigrid.gem


nex2gini <<ENDNEX2GINI
GRDAREA = 42.0;-93.25;47.00;-86.00
PROJ = mer
KXKY = 3750;3750
GFUNC = n0r
RADTIM = current
RADMODE = PC
RADDUR = 15
RADFRQ = 0
SATFIL = /atmo/web/radar/wigrid.gem
run
exit
ENDNEX2GINI

nex2gini <<EOF
KXKY = 3750;3750
GRDAREA = 41.3655;-98.6628;47.4688;-90.0647
SATFIL = /atmo/web/radar/niagrid.gem
run
exit
EOF

nex2gini <<EOF
KXKY = 3750;3750
GRDAREA = 38.4988;-96.8774;43.5984;-89.7143
SATFIL = /atmo/web/radar/siagrid.gem
run
exit
EOF

nex2gini <<EOF
KXKY = 3750;3750
GRDAREA = 36.6762;-87.4816;41.8067;-80.6750
SATFIL = /atmo/web/radar/ohgrid.gem
run
exit
EOF

nex2gini <<EOF
KXKY = 3750;3750
GRDAREA = 38.9297;-97.4267;47.9644;-83.9794
SATFIL = /atmo/web/radar/spigrid.gem
run
exit
EOF


echo $fileNameComposite
gpmap <<EOF
\$mapfil = loisus.nws + hicnus.nws +histus.nws
MAP = 2/1/1 + 11/1/1 + 1/1/2 
MSCALE = 0
GAREA = dset
PROJ = sat
SATFIL = /atmo/web/radar/wigrid.gem
IMCBAR = 1/V/LL/0.05;0.04/0.725;0.01/-1
PANEL = 0
LATLON = 0
TITLE = 1/-2
TEXT = 1
CLEAR = YES
WARN = last|2;11;3|NO|NO|YES|YES
DEVICE = GF|/atmo/web/radar/WI_latest_N0R.gif|600;600
LUTFIL = upc_rad24.tbl
LINE = 3
BND =
run

exit
EOF
gpend

gpmap<<EOF
GAREA = dset
PROJ = sat
SATFIL = /atmo/web/radar/niagrid.gem
DEVICE = GF|/atmo/web/radar/NIA_latest_N0R.gif|600;600
LUTFIL = upc_rad24.tbl
run

exit
EOF
gpend

gpmap<<EOF
GAREA = dset
PROJ = sat
SATFIL = /atmo/web/radar/siagrid.gem
DEVICE = GF|/atmo/web/radar/SIA_latest_N0R.gif|600;600
LUTFIL = upc_rad24.tbl
run

exit
EOF
gpend

gpmap<<EOF
GAREA = dset
PROJ = sat
SATFIL = /atmo/web/radar/ohgrid.gem
DEVICE = GF|/atmo/web/radar/OH_latest_N0R.gif|600;600
LUTFIL = upc_rad24.tbl
run

exit
EOF
gpend

gpmap<<EOF
GAREA = dset
PROJ = sat
SATFIL = /atmo/web/radar/spigrid.gem
DEVICE = GF|/atmo/web/radar/MIDWEST_latest_N0R.gif|600;600
LUTFIL = upc_rad24.tbl
run

exit
EOF
gpend
#copy latest image to a utc format
#rm $fileNameComposite
cp /atmo/web/radar/WI_latest_N0R.gif /atmo/web/radar/WI_N0R_01.gif
cp /atmo/web/radar/NIA_latest_N0R.gif /atmo/web/radar/NIA_N0R_01.gif
cp /atmo/web/radar/SIA_latest_N0R.gif /atmo/web/radar/SIA_N0R_01.gif
cp /atmo/web/radar/OH_latest_N0R.gif /atmo/web/radar/OH_N0R_01.gif
cp /atmo/web/radar/MIDWEST_latest_N0R.gif /atmo/web/radar/MIDWEST_N0R_01.gif

rm /atmo/web/radar/animatewi.gif
rm /atmo/web/radar/animatemidwest.gif

python3 /atmo/web/radar/postprocessradarRegional.py

exit

