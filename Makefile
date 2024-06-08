report_out.md: report.md report.scm
	GUILE_LOAD_PATH=. amina --warn --no-json --init=report.scm --template=report.md > report_out.md