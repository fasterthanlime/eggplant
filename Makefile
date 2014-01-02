
DEBUG_FLAGS = -v -O3

normal:
	PKG_CONFIG_PATH=/home/amos/Dev/dummyprefix/lib/pkgconfig \
	  rock ${DEBUG_FLAGS}

clean:
	rock -x
