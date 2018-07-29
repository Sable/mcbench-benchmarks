function res = readExperimentalData(inFileName)
% readExperimentalData : Read in the pendulum experiment data from an Excel
% spreadsheet.
% The spreadsheet data is of the form:
% Time	        Position	  Velocity
% 0	            1.57084162	  -0.000789374
% 0.049974509	1.521674038	  -1.973848125
% 0.099949019	1.373449177	  -3.93452411
% 0.149923528	1.129514124	  -5.8238293
% ...

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% xlsread by default returns the matrix of numeric data starting at the top
% left hand corner of Sheet 1 of the workbook.  When more output arguments
% are supplied it will also return the text data (here column headings) and
% the raw data (both text and numeric data returned as a cell array of
% strings).  The general form of a call to xlsread is:
% [numericData, textData, rawData] = xlsread(inFileName,<more options>);
% where <more options> are described by 'help xlsread' or 'doc xlsread'

% Here we are just interested in the numeric data so only call with a
% single output argument:
numericData = xlsread(inFileName);

% Extract the columns of the numeric data array into fields of a structure.
res.Time = numericData(:,1);
res.Position = numericData(:,2);
res.Velocity = numericData(:,3);
