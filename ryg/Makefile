
COMPILER=../../PASM/pasm -b 
SOURCES=blue.p \
		green.p \
		orange.p \
		other.p \
		red.p

OBJECTS=$(SOURCES:.p=.bin)
.PHONY: clean all

all: $(OBJECTS)
	@echo "\033[32m  Finished building PRU binaries! \033[39m"

%.bin: %.p
	@echo "\033[34m  Building $<\033[39m"
	$(COMPILER) $<

clean:
	@echo "\033[32m  Removing object files $(OBJECTS) \033[39m"
	rm -rf $(OBJECTS)


