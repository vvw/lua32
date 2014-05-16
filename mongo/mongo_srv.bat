@echo off
set path=%path%;C:\Program Files\MongoDB 2.6 Standard\bin
@echo on
mongod --dbpath D:\srv\mongodb
pause
