::author : Monsef ALAHEM
:: date : 2017
@echo off
:: en second, c�d chaque 20 minutes
set frequence= 1200 
::ms c�d 1 minute 
set duree= 60000                   
:loop

timeout /t %frequence%                              
start deban.exe %duree%

goto loop 
