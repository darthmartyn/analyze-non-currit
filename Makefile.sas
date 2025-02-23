PROJ := -P sas.gpr
QUIET := -q
SPEED := --mode=fast
DEPTH := --mode=deep

clean:
	gprclean -ws ${QUIET} ${PROJ}

setup: clean
	mkdir -p verification\gnatsas\report_output
	mkdir -p verification\gnatsas\analyze_output

sloc: setup 
	gnatmetric ${PROJ}

standards:
	gnatcheck ${PROJ}

desktop: setup
	gnatsas analyze ${QUIET} --no-unused-annotate-warning ${SPEED} ${PROJ}
	gnatsas report text ${QUIET} ${PROJ}

server: setup
	gnatsas analyze -j0 ${QUIET} ${DEPTH} ${PROJ}
	gnatsas report gnathub ${QUIET} ${PROJ}
	gnatsas report csv ${QUIET} ${PROJ}
	gnatsas report security ${QUIET} ${PROJ}
	gnatsas report sarif ${QUIET} ${PROJ}
