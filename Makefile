all: output/acm-paper.pdf output/acm-paper.tex #output/ieee-paper.pdf output/lncs-paper.pdf #output/ieee-paper.tex output/lncs-paper.tex output/acm-paper.tex

output/ieee-paper.pdf output/ieee-paper.tex: paper/paper.md
	cp ./styles/IEEEtran.cls .
	mkdir -p output
	pandoc  --wrap=preserve \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--filter ./pandoc-tools/table-filter.py \
		--filter ./pandoc-tools/bib-filter.py \
		--number-sections \
		--csl=./styles/ieee.csl \
		./ieee-packages.yaml \
		--include-before-body=./templates/ieee-longtable-fix-preamble.latex \
		--include-before-body=./ieee-author-preamble.latex \
		--template=./templates/ieee.latex \
		-o output/ieee-paper.$(subst output/ieee-paper.,,$@) paper/paper.md
	rm ./IEEEtran.cls

output/acm-paper.pdf output/acm-paper.tex: paper/paper.md
	cp ./styles/acmart.cls .
	mkdir -p ./output
	pandoc  --wrap=preserve \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--filter ./pandoc-tools/table-filter.py \
		--filter ./pandoc-tools/bib-filter.py \
		--csl=./styles/acm.csl \
		--number-sections \
		./acm-packages.yaml \
		--include-before-body=./templates/acm-longtable-fix-preamble.latex \
		--include-before-body=./acm-author-preamble.latex \
		--template=./templates/acm.latex \
		-o output/acm-paper.$(subst output/acm-paper.,,$@) paper/paper.md
	rm ./acmart.cls

output/lncs-paper.pdf output/lncs-paper.tex: paper/paper.md
	cp ./styles/llncs.cls .
	mkdir -p ./output
	pandoc  --wrap=preserve \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--filter ./pandoc-tools/table-filter.py \
		--filter ./pandoc-tools/bib-filter.py \
		--csl=./styles/llncs.csl \
		--number-sections \
		./llncs-packages.yaml \
		--template=./templates/llncs.latex \
		-o output/lncs-paper.$(subst output/lncs-paper.,,$@) paper/paper.md
	rm ./llncs.cls

clean:
	rm output/*

