# $Id$

IMAGES=	blogreen.png blogreen.svg

all: ${IMAGES}

.SUFFIXES:	.dot .png .svg
.PHONY:		clean

.dot.svg:
	dot -Tsvg -o ${.TARGET} ${.IMPSRC}

.dot.png:
	dot -Tpng -o ${.TARGET} ${.IMPSRC} && mogrify -resize 320x240 ${.TARGET} || ( rm -f ${.TARGET} && false )

clean:
	rm -f ${IMAGES}
