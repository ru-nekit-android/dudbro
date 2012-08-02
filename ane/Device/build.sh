# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# native project folder
NATIVE_FOLDER=jar

# native project folder
NATIVE_A_FOLDER=a

# AS lib folder
LIB_FOLDER=aslib

# app folder
APP_PROJECT=app

# name of ANE file
ANE_NAME=ane/device.ane

SWC_NAME=DeviceLib.swc

# JAR filename
JAR_NAME=device.jar

# a lib filename
A_NAME=libiOSDevice.a

#===================================================================

echo "****** preparing ANE package sources *******"

rm ${ANE_NAME}
#rm -rf ./build/ane
mkdir -p ./ane
mkdir -p ./build/ane
mkdir -p ./build/ane/Android-ARM
#mkdir -p ./build/ane/Android-ARM/res
mkdir -p ./build/ane/iPhone-ARM

mkdir -p ./build/ane/default

# copy resources
#cp -R ./${NATIVE_FOLDER}/res/* ./build/ane/Android-ARM/res
#rm -d ./build/ane/iPhone-ARM/Resources

# create the JAR file
#jar cf ./build/ane/Android-ARM/${JAR_NAME} -C ./${NATIVE_FOLDER}/bin .
cp -R ./${NATIVE_A_FOLDER}/${A_NAME} ./build/ane/iPhone-ARM/${A_NAME}

# grab the extension descriptor and SWC library 
cp ./${LIB_FOLDER}/src/extension.xml ./build/ane/
cp ./${LIB_FOLDER}/bin/${SWC_NAME} ./build/ane/
unzip ./build/ane/${SWC_NAME} -d ./build/ane
cp ./build/ane/library.swf ./build/ane/Android-ARM
cp ./build/ane/library.swf ./build/ane/iPhone-ARM
cp ./build/ane/library.swf ./build/ane/default

echo "****** creating ANE package *******"

"$ADT" 	-package -storetype PKCS12 -keystore ./p12.p12 -storepass soad7623 -tsa none -target ane ${ANE_NAME} ./build/ane/extension.xml -swc ./build/ane/${SWC_NAME}\
 	-platform Android-ARM -C ./build/ane/Android-ARM/ .\
	-platform iPhone-ARM -C ./build/ane/iPhone-ARM/ .\
 	-platform default -C ./build/ane/default/ .
	

echo "****** ANE package created*******"