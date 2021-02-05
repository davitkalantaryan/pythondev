#
# File mex_common.pri
# File created : 19 Apr 2017
# Created by : Davit Kalantaryan (davit.kalantaryan@desy.de)
# This file can be used to produce Makefile for daqadcreceiver application
# for PITZ
#


include($${PWD}/sys_common.pri)

win32{

    TEMPLATE = lib

    contains(QMAKE_TARGET.arch, x86_64) {
        message("x86_64 build")
        ## Windows x64 (64bit) specific build here

        TARGET_EXT = mexw64
        QMAKE_EXTENSION_SHLIB = mexw64

    } else {
        message("x86 build")
        ## Windows x86 (32bit) specific build here
	TARGET_EXT = mexw32
	QMAKE_EXTENSION_SHLIB = mexw32
    }

} else {
	QMAKE_LFLAGS = -Wl,-E -pie -shared
	TARGET_EXT = mexa64
	QMAKE_EXTENSION_SHLIB = mexa64
	#TARGET = $${TARGET}.mexa64
	GCCPATH = $$system(which gcc)
	message("!!!!!!!!!!! GCCPATH=$$GCCPATH")
	# QMAKE_CXXFLAGS += -std=c++14 # in the case of DOOCS
	#TARGET_NAME = $$TARGET_NAME.mexa64
	TARGET = $${TARGET}.mexa64
}

message("!!!  CODENAME=$$CODENAME")

DESTDIR = $${PRJ_PWD}/$${SYSTEM_PATH}/mbin

INCLUDEPATH += $${PWD}/../../../include


QT -= gui
QT -= core
QT -= widgets
CONFIG -= qt
