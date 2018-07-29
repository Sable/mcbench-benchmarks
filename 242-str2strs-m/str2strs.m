function y=str2strs(s)

% this function takes s (a string deliminated by tabs, commas, etc.)
%  and breaks it up into sub strings stored in y (a cell array of strings)
%
% spaces are eliminated by the function strcat so these are replaced in the 
%  beginning by an underscore. space delimination can be handled, though s
%  should be checked for any pre-existing underscrores.
%
% recovery of the individual elements is by using the char command
%
% e.g., applying it to a tab deliminated string...
%   fields = str2strs('abc	d%*	34_EF	5	s p a c e s')     returns
%   'abc'    'd%*'    '34_EF'    '5'    's_p_a_c_e_s'
% and then
%   char(fields(3))     returns
%   34_EF
%
% David Malicky  malicky@umich.edu

% replace each space w/ a character that strcat won't miss
s=strrep(s,' ','_');
delim='	'; % that long space is a tab, though any character may be used

lens=length(s);
tabs=findstr(s,delim);
numtabs=length(tabs);	% this is 1 less than the number of sub-strings

i=0;
for j=1:numtabs+1
	y(j)=cellstr('');
	while ( (i<lens) & (s(i+1)~=delim)  )  % another tab
		y(j)=strcat(y(j),s(i+1));
		i=i+1;
	end;
	i=i+1;
end;

y;

