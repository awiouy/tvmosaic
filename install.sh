#!/bin/sh

TVM_ROOT_DIR="/storage/tvmosaic"
TVM_SHARED_PATH="/storage/tvmosaic.data"

#stop tvmosaic server if it is already running
if [ -f $TVM_ROOT_DIR/stop.sh ]; then
	echo "Stopping tvmosaic server"
	$TVM_ROOT_DIR/stop.sh
fi

#copy new files to the destination

mkdir -p $TVM_ROOT_DIR

echo "copying tvmosaic files"
cp -raf ./tvmosaic/* $TVM_ROOT_DIR/


if [ -f $TVM_ROOT_DIR/tvmosaic_configuration.xml ]; then
	#update
	$TVM_ROOT_DIR/reg.sh -reginstall "${TVM_ROOT_DIR}/data/common/product_info/tvmosaic.xml" update
else
	#new install
	$TVM_ROOT_DIR/reg.sh -preparenewinstall "${TVM_ROOT_DIR}" "${TVM_ROOT_DIR}/data" "${TVM_SHARED_PATH}"
	$TVM_ROOT_DIR/reg.sh -reginstall "${TVM_ROOT_DIR}/data/common/product_info/tvmosaic.xml" install
fi

echo "creating/updating tvmosaic data directory"

mkdir -p -m a=rwx ${TVM_SHARED_PATH}

mkdir -p -m a=rwx ${TVM_SHARED_PATH}/RecordedTV

mkdir -p -m a=rwx ${TVM_SHARED_PATH}/channel_logo

mkdir -p -m a=rwx ${TVM_SHARED_PATH}/xmltv

#copy shared.inst to share and delete it afterwards
cp -rf ${TVM_ROOT_DIR}/shared.inst/* $TVM_SHARED_PATH/
rm -rf ${TVM_ROOT_DIR}/shared.inst

#add tvmosaic to the start-up script
AUTOSTART_FILE="/storage/.config/autostart.sh"
#check if autostart file exists
if [ ! -f $AUTOSTART_FILE ]; then
	echo "#!/bin/sh" > $AUTOSTART_FILE
	chmod +x $AUTOSTART_FILE
fi

#check if tvmosaic server start-up is already there

grep -q tvmosaic $AUTOSTART_FILE
RET=$?

if [ ${RET} -eq 1 ]; then
	echo "updating autostart.sh file"
	echo "/storage/tvmosaic/start2.sh" >> $AUTOSTART_FILE
fi

#start tvmosaic server
echo "starting tvmosaic server..."
${TVM_ROOT_DIR}/start2.sh


