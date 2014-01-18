#!/bin/csh
#Written by Charles Smith
#updated 7-16-13
#updated 7-17-13 expanded number of images along with the regions they represent

Xvfb :2 -screen 0 1280x1024x24 &
setenv DISPLAY atmo.math.uwm.edu:2.0

source /opt/gempak/NAWIPS/Gemenviron

`rm /atmo/web/satellite/SUPERNATIONAL_LI_latest.gif`

set fileNameSat = `ls /atmo/data/gempak/images/sat/EAST-CONUS/1km/VIS/ | tail -1`
set fileNameSUPA = `ls /atmo/data/gempak/images/sat/SUPER-NATIONAL/1km/LI/ | tail -1`
set fileNameIR = `ls $SAT/EAST-CONUS/4km/IR/ | tail -1`
set fileLocationSAT = `echo $SAT/EAST-CONUS/1km/VIS/$fileNameSat`
set fileLocationSUPA = `echo $SAT/SUPER-NATIONAL/1km/LI/$fileNameSUPA`
set fileLocationIR = `echo $SAT/EAST-CONUS/4km/IR/$fileNameIR`

set utcYear = `echo $fileNameSat | cut -c5-8`
set utcMonth = `echo $fileNameSat | cut -c9,10`
set utcDay = `echo $fileNameSat | cut -c11,12`
set utcHour = `echo $fileNameSat | cut -c14,15`
set utcMinute = `echo $fileNameSat | cut -c16,17`
set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0000"`
set localDate = `date "+%m-%d %H:%M %p %Z" -d "$utcToCt"`
set directory = "/atmo/web/satellite/"
set INPUT_LOCATION_LIST = ("GF|$directory/SAT_VIS_WI_01.gif|600;600:GF|$directory/SAT_IRE_WI_01.gif|600;600" "GF|$directory/SAT_VIS_OH_01.gif|600;600:GF|$directory/SAT_IRE_OH_01.gif|600;600" "GF|$directory/SAT_VIS_NIA_01.gif|600;600:GF|$directory/SAT_IRE_NIA_01.gif|600;600" "GF|$directory/SAT_VIS_SIA_01.gif|600;600:GF|$directory/SAT_IRE_SIA_01.gif|600;600" "GF|$directory/SAT_VIS_OH_01.gif|600;600:GF|$directory/SAT_IRE_OH_01.gif")
#For Wisconsin

gpmap <<WIVIS
\$mapfil =  histus.nws + hicnus.nws
MAP = 32/1/2 + 11/1/1
MSCALE = 0
GAREA = 42.0;-93.25;47.00;-86.00
SATFIL = $fileLocationSAT
RADFIL = 
LATLON = 0
PANEL = 0
TEXT = 1/11/SW
TITLE = 1/-1/$localDate Visible Satellite
CLEAR = YES
PROJ = sat
DEVICE   = GF|/atmo/web/satellite/SAT_VIS_WI_01.gif|600;600
IMCBAR   =
LUTFIL   = default
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
BND      =
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
OSCT     =  
SGWH     =  
ASDI     =
run

e
WIVIS
gpend

gpmap<<WIIR
SATFIL = $fileLocationIR
TITLE = 1//$localDate IR Enhanced
DEVICE = GF|/atmo/web/satellite/SAT_IRE_WI_01.gif|600;600
LUTFIL = ir_upc3.tbl
run

e
WIIR
gpend

set utcToEst = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0100"`
set estDate = `date "+%m-%d %H:%M %p %Z" -d "$utcToEst"`

#For Ohio
gpmap <<OHVIS
GAREA = 36.6762;-87.4816;41.8067;-80.6750
SATFIL = $fileLocationSAT
TEXT = 1/11/SW
TITLE = 1/-1/$estDate Ohio Vis Satellite
CLEAR = YES
PROJ = sat
DEVICE = GF|/atmo/web/satellite/SAT_VIS_OH_01.gif|600;600
IMCBAR   =
LUTFIL = default
run

e
OHVIS
gpend

gpmap<<OHIR
SATFIL = $fileLocationIR
TITLE = 1//$estDate Ohio IR Enhanced
DEVICE = GF|/atmo/web/satellite/SAT_IRE_OH_01.gif|600;600
LUTFIL = ir_upc3.tbl
run

e
OHIR

gpend

#For Midwest
gpmap <<VISMIDWEST
\$mapfil =  histus.nws
MAP = 31/1/2
GAREA = 39.56;-98.00;48.50;-83.70
SATFIL = $fileLocationSAT
TEXT = 1/11/SW
TITLE = 1/-1/$localDate MidWest Vis Satellite
CLEAR = YES
PROJ = sat
DEVICE = GF|/atmo/web/satellite/SAT_VIS_MIDWEST_01.gif|600;600
IMCBAR =
LUTFIL =default
run

e
VISMIDWEST
gpend

gpmap <<IRMIDWEST
SATFIL = $fileLocationIR
DEVICE = GF|/atmo/web/satellite/SAT_IRE_MIDWEST_01.gif|600;600
TITLE = 1//$localDate Midwest IR Enhanced
LUTFIL = ir_upc3.tbl
run

e
IRMIDWEST
gpend

gpmap<<SUPA
GAREA = 41.5000;-92.0520;45.2579;-86.1770
SATFIL = $fileLocationSUPA
PROJ = sat
TITLE = 1/-1/SUPA NATIONAL
DEVICE = GF|/atmo/web/satellite/SUPERNATIONAL_LI_latest.gif|600;600
TEXT = 1/11/SW
LUTFIL = ctp_upc_b.tbl
run

e
SUPA
gpend


exit
