CC = g++
CPPFLAGS     = -std=c++11 -O1 -Wall -Wextra -fsanitize=address
LDFLAGS      =
LIBS         = -lm

TARGETS = main

all: $(TARGETS)

main:
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ main.cpp tgaimage.cpp

clean:
	rm -f $(TARGETS)
	rm -f *.tga
	rm -f *.o

