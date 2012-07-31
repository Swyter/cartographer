@echo off && cls && title swycartographer log--
@luajit cartographer.lua
if not %errorlevel%==44 (
	echo _________________________
	echo Oops, looks like we have a bug over there :^)
	pause
)