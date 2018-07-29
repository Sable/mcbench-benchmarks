function [dataName,attributeName, attributeType, data]= arffread(fileName)
% ARFFREAD  Reads arff formatted file.
%          
% USAGE:
%       [dataName,attributeName, attributeType, data] = arffRead(fileName)
%
% INPUT:    
%       fileName:       file name to be read
%       
% OUTPUT: 
%       dataName:       relation name of the arff file
%       attributeName:       attribute name of attribute as cell array
%                       { 1 by nAttr }
%       attributeType:       attribute type of attribute as cell array
%                       { 1 by nAttr}
%       data:           data (nInstan by nAttr)
% 
% See also ARFFWRITE     

% Copyright 2004-2004 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2004/06/23 
% $Revision: 3.2.0 $ $Date: 2004/08/16 $  

% ***********************************************************************
if nargin < 1,
	error('No input arguments!');
end
if nargin > 1,
	error('Too many input arguments!');
end
% read whole string
wholeData = textread(fileName,'%s','delimiter','\n','whitespace','');
atRelation = '@relation';
atAttribute = '@attribute';
atData = '@data';
noOfLines = size(wholeData,1);
k=0;
%************************************************************************
%% Finding data name
for i=1:noOfLines
	k = findstr(wholeData{i},atRelation);
	if k ~= 0;
		lineAtRelation = i;
		[token,dataName] = strtok(wholeData{lineAtRelation});
		break
	end
end
% Check whether dataName has whitespaces
tf = isspace(dataName);
tf = find(tf ==1);
if size(tf,2)>1
	dataName = dataName(2:tf(2)-1);
else
	dataName = dataName(2:size(dataName,2));
end
% Check whether dataName has semicolons or others
% First convert to ascii code and note that quotation mark is 39 is ascii
ascDataName = double(dataName);
if ascDataName(1) == 39 
   ascDataName = ascDataName(2:end);
end
if ascDataName(end) == 39 
   ascDataName = ascDataName(1:end-1);
end
% Convert back to characters
dataName = char(ascDataName);
%************************************************************************
%% Finding attribute name
lineAtAttribute =[];
k=0;
l=0;
j = 0;
for i=lineAtRelation+1:noOfLines
	k = findstr(wholeData{i},atAttribute);
	if k ~= 0;
		lineAtAttribute =[lineAtAttribute i];
		[chopped,remainder] = strtok(wholeData{i});
		[attrName,remAttrType] = strtok(remainder);
		[attrType,rem] = strtok(remAttrType);
		j=j+1;
		attrVector{j} = attrName;
    	attrTypeVector{j} = attrType;
	end
	l = findstr(wholeData{i},atData);
	if l ~= 0;
		lineAtData = i;
		break
	end
end

%************************************************************************

% Finding whether data is tab formatted or csv and the position of data
k = [];
for i=lineAtData+1:noOfLines
	str = wholeData{i};
	if ~isempty(str) & ~strcmp(str,'%')
		k = findstr(wholeData{i},',');
		if ~isempty(k);
			dataFormat ='comma' ;
			lineData = i;
			break
		else
			dataFormat ='tabOrSpace' ;
			lineData = i;
			break
		end
	end
end

%************************************************************************
%% Reading formatted data
%nRowSkip=lineData-1;
nColSkip = 0;
%dataName = dataName;
attributeName = attrVector ;
attributeType = attrTypeVector;
%{
% You have to convert '' marks for each var to write in arff file
if strcmp(dataFormat,'comma')
	data = csvread(fileName,nRowSkip);
elseif strcmp(dataFormat,'tabOrSpace') | strcmp(dataFormat,'tab')...
		| strcmp(dataFormat,'Space')
    data = dlmread(fileName,'\t',nRowSkip,nColSkip);		% Space delimiter
	dataFormat = 'space';
	if size(data,2)~=size(attributeName,2)
    	data = dlmread(fileName,'\t' ,nRowSkip,nColSkip);	% tab delimiter
		dataFormat = 'tab';
	end
	if size(data,2)~=size(attributeName,2)
		error('arff file is not tab or comma delemited!');
	end
end
%}
strData = wholeData(lineData:end);
for i = 1:size(strData,1)
   data(i,:) = str2num(strData{i});
end
