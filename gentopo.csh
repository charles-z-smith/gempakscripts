#!/bin/csh
#########################################################################################################
#Written by Charles Smith
#Created 02/14/14(my type of Valentine's day) :]
#########################################################################################################
#This Script can generate a base map gif and gini file.  
#It Correctly builds a mercator topographic projection based off the specified area.
#KXKY cannot be chosen randomly as it seems to be fixed based off the specified garea.  
#If we used the garea from http://www.unidata.ucar.edu/software/gempak/tutorial/radar_programs.html#13.1.
#The topographic background would not match states.  This in fact can be seen on the radar image within the link.
#Notice the Miami radar site is in the Gulf of Mexico and the Albany site is in Canada.  This is obviously incorrect.
#However most sites near the center of the project seem properly placed.
#So again KXKY seems to be fixed to the specified projection.
#You can also overlay a radar image of the exact same projection using imageMagik.
#Also requires the 30s world topographic file world_topo.30s.
##########################################################################################################

source /opt/gempak/NAWIPS/Gemenviron

#Removes old files,  if we keep these, it will screw up our data.
rm nam_basemap.gem
rm nam_basemap.gini


#build the topo basemap....
gdtopo << EOF
	GDFILE   = nam_basemap.gem
	GAREA    = 25;-128;50;-65
	GDATTIM  = 070101/0000
	GVCORD   = none
	GFUNC    = topo
	TOPOFL   = world_topo.30s
	IJSKIP   = 0
	
	r

EOF

gd2img << EOF
	GDATTIM  = last
	GDFILE   = nam_basemap.gem
	GLEVEL   = 0
	GVCORD   = none
	GFUNC    = topo
	SCALE    = 0
	PROJ     = mer
	GRDAREA  = 25;-128;50;-65
	KXKY     = 3920;2000
	CPYFIL   =  
	SATFIL   = nam_basemap.gini
	CALINFO  = 99/3/TOPO,0,7,-8103,0;8,95,0,4700
	WMOHDR   = TICZ99/UPC/

	r
EOF

#We can put states and counties on the basemap if we want
gpmap << EOF
	\$mapfil =
	MAP = 0
	DEVICE = GIF|national_basemap.gif|3800;2000
	GAREA = 25;-128;50;-65
	PROJ = sat
	SATFIL = nam_basemap.gini
	TITLE = 
	LUTFIL = 
	CLEAR = YES
	IMCBAR = 0
	BND = lakes/24
	r
EOF

gpend


exit
