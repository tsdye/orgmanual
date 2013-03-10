TEXI2PDF+=--tidy
BEXP=$(BATCH) \
	--eval '(add-to-list '"'"'load-path "../lisp")' \
	--eval '(setq org-footnote-auto-adjust nil)'
EXTEXI=	-l ox-texinfo \
	--eval '(add-to-list '"'"'org-export-snippet-translation-alist '"'"'("info" . "texinfo"))'
EXHTML=	-l ox-html \
	$(BTEST_POST) \
	--eval '(add-to-list '"'"'org-export-snippet-translation-alist '"'"'("info" . "texinfo"))'
ORG2TEXI=-f org-texinfo-export-to-texinfo
ORG2HTML=-f org-html-export-to-html
ORG2INFO=--eval "(org-texinfo-compile \"./$<\")"

.SUFFIXES:	# we don't need default suffix rules
ifeq ($(MAKELEVEL), 0)
  $(error This make needs to be started as a sub-make from the toplevel directory.)
endif
.PHONY:		all info html pdf

all:		$(ORG_MAKE_DOC)

info:		orgmanual.info

html:		orgmanual orgmanual.html

pdf:		orgmanual.pdf

orgmanual.texi:	orgmanual.org
	$(BEXP) $(EXTEXI) $< $(ORG2TEXI)
orgmanual.info:	orgmanual.texi
	$(MAKEINFO)  --no-split $< -o $@
orgmanual.pdf:	LC_ALL=C        # work around a bug in texi2dvi
orgmanual.pdf:	LANG=C          # work around a bug in texi2dvi
orgmanual.pdf:	orgmanual.texi
	$(TEXI2PDF) $<
orgmanual:	orgmanual.texi
	$(TEXI2HTML) $<
orgmanual.html: orgmanual.org
	$(BEXP) $(EXHTML) $< $(ORG2HTML)

clean:
	$(RM) org *.pdf *.html \
	      *.aux *.cp *.cps *.dvi *.fn *.fns *.ky *.kys *.pg *.pgs \
	      *.toc *.tp *.tps *.vr *.vrs *.log *.html *.ps
cleanall:	clean
	$(RMR) orgmanual.t2d orgmanual



