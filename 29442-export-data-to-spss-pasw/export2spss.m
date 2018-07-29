function save4spss(names, vars, titl)

%
% Copyright 2010 Jesse van Muijden, Leiden University, The Netherlands
% 
% This function is basically the same as the previously uploaded example
% script, but now it has the form of a function. The function can only
% handle numerical data.
%
% The first input argument must be a data matrix.
% The second input argument must be a cell array with variable names as
% strings (e.g. vars = {'participant', 'age', 'score'};. The function only
% works correctly if the number of cells equals the number of columns of the data
% matrix.
% The third argument must be a string. The string will be used as the name
% of the output files.
% 
% The matrix is saved as a tab separated .txt-file tab separated text file.
% An spss syntax file is created. This .sps-file loads all data just saved 
% in the .txt-file and saves it as an spss .sav-file.
% 
% Hulde!
%

%width and decimals of vars
sizes = [12*ones(1,length(vars)); ...
         6*ones(1,length(vars))];

% open textfile for later export to spss
fid = fopen([titl '.txt'],'w');

% write the variable names on the first line of the text file
for i = 1:size(names,2)
    fprintf(fid,'%s',names{i});
    if i == size(names,2)
        fprintf(fid,'\r\n');
    else
        fprintf(fid,'\t');
    end
end

% write data to text file
%loop through cases
for i = 1:size(vars,1)
    % loop through variables
    for j = 1:size(vars,2)
        tempvalue = num2str(vars(i,j));
        if (~isempty(find(tempvalue=='.')))
            tempvalue(find(tempvalue=='.'))=',';
        end
        fprintf(fid,'%s',tempvalue);
        if j == size(vars,2)
            if i < size(vars,1)
                fprintf(fid,'\r\n');
            end
        else
            fprintf(fid,'\t');
        end
        
    end
    
end

% close the text file
fclose(fid);

% open syntax file
fid = fopen([titl '.sps'],'w');

% write content
fprintf(fid,'GET DATA\r\n');
fprintf(fid,'  /TYPE=TXT\r\n');

% escape special characters
slshs = find(cd=='\');
dr = cd;
dirname = dr(1:slshs(1)-1);
for i = 2:length(slshs)
    dirname = [dirname '\' dr(slshs(i-1):slshs(i)-1)];
end
dirname = [dirname  '\' dr(slshs(i):end)];

% write some more
fprintf(fid,['  /FILE=''' dirname '\\' titl '.txt''\r\n']);
fprintf(fid,'  /DELCASE=LINE\r\n');
fprintf(fid,'  /DELIMITERS="\\t"\r\n');
fprintf(fid,'  /ARRANGEMENT=DELIMITED\r\n');
fprintf(fid,'  /FIRSTCASE=2\r\n');
fprintf(fid,'  /IMPORTCASE=ALL\r\n');
fprintf(fid,'  /VARIABLES=\r\n');

% define variable names and the width and decimals of data in each column
for  i = 1:size(names,2)
    fprintf(fid,['  ' names{i} ' F' num2str(sizes(1,i)) '.' num2str(sizes(2,i)) '\r\n']);
end

% add lines for saving the spss file
fprintf(fid,['.\r\n\r\nSAVE OUTFILE=''' dirname '\\' titl '.sav''\r\n']);
fprintf(fid,'/COMPRESSED');

% close the file
fclose(fid);

% open the syntax file in spss
[s,w] = dos([dirname '\\' titl '.sps']);