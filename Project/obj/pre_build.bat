@echo off
echo Running Project Build Version Number...
If exist %ANT_HOME%\bin\ant.bat (
ant.bat -buildfile %cd%\obj\buildVersion.xml Main-Build-version
)
