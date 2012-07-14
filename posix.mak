# build mode: 32bit or 64bit
ifeq (,$(MODEL))
	MODEL := 32
endif

ifeq (,$(DMD))
	DMD := dmd
endif

LIB    = libmustache.a
DFLAGS = -Isrc -m$(MODEL) -w -d -property

ifeq ($(BUILD),debug)
	DFLAGS += -g -debug
else
	DFLAGS += -O -release -nofloat -inline
endif

NAMES = mustache
FILES = $(addsuffix .d, $(NAMES))
SRCS  = $(addprefix src/, $(FILES))

# DDoc
DOCS      = $(addsuffix .html, $(NAMES))
DDOCFLAGS = -Dd. -c -o- std.ddoc -Isrc

target: $(LIB)

$(LIB):
	$(DMD) $(DFLAGS) -lib -of$(LIB) $(SRCS)

doc:
	$(DMD) $(DDOCFLAGS) $(SRCS)

clean:
	rm -f $(DOCS) $(LIB)

MAIN_FILE = "empty_mustache_unittest.d"

unittest:
	echo 'import mustache; void main(){}' > $(MAIN_FILE)
	$(DMD) $(DFLAGS) -unittest -of$(LIB) $(SRCS) -run $(MAIN_FILE)
	rm $(MAIN_FILE)
