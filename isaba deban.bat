::author : Monsef ALAHEM
:: date : 2017
@echo off
set frequence= 2
set duree= 30000

:loop
timeout /t %frequence%
start deban.exe %duree%
goto loop