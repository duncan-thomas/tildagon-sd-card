PROJECT=hexpansion

OS_NAME := $(shell uname -s | tr A-Z a-z)

CLI :=
ifeq ($(OS_NAME),darwin)
	CLI=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
else
	CLI=kicad-cli
endif

all: renders

out:
	mkdir -p out

renders: out out/$(PROJECT)-board.pdf out/$(PROJECT)-schematic.pdf

out/%-board.pdf: kicad/%.kicad_pcb
	$(CLI) pcb export pdf --layers F.Fab,B.Fab,Edge.Cuts,F.Cu,B.Cu --output $@ $<

out/%-schematic.pdf: kicad/%.kicad_sch
	$(CLI) sch export pdf --exclude-drawing-sheet --output $@ $<

out/%-render.step: out kicad/%.kicad.pcd
	$(CLI)  pcb export step --output $@ $<

clean:
	rm -rf out
