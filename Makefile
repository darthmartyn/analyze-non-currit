clean:
	powershell -File gnatsas.ps1 -action "clean"
setup: clean
	powershell -File gnatsas.ps1 -action "setup"
sloc: setup 
	powershell -File gnatsas.ps1 -action "metrics"
standards: setup
	powershell -File gnatsas.ps1 -action "standards"
desktop: setup
	powershell -File gnatsas.ps1 -action "desktop"
server: setup
	powershell -File gnatsas.ps1 -action "server"
