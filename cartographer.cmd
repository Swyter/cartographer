@echo off && cls && title swycartographer log--
@luajit cartographer.lua
if %errorlevel% neq 0 (
	echo _________________________
	echo Oops, looks like we have a bug over there :^)
	pause
)