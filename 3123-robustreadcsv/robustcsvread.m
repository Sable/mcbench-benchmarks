function MM=robustcsvread(filename)
% ROBUSTCSVREAD reads in CSV files with
% different number of columns on different
% lines
%
% This can easily be extended to give back
% a numeric matrix or mixed numeric and 
% string cell array.
%
% IT'S NOT FANCY, BUT IT WORKS

% robbins@bloomberg.net
% michael.robbins@us.cibc.com

fid=fopen(filename,'r');
slurp=fscanf(fid,'%c');
fclose(fid);
M=strread(slurp,'%s','delimiter','\n');
for i=1:length(M)
    temp=strread(M{i},'%s','delimiter',',');
    for j=1:length(temp)
        MM{i,j}=temp{j};
    end;
end;

