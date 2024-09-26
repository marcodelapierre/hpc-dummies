CC = gcc
LD = gcc
LDCONFIG = ldconfig
SYMLINK = ln -s
CCFLAGS = -g -Wall

LIB_DIR=$(shell pwd)
LIB_NAME=hi
# these are the correct ones, when also deploying libraries with ldconfig -n <path>
FULL_LIB_NAME=lib$(LIB_NAME).so
SO_NAME=$(FULL_LIB_NAME).1
LIB_FILE=$(SO_NAME).0

CC_FILES_ALL = $(wildcard *.c)
CC_FILES = $(filter-out main.c,$(CC_FILES_ALL))
CC_FILES_BIS = $(wildcard bis/*.c)
OBJ_FILES = $(patsubst %.c, %.o, $(CC_FILES))
OBJ_FILES_BIS = $(patsubst %.c, %.o, $(CC_FILES_BIS))
.SECONDARY: $(OBJ_FILES) $(OBJ_FILES_BIS)


.PHONY: all
all: exes libs

.PHONY: exes
exes: std.x rpath.x ldrunpath.x rpath_bis.x ldrunpath_bis.x rpath_hard.x

.PHONY: libs
libs: $(FULL_LIB_NAME) bis/$(FULL_LIB_NAME)

std.x: main.o $(FULL_LIB_NAME)
	$(LD) -o $@ main.o -L$(LIB_DIR) -l$(LIB_NAME)

rpath.x: main.o $(FULL_LIB_NAME)
	$(LD) -o $@ main.o -L$(LIB_DIR) -Wl,-rpath,$(LIB_DIR) -l$(LIB_NAME)

ldrunpath.x: main.o $(FULL_LIB_NAME)
	LD_RUN_PATH=$(LIB_DIR) $(LD) -o $@ main.o -L$(LIB_DIR) -l$(LIB_NAME)

rpath_bis.x: main.o bis/$(FULL_LIB_NAME)
	$(LD) -o $@ main.o -L$(LIB_DIR)/bis -Wl,-rpath,$(LIB_DIR)/bis -l$(LIB_NAME)

ldrunpath_bis.x: main.o bis/$(FULL_LIB_NAME)
	LD_RUN_PATH=$(LIB_DIR)/bis $(LD) -o $@ main.o -L$(LIB_DIR)/bis -l$(LIB_NAME)

rpath_hard.x: main.o $(FULL_LIB_NAME)
	$(LD) -o $@ main.o -L$(LIB_DIR) -Wl,-rpath,$(LIB_DIR) -Wl,--disable-new-dtags -l$(LIB_NAME)

$(FULL_LIB_NAME): $(LIB_FILE)
	$(LDCONFIG) -n $(LIB_DIR) ; \
	$(SYMLINK) $(LIB_FILE) $(FULL_LIB_NAME)

$(LIB_FILE): $(OBJ_FILES)
	$(CC) -shared -Wl,-soname,$(SO_NAME) -o $@ $^

bis/$(FULL_LIB_NAME): bis/$(LIB_FILE)
	$(LDCONFIG) -n $(LIB_DIR)/bis ; \
	cd bis ; $(SYMLINK) $(LIB_FILE) $(FULL_LIB_NAME) ; cd ..

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

