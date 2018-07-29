function infos=rd3info(fname,varargin)
% Gets info from the rad file accompanying the RD3 file
% 
% syntax: infos=rd3info(fname,param1,param2,....)
% 
% apart from the params in the rad file there is an additional param called 'scans'.
%
% example: 
% >> infos = rd3info(fname,'scans','samples','timewindow')
% infos = 
%    [7359]    [1024]    [196.8947]
%
% load details from .RAD file

fname=strrep(lower(fname),'.rd3','');

numargcount=size(varargin,2);

[field,value]=textread([fname '.rad'],'%s:%s','whitespace',':\n');

for i=1:numargcount
    param=varargin{i};
    if strcmpi(param,'scans')
        sz=getproperty('samples',field,value);
        s=dir([fname '.rd3']);
        infos{i}=s.bytes/(2*sz); %2 bytes per value
    else
        infos{i}=getproperty(param,field,value);
    end 
end


function propvalue=getproperty(propname,fields,values)
for l=1:size(fields,1)
   if (strcmpi(fields{l},propname))
      propvalue=values{l};
   end
end
a=sscanf(propvalue,'%f');
if (size(a,2)~=0)
   propvalue=a;
end


