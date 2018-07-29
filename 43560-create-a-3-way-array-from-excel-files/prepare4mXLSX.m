function prepare4mXLSX
% Program : prepare.m
%
% Purpose : make a 3D array of data from given excel files in 2007-2010
% format
%
% Author :  Aamir Alaud Din
% Date :    18.09.2013
%
% Inputs :  Excel files (2007-2010 format i.e., with extension xlsx)
%
% Output :  A mat file containing 3-Way array of the data read from excel
%           files
%
% Syntax :  prepare
%           
% Example:  prepare
%           
clear all; close all; clc;
Files = dir('*.xlsx');
TotalFiles = length(Files);
for ii = 1:TotalFiles
    FileName = Files(ii).name;
    Data = xlsread(FileName);
    ThreeWayArray(:,:,ii) = Data;
end
Data = ThreeWayArray;
save('Data.mat','Data');
load Data.mat;