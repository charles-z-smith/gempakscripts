#!/bin/csh
#########################################################################################################
#Written by Charles Smith
#Created 02/14/14(my type of Valentine's day) :]
#########################################################################################################
#This script generates a hi res radar image based on the national cordinates in the gentopo script.
#It should fit the basemap we greated in the genTopo script.
#Again,  KXKY cannot be chosen randomly as it will mess with the radar projection.
#we used the n0r data, but plotted it with the n0q color table as it looks sligtly better in my opinion.
#########################################################################################################
source /opt/gempak/NAWIPS/Gemenviron

nex2gini << EOF
	PROJ = mer
	GRDAREA = 25;-128;50;-65
	KXKY = 3920;2000
	CPYFIL = 
	GFUNC = n0r
	RADTIM = current
	RADDUR = 15
	RADFRQ = 0
	STNFIL = nexrad.tbl
	RADMODE = PC
	SATFIL = testout.gem
	
	r
EOF
gpmap << EOF
	\$mapfil = hicnus.nws + histus.nws
	MAP      = 1/1/2 + 200:200:200/1/1
	MSCALE   = 0
	GAREA    = 25;-128;50;-65
	PROJ     = sat
	SATFIL   = testout.gem
	RADFIL   = 
	IMCBAR   = 1
	LATLON   =  
	PANEL    = 0
	TITLE    = 1/-2
	TEXT     = 1/2//hw
	CLEAR    = y
	DEVICE   = GIF|national.gif|3800;2000
	LUTFIL   = nids_n0q256.tbl
	STNPLT   =  
	VGFILE   =  
	AFOSFL   =  
	AWPSFL   =  
	LINE     =  
	WATCH    =  
	WARN     =  
	HRCN     =  
	ISIG     =  
	LTNG     =  
	ATCF     =  
	AIRM     =  
	GAIRM    =  
	NCON     =  
	CSIG     =  
	SVRL     =  
	TCMG     =  
	QSCT     =  
	WSTM     =  
	WOU      =  
	WCN      =  
	WCP      =  
	ENCY     =  
	FFA      =  
	WSAT     =  
	ASCT     =  
	TRAK1    =  
	TRAKE    =  
	TRAK2    =  
	r
	

EOF
#radar image now generated
gpend

#makes the black background transparent
convert national.gif -transparent black trashout.gif
#overlay the transparent data onto the radar image.
composite trashout.gif nam_basemap.gif final.gif

exit
