# install xaringanBuilder remotes::install_github("jhelvy/xaringanBuilder", dependencies = TRUE)
.PHONY: %.html

clean:
	rm *_files -rf
	rm *.html *.pdf *.png -f
	rm libs/ -rf

%.html: %.Rmd
	Rscript -e "xaringanBuilder::build_html('$*.Rmd', self_contained = TRUE)"

%.pdf: %.Rmd
	Rscript -e "xaringanBuilder::build_pdf('$*.Rmd')"
	Rscript -e "xaringanBuilder::build_png('$*.Rmd')"
	/usr/bin/pdfjam --nup '2x4' --suffix 8up --delta '0.2cm 0.2cm' --a4paper --frame 'true' --scale '0.95' $*.pdf
