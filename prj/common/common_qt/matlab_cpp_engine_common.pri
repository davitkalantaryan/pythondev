#
# File matlab_matrix_common.pro
# File created : 19 Apr 2017
# Created by : Davit Kalantaryan (davit.kalantaryan@desy.de)
# This file can be used to produce Makefile for daqadcreceiver application
# for PITZ
#

MATLAB_VERSION = R2017b

include($${PWD}/../../common/common_qt/sys_common.pri)
message("!!! matlab_matrix_common.pri CODENAME=$$CODENAME")

#TEMPLATE = app
#TARGET = .

MATLAB_ROOT=/afs/ifh.de/SL/6/x86_64/opt/matlab/R2017b


LIBS += -L$${MATLAB_ROOT}/extern/bin/glnxa64
INCLUDEPATH += $${MATLAB_ROOT}/extern/include

message("R2017b is used")

LIBS += -lMatlabEngine
LIBS += -lMatlabDataArray


QT -= core
QT -= gui

OTHER_FILES += \
    $${PWD}/../../../scripts/create_new_system.sh
