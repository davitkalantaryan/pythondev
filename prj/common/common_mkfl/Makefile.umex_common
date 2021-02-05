
TARGET_EXTENSION	:=  mexa64
LSB_RELEASE			:=  $(shell lsb_release -c | cut -f 2)
include_mkfile_path	:=  $(abspath $(lastword $(MAKEFILE_LIST)))
include_mkfile_dir	:=  $(shell dirname $(include_mkfile_path))
TARGET_DIR			=   $(include_mkfile_dir)/../../../sys/$(LSB_RELEASE)/mbin
#PROJECT_NAME		=   dummy # define this in final project
TARGET_NAME			=   $(PROJECT_NAME)
OUTPUT_NAME			=   $(TARGET_NAME).$(TARGET_EXTENSION)
TARGET_FILE_PATH	=   $(TARGET_DIR)/$(OUTPUT_NAME)
CC					=   gcc
CPP					=   g++
LINK				=   g++
LFLAGS				+=  -Wl,-E -pie -shared
TARGET_DIR			=   $(include_mkfile_dir)/../../../sys/$(LSB_RELEASE)/mbin
OBJECT_FILES_DIR	=   $(include_mkfile_dir)/../../../sys/$(LSB_RELEASE)/.objects/$(PROJECT_NAME)
CPPPARAMS			+=  -I$(include_mkfile_dir)/../../../include -fPIC

$(OBJECT_FILES_DIR)/%.o: $(SOURCES_BASE_DIR)/%.cpp
	mkdir -p $(@D)
	$(CPP) $(CPPPARAMS) -o $@ -c $<

$(OBJECT_FILES_DIR)/%.o: $(SOURCES_BASE_DIR)/%.cc
	mkdir -p $(@D)
	$(CPP) $(CPPPARAMS) -o $@ -c $<

$(OBJECT_FILES_DIR)/%.o: $(SOURCES_BASE_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CPPPARAMS) -o $@ -c $<
