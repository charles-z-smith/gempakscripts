#!/bin/csh
#Written by Charles Smith 07/05/13
#This script is designed to generate BASIC Metar data for a set of different areas
#Basic Metar data means Temperature(F), Dewpoint(F), Weather, Wind speed(mph) and Sky Cover
#The parameters are set so that it is easy for a client to read with vectors instead of barbs
#gpmap sets a white background instead of black
#
#****WARNING****, The documentation for SFPARM claims the variable PWSP stands for Peak Wind Speed in meters/second
#This is not the case as it is in knots not meters/second.  You can double check the decoded observations to verify this in the link #below....
#ftp://tgftp.nws.noaa.gov/data/observations/metar/decoded/
#

Xvfb :2 -screen 0 1280x1024x24 &
setenv DISPLAY atmo.math.uwm.edu:2.0

set directory = "/atmo/web/surface"
source /opt/gempak/NAWIPS/Gemenviron
set INPUT_LOCATION_LIST = ("GF|$directory/METAR_BASIC_SWIS_01.gif|600;600:GF|$directory/METAR_TEMP_SWIS_01.gif|600;600:GF|$directory/METAR_PEAKWIND_SWIS_01.gif|600;600:GF|$directory/METAR_HEAT_SWIS_01.gif|600;600:GF|$directory/METAR_DEWS_SWIS_01.gif|600;600:GF|$directory/METAR_SUSWIND_SWIS_01.gif|600;600:41.5000;-91.8520;45.2579;-86.3770" "GF|$directory/METAR_BASIC_NWIS_01.gif|600;600:GF|$directory/METAR_TEMP_NWIS_01.gif|600;600:GF|$directory/METAR_PEAKWIND_NWIS_01.gif|600;600:GF|$directory/METAR_HEAT_NWIS_01.gif|600;600:GF|$directory/METAR_DEWS_NWIS_01.gif|600;600:GF|$directory/METAR_SUSWIND_NWIS_01.gif|600;600:44.01;-92.04;47.54;-86.68" "GF|$directory/METAR_BASIC_NIA_01.gif|600;600:GF|$directory/METAR_TEMP_NIA_01.gif|600;600:GF|$directory/METAR_PEAKWIND_NIA_01.gif|600;600:GF|$directory/METAR_HEAT_NIA_01.gif|600;600:GF|$directory/METAR_DEWS_NIA_01.gif|600;600:GF|$directory/METAR_SUSWIND_NIA_01.gif|600;600:41.3655;-98.9128;47.4688;-89.8147" "GF|$directory/METAR_BASIC_SIA_01.gif|600;600:GF|$directory/METAR_TEMP_SIA_01.gif|600;600:GF|$directory/METAR_PEAKWIND_SIA_01.gif|600;600:GF|$directory/METAR_HEAT_SIA_01.gif|600;600:GF|$directory/METAR_DEWS_SIA_01.gif|600;600:GF|$directory/METAR_SUSWIND_SIA_01.gif|600;600:38.4988;-96.8774;43.5984;-89.7143" "GF|$directory/METAR_BASIC_OH_01.gif|600;600:GF|$directory/METAR_TEMP_OH_01.gif|600;600:GF|$directory/METAR_PEAKWIND_OH_01.gif|600;600:GF|$directory/METAR_HEAT_OH_01.gif|600;600:GF|$directory/METAR_DEWS_OH_01.gif|600;600:GF|$directory/METAR_SUSWIND_OH_01.gif|600;600:36.6762;-87.6316;41.8067;-80.5250" "GF|$directory/METAR_BASIC_MIDWEST_01.gif|600;600:GF|$directory/METAR_TEMP_MIDWEST_01.gif|600;600:GF|$directory/METAR_PEAKWIND_MIDWEST_01.gif|600;600:GF|$directory/METAR_HEAT_MIDWEST_01.gif|600;600:GF|$directory/METAR_DEWS_MIDWEST_01.gif|600;600:GF|$directory/METAR_SUSWIND_MIDWEST_01.gif|600;600:38.9297;-97.4267;47.9644;-83.9794")

`cd /atmo/web/surface`
set hour = `date -u +"%H"`00
echo $hour

set utc = `date -u "+%Y-%m-%d %H:%M:00 -0000"`
set localdate = `date "+%m-%d %H:%M %p %Z" -d "$utc"`
set doy = `date -u "+%j"`
echo $localdate

python3 /atmo/web/surface/preProcessSurface.py


#set colors for gempak script depending on day of year
set windTitle = "Summer Gusts(mph) SPI Values"
if($doy <141) then
	set windTitle = "Winter Gusts(mph) SPI Values"
else if($doy > 294) then
	set windTitle = "Winter Gusts(mph) SPI Values"
endif

foreach i ($INPUT_LOCATION_LIST)

	set imBasic = `echo $i | cut -d ":" -f1`
	set imTemp = `echo $i | cut -d ":" -f2`
	set imWind = `echo $i | cut -d ":" -f3`
	set imHeat = `echo $i | cut -d ":" -f4`
	set imDews = `echo $i | cut -d ":" -f5`
	set imsusWind = `echo $i | cut -d ":" -f6`
	set latlon = `echo $i | cut -d ":" -f7`

	set filter=0.5
	if($imBasic == "GF|$directory/METAR_BASIC_MIDWEST_01.gif|600;600") then
		set filter=1.0
	else if($imBasic == "GF|$directory/METAR_BASIC_NIA_01.gif|600;600") then
		set filter=1.0
endif
	set utc = `date -u "+%Y-%m-%d %H:%M:00 -0000"`
	if($imBasic == "GF|METAR_BASIC_OH_01.gif|600;600") then
		set utc = `date -u "+%Y-%m-%d %H:%M:00 -0100"`
endif
	set localDate = `date "+%m-%d %H00%p" -d "$utc"`
	echo $filter
	gpmap <<EOF
	\$mapfil = hicnus.nws + histus.nws
	MAP      = 1/1/1 + 32/1/2
	MSCALE   = 0
	GAREA    = $latlon
	PROJ     = lcc
	SATFIL   =  
	RADFIL   =  
	IMCBAR   =  
	LATLON   = 0
	PANEL    = 0
	TITLE    = 
	TEXT     = 
	CLEAR    = YES
	DEVICE   = $imBasic
	LUTFIL   =  
	STNPLT   =  
	VGFILE   =  
	AFOSFL   =  
	AWPSFL   =  
	LINE     = 3
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
	BND      = bg/31
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
EOF
	#plot station data
	sfmap<<BASIC
	\$mapfil = hicnus.nws + histus.nws
	MAP      = 1/1/1 + 32/1/2
	AREA     = $latlon
	GAREA    = $latlon
	SATFIL   =  
	RADFIL   =  
	IMCBAR   =  
	SFPARM   = skyc;tmpf:1:1;wsym:1:1;arrm:.75:2:211:1;;dwpf:1:1;;;;;;smph:1:1
	DATTIM   = $hour
	SFFILE   = metar
	COLORS   = 26;2;7;4;3;4
	MSCALE   = 0
	LATLON   = 0
	TITLE    = 1//$localDate Temp(F),Dpt(F),Sky Cover,WX,Wind(mph)
	CLEAR    = NO
	PANEL    = 0
	DEVICE   = $imBasic
	PROJ     = lcc
	FILTER   = $filter
	TEXT     = 2;/22//hw
	LUTFIL   =  
	STNPLT   =  
	CLRBAR   =  
	LSTPRM   =
	run

	e
BASIC
	gpend

	gpmap<<BG
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1 + 32/1/2
	BND = bg/31
	DEVICE = $imTemp
	CLEAR = YES
	COLORS =
	TITLE =	
	run

	e
BG
	sfmap<<TEMPERATURE
	\$mapfil =
	CLEAR = NO
	SFFILE = metar
	DATTIM = $hour
	SFPARM = TMPF:1:1
	COLORS = (-6;0;90;93/2;19;4;19;2/TMPF)
	DEVICE = $imTemp
	TITLE = 1//$localDate Temperature(Spi Colored)
	FILTER = $filter
	run
	
	e
TEMPERATURE
	gpend

	gpmap<<BG
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1 + 32/1/2
	BND = bg/31
	DEVICE = $imHeat
	CLEAR = YES
	COLORS =
	TITLE =	
	run
	
	e
BG
	sfmap<<HEAT
	\$mapfil =
	CLEAR = NO
	SFFILE = metar
	DATTIM = $hour
	SFPARM = HEAT:1:1
	COLORS = (-6;0;93;97/2;19;4;19;2/HEAT)
	DEVICE = $imHeat
	TITLE = 1//$localDate Heat Index(Spi Colored)
	FILTER = $filter
	run
	
	e
HEAT
	gpend

	gpmap<<BG
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1 + 32/1/2
	BND = bg/31
	DEVICE = $imWind
	CLEAR= YES
	COLORS =
	TITLE =
	run

	e
BG

	sfmap<<PEAKWIND
	\$mapfil =
	CLEAR = NO
	SFFILE = metar
	DATTIM = $hour
	SFPARM = PWSP*1.15;GUST*1.15
	COLORS = 2;18
	DEVICE = $imWind
	TITLE = 
	FILTER = 0.1
	run
	
	e
PEAKWIND
	gpend

	gpmap<<BG
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1 + 32/1/2
	BND = bg/31
	DEVICE = $imDews
	TITLE =
	FILTER = $filter
	run

	e
BG

	sfmap<<DEWS
	\$mapfil = 
	CLEAR = NO
	SFFILE = metar
	DATTIM = $hour
	SFPARM = DWPF
	COLORS = 4
	DEVICE = $imDews
	TITLE = $hour Dew Points(F)
	FILTER = $filter
	run

	e
DEWS
	gpend

	gpmap<<BG
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1 + 32/1/2
	BND = bg/31
	DEVICE = $imsusWind
	TITLE =
	FILTER = $filter
	run

	e
BG
	sfmap<<SUSWIND
	\$mapfil =
	CLEAR = NO
	SFFILE = metar
	DATTIm = $hour
	SFPARM = ARRM;SMPH
	COLORS = 4;23
	DEVICE = $imsusWind
	TITLE = $hour Wind Speed(mph), Direction
	FILTER = $filter
	run
	
	e
SUSWIND
	gpend

end

python3 /atmo/web/surface/postProcessSurface.py

csh /atmo/web/marine/marineplot.csh

exit
