CC = gcc
LD = gcc
CCFLAGS = -g -Wall

LIB_DIR=$(shell pwd)
LIB_NAME=hi
SO_NAME=lib$(LIB_NAME).so
LIB_FILE=$(SO_NAME)
# these are the correct ones, when also deploying libraries with ldconfig -n <path>
#SO_NAME=lib$(LIB_NAME).so.1
#LIB_FILE=$(SO_NAME).0

CC_FILES_ALL = $(wildcard *.c)
CC_FILES = $(filter-out main.c,$(CC_FILES_ALL))
CC_FILES_BIS = $(wildcard bis/*.c)
OBJ_FILES = $(patsubst %.c, %.o, $(CC_FILES))
OBJ_FILES_BIS = $(patsubst %.c, %.o, $(CC_FILES_BIS))
.SECONDARY: $(OBJ_FILES) $(OBJ_FILES_BIS)


.PHONY: all
all: exes libs

.PHONY: exes
exes: std.x rpath.x ldrunpath.x

.PHONY: libs
libs: $(LIB_FILE) bis/$(LIB_FILE)

std.x: main.o $(LIB_FILE)
	$(LD) -o $@ main.o -L$(LIB_DIR) -l$(LIB_NAME)

rpath.x: main.o $(LIB_FILE)
	$(LD) -o $@ main.o -L$(LIB_DIR) -Wl,-rpath,$(LIB_DIR) -l$(LIB_NAME)

ldrunpath.x: main.o $(LIB_FILE)
	LD_RUN_PATH=$(LIB_DIR) $(LD) -o $@ main.o -L$(LIB_DIR) -l$(LIB_NAME)

$(LIB_FILE): $(OBJ_FILES)
	$(CC) -shared -Wl,-soname,$(SO_NAME) -o $@ $^

bis/$(LIB_FILE): $(OBJ_FILES_BIS)
	$(CC) -shared -Wl,-soname,$(SO_NAME) -o $@ $^

main.o: main.c
	$(CC) $(CCFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CCFLAGS) -fPIC -c $< -o $@


.PHONY: clean_obj
clean_obj:
	rm -f *.o bis/*.o

.PHONY: clean
clean:
	rm -f *.x *.so *.so.* bis/*.so bis/*.so.* *.o bis/*.o

