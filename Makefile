all: output/lncs-paper.pdf output/acm-paper.pdf

output/acm-paper.pdf output/acm-paper.tex: paper/paper.md
	cp ./styles/acm.cls .
	mkdir -p ./output
	pandoc  --wrap=preserve \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--csl=./styles/acm.csl \
		--number-sections \
		./acm-packages.yaml \
		--include-before-body=./templates/acm-longtable-fix-preamble.latex \
		--template=./templates/acm.latex \
		-o output/acm-paper.$(subst output/acm-paper.,,$@) paper/paper.md
	rm ./acm.cls

output/lncs-paper.pdf output/lncs-paper.tex: paper/paper.md
	cp ./styles/llncs.cls .
	mkdir -p ./output
	pandoc  --wrap=preserve \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--csl=./styles/llncs.csl \
		--number-sections \
		./llncs-packages.yaml \
		--template=./templates/llncs.latex \
		-o output/lncs-paper.$(subst output/lncs-paper.,,$@) paper/paper.md
	rm ./llncs.cls

clean:
	rm output/*

