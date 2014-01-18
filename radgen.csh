#!/bin/csh
#Created 07/26/13
#This script is designed to generate radar images when called
#the Filename will be "latest_site", but will also have the same name as the
#latest file, with respect to time scanned, within the N0Q directory.
#example 2013_03150000 and 2013_03150010, the filename will be 2013_03150010
#remove latest images
#Xvfb :2 -screen 0 1280x1024x24 &
#setenv DISPLAY atmo.math.uwm.edu:2.0

set directory = "/atmo/web/radar"
source /opt/gempak/NAWIPS/Gemenviron
#a string of arguements, which will go into a python script.  These args will be datetime sensitive, so they will always be changing.
set pyArgs =

python3 /atmo/web/radar/preprocessradar.py

set SITES = ("MKX:Milwaukee:#42.97;-88.55;2;2.75" "GRB:GreenBay:#44.48;-88.10;2;2.75" "MQT:Marquette:#46.52;-87.53;2;2.75" "ILN:Wilmington:#39.42;-83.82;2;2.75" "ARX:LaCrosse:#43.82;-91.18;2;2.75" "DMX:DesMoines:#41.72;-93.72;2;2.75" "DLH:Duluth:#46.83;-92.20;2;2.75" "FSD:SiouxFalls:#43.58;-96.72;2;2.75" "DVN:Davenport:#41.60;-90.57;2;2.75" "LOT:Chicago:#41.60;-88.08;2;2.75" "MPX:Minneapolis:#44.83;-93.55;2;2.75" "OAX:Omaha:#41.32;-96.37;2;2.75")


foreach i ($SITES)
	set index = 0
	set radID = `echo $i | cut -d ":" -f1`
	set radName = `echo $i | cut -d ":" -f2`
	set radGarea = `echo $i | cut -d ":" -f3`
	echo $radID
	echo $radName
	echo $radGarea
	set fileNameNOR = `ls /atmo/data/gempak/nexrad/NIDS/$radID/N0R/ | tail -1`
	set radfilNOR = "/atmo/data/gempak/nexrad/NIDS/"$radID"/N0R/"$fileNameNOR
	

	set utcYear = `echo $fileNameNOR | cut -c5-8`
	set utcMonth = `echo $fileNameNOR | cut -c9,10`
	set utcDay = `echo $fileNameNOR | cut -c11,12`
	set utcHour = `echo $fileNameNOR | cut -c14,15`
	set utcMinute = `echo $fileNameNOR | cut -c16,17`
	set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0000"`
	if($radID == "ILN") then
		set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0100"`
endif
	set localdate = `date "+%m-%d %H:%M %p %Z" -d "$utcToCt"`
	set titleNOR = `echo $radName"_Base Reflectivity_"$localdate`
	set deviceNOR = `echo "GIF|"$directory/$radID"_N0R_01.gif|600;600"`
	
	gpmap << ENDGPMAP
	\$mapfil = hicnus.nws + histus.nws
	MAP = 1/1/1+31/1/3
	MSCALE = 0
	GAREA = $radGarea
	PROJ = rad
	RADFIL = $radfilNOR
	SATFIL =
	IMCBAR = 1
	LATLON = 0
	PANEL = 0
	TITLE = 1/-2/$titleNOR
	TEXT = 
	CLEAR = YES
	DEVICE = $deviceNOR
	LUTFIL = nids_n0q256.tbl
	STNPLT = 
	VGFILE =
	AFOSFL =
	AWPSFL =
	LINE = 
	WATCH = 
	WARN = last|2;11;3|NO|NO|YES|YES
	HRCN =
	ISIG =
	LTNG  = 
	ATCF  = 
	AIRM  = 
	GAIRM = 
	NCON  =
	CSIG  = 
	SVRL  = 
	BND   = 
	TCMG  = 
	QSCT  = 
	WSTM  =
	WOU   =
	WCN   = 
	WCP   =
	ENCY  = 
	FFA   = 
	WSAT  =
	ASCT  =
	TRAK1 =
	TRAKE = 
	TRAK2 =
	OSCT  =
	SGWH  = 
	ASDI  =
	run

	exit
ENDGPMAP
	gpend

	set fileNameN1P = `ls /atmo/data/gempak/nexrad/NIDS/$radID/N1P/ | tail -1`
	set radfilN1P = "/atmo/data/gempak/nexrad/NIDS/"$radID"/N1P/"$fileNameN1P

	set utcYear = `echo $fileNameN1P | cut -c5-8`
	set utcMonth = `echo $fileNameN1P | cut -c9,10`
	set utcDay = `echo $fileNameN1P | cut -c11,12`
	set utcHour = `echo $fileNameN1P | cut -c14,15`
	set utcMinute = `echo $fileNameN1P | cut -c16,17`
	set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0000"`
	if($radID == "ILN") then
		set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0100"`
endif
	set localdate = `date "+%m-%d %H:%M %p %Z" -d "$utcToCt"`
	set titleN1P = `echo $radName"_Hourly Precipitation_"$localdate`
	set deviceN1P = `echo "GIF|"$directory/$radID"_N1P_01.gif|600;600"`
	gpmap << ENDGPMAP1
	GAREA = $radGarea
	PROJ = rad
	RADFIL = $radfilN1P
	TITLE = 1/-2/$titleN1P
	DEVICE = $deviceN1P
	LUTFIL = default
	WARN = 
	run

	exit
ENDGPMAP1
	gpend

	set fileNameNTP = `ls /atmo/data/gempak/nexrad/NIDS/$radID/NTP/ | tail -1`	
	set radfilNTP = "/atmo/data/gempak/nexrad/NIDS/"$radID"/NTP/"$fileNameNTP

	set utcYear = `echo $fileNameNTP | cut -c5-8`
	set utcMonth = `echo $fileNameNTP | cut -c9,10`
	set utcDay = `echo $fileNameNTP | cut -c11,12`
	set utcHour = `echo $fileNameNTP | cut -c14,15`
	set utcMinute = `echo $fileNameNTP | cut -c16,17`
	set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0000"`
	if($radID == "ILN") then
		set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0100"`
endif
	set localdate = `date "+%m-%d %H:%M %p %Z" -d "$utcToCt"`
	set titleNTP = `echo $radName"_Total Precipitation_"$localdate`
	set deviceNTP = `echo "GIF|"$directory/$radID"_NTP_01.gif|600;600"`
	
	gpmap <<ENDGPMAP2
	GAREA = $radGarea
	PROJ = rad
	RADFIL = $radfilNTP
	TITLE = 1/-2/$titleNTP
	DEVICE = $deviceNTP
	LUTFIL = default
	WARN = 
	run

	exit
ENDGPMAP2
	gpend

	set fileNameN0Q = `ls /atmo/data/gempak/nexrad/NIDS/$radID/N0Q/ | tail -1`	
	set radfilN0Q = "/atmo/data/gempak/nexrad/NIDS/"$radID"/N0Q/"$fileNameN0Q

	set utcYear = `echo $fileNameN0Q | cut -c5-8`
	set utcMonth = `echo $fileNameN0Q | cut -c9,10`
	set utcDay = `echo $fileNameN0Q | cut -c11,12`
	set utcHour = `echo $fileNameN0Q | cut -c14,15`
	set utcMinute = `echo $fileNameN0Q | cut -c16,17`
	set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0000"`
	if($radID == "ILN") then
		set utcToCt = `echo $utcYear-$utcMonth-$utcDay $utcHour":"$utcMinute":00 -0100"`
endif
	set localdate = `date "+%m-%d %H:%M %p %Z" -d "$utcToCt"`
	set titleN0Q = `echo $radName"_Base Reflectivity _"$localdate`
	set deviceN0Q = `echo "GIF|"$directory/$radID"_N0Q_01.gif|600;600"`
	set radN0Qdset = `echo $radID`
	echo $radN0Qdset
	
	gpmap <<ENDGPMAP3
	GAREA = $radGarea
	PROJ = rad
	RADFIL = $radfilN0Q
	TITLE = 1/-2/$titleN0Q
	DEVICE = $deviceN0Q
	WARN = 
	LUTFIL = nids_n0q256.tbl
	run

	exit
ENDGPMAP3
	gpend
#append to an array
	set siteArgs = ($radID"_"$fileNameN0Q $radID"_"$fileNameNOR $radID"_"$fileNameN1P $radID"_"$fileNameNTP)
	while ($index <5)
		set pyArgs = ($pyArgs $siteArgs[$index] )
		@ index ++
	end
	echo $pyArgs
	
end

#rm /atmo/web/radar/animatemkx.gif

python3 /atmo/web/radar/postprocessradar.py $pyArgs


exit
