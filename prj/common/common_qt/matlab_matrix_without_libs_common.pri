#
# File matlab_matrix_without_lib_common.pro
# File created : 19 Apr 2017
# Created by : Davit Kalantaryan (davit.kalantaryan@desy.de)
# This file can be used to produce Makefile for daqadcreceiver application
# for PITZ
#

MATLAB_VERSION = R2016b

include ( $${PWD}/../../common/common_qt/sys_common.pri )

message("!!! matlab_matrix_without_lib_common.pri CODENAME=$$CODENAME")

INCLUDEPATH += $${PWD}/../../../include

message($$MATLAB_VERSION " is used")

QT -= gui
QT -= core
QT -= widgets
CONFIG -= qt
