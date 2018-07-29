function show(fname,opts,leng_str,output)
%SHOW   Display contents of NetCDF file
%
%   Syntax:
%      SHOW(FILE,OPT,LENG_STR,OUTPUT)
%
%   Inputs:
%      FILE       NetCDF file [ <none> ]
%      OPT        Show variables long_name, units, file  dimensions
%                 and attributes [ <1 1 0 0> ]
%      LENG_STR   Maximum length of variable name and long_name
%                 string [ 25 ]
%      OUTPUT     Write (fid or filename)/show results [ {1} <fid> <filename> ]
%
%   Requirement:
%      The NetCDF toolbox available at
%      http://crusty.er.usgs.gov/~cdenham/MexCDF/nc4ml5.html
%
%   Comment:
%      If scale or offset are present for a var, then an '*' is written
%      before it, first '*' is for scale and second is for offset
%
%   Examples:
%      show
%      show('file.nc')
%      show('file.nc',[1 1 1 1],50,'file_contents.txt')
%
%   MMA 2001, martinho@fis.ua.pt
%
%   See also USE

%   Department of Physics
%   University of Aveiro, Portugal

%   26-01-2005 - Small correction to be used also by r14
%   07-02-2005 - Added OPT(3:4)

openf=0;
if nargin < 4
  fid=1;
  fprintf(1,'\n');
else
  if isstr(output)
    fid=fopen(output,'w');
    openf=1;
  else
    fid=output;
  end
end

if nargin < 3
  smax=25;
else
  smax=leng_str;
end

if nargin < 2
  show_lname = 1;
  show_units = 1;
  show_att   = 0;
  show_dim   = 0;
else
  show_lname=opts(1);
  eval('show_units = opts(2);','show_units = 0;');
  eval('show_att   = opts(3);','show_att   = 0;');
  eval('show_dim   = opts(4);','show_dim   = 0;');
end

if nargin == 0
  nc=netcdf('nowrite');
else
  nc=netcdf(fname,'nowrite');
end

if isempty(nc)
  return
end

fname=name(nc);
vv=var(nc);
nvars=length(vv);

% ---------------------------------------------------------- lengths :
warning off
l_Name      = length(name(vv{1}));
l_Long_name = length(nc{name(vv{1})}.long_name(:));
l_maxSize   = length(num2str(max(size(vv{1}))));
l_Units     = length(nc{name(vv{1})}.units(:));

for i=2:nvars
  l_Name_      = length(name(vv{i}));
  l_Long_name_ = length(nc{name(vv{i})}.long_name(:));
  l_maxSize_   = length(num2str(max(size(vv{i}))));
  l_Units_     = length(nc{name(vv{i})}.units(:));

  l_Name      = max(l_Name,l_Name_);
  l_Long_name = max(l_Long_name_,l_Long_name);
  l_maxSize   = max(l_maxSize_,l_maxSize);
  l_Units     = max(l_Units_,l_Units);
end
warning on

LN  = min(smax,l_Name);
LLN = min(smax,l_Long_name);
LU  = min(smax,l_Units);

% deal with size:
l_Size = 0;
for i=1:nvars
  Size      = size(vv{i});
  sformat  = [];
  for n=1:length(Size)
    sformat = [sformat,'  %',num2str(l_maxSize),'d '];
  end
  size_ = sprintf(sformat,Size);
  l_Size = max(l_Size,length(size_));
end
LS  = min(smax,l_Size);

% --------------------------------------------------------------------

fprintf(fid,'-------------------------------------------------------------------\n');
fprintf(fid,'# Contents of the NetCDF file\n');
fprintf(fid,'  %s\n',fname);
fprintf(fid,'%s\n','');

% --------------------------------------------------------------------
% Atributes
% --------------------------------------------------------------------
if show_att
  fprintf(fid,':: Atributes\n');

  strn = '';
  strl = '';
  a=att(nc);
  for i=1:length(a)
    b=a{i};
    attrib.name{i}  = name(b);
    attrib.value{i} = b(:);

    strn = strvcat(strn,attrib.name{i});
    % deal with numeric values:
    if isnumeric(attrib.value{i})
      if any(size(attrib.value{i}) == 1) & length(attrib.value{i}) == 1
        attrib.value{i} = ['<numeric: ',num2str(attrib.value{i}),'>'];
      else
        attrib.value{i} = ['<numeric: size = ',num2str(size(attrib.value{i})),'>'];
      end
    % deal with long strings:
    else
      if length(attrib.value{i}) > 50;
        attrib.value{i} = [attrib.value{i}(1:49),'+'];
      end
    end
    % deal with empty values:
    if isempty(attrib.value{i})
      attrib.value{i} = '<empty>';
    end
    strl = strvcat(strl,num2str(attrib.value{i}));
  end
  maxn = size(strn,2);
  maxl = size(strl,2);
  for i=1:length(attrib.name)
    format = ['   %',num2str(maxn),'s     %s\n'];
    fprintf(fid,format,strn(i,:),rtrim(strl(i,:)));
  end

  %  n_fileatt(fname);
  fprintf(fid,'\n');
end

% --------------------------------------------------------------------
% Dimensions
% --------------------------------------------------------------------
if show_dim
  fprintf(fid,':: Dimensions\n');

  strn = '';
  strl = '';
  d=dim(nc);
  for i=1:length(d)
    thedim.name{i}   = name(d{i}); % NetCDF_Dimension
    thedim.length{i} = d{i}(:);    % itsLength

    strn = strvcat(strn,thedim.name{i});
    strl = strvcat(strl,num2str(thedim.length{i}));
  end
  maxn = size(strn,2);
  maxl = size(strl,2);
  for i=1:length(thedim.name)
    format = ['   %',num2str(maxn),'s   %',num2str(maxl),'s\n'];
    fprintf(fid,format,strn(i,:),rtrim(strl(i,:)));
  end

  %  n_filedim(fname);
  fprintf(fid,'\n');
end

% --------------------------------------------------------------------
% Variables
% --------------------------------------------------------------------
fprintf(fid,':: Variables\n\n');

warning off
for i=1:nvars
  % search for scale and offset:
  is_scale=0;  str1='-';
  is_offset=0; str2='-';
  a=att(vv{i});
  for n=1:length(a)
    b=a{n};
    att_name=name(b);
    if isequal(att_name,'scale_factor');
      is_scale=1;
      str1='*';
    end
    if isequal(att_name,'add_offset');
      is_offset=1;
      str2='*';
    end
  end

  Name      = name(vv{i});
  Long_name = nc{name(vv{i})}.long_name(:);
  Size      = size(vv{i});
  Units     = nc{name(vv{i})}.units(:);

  sname = repmat(' ',1,LN);
  lname = repmat(' ',1,LLN);
  size_ = repmat(' ',1,LS);
  units = repmat(' ',1,LU);

  lN  = min(length(Name),LN);
  lLN = min(length(Long_name),LLN);
  lU  = min(length(Units),LU);

  sname(1:lN)  = Name(1:lN);
  lname(1:lLN) = Long_name(1:lLN);
  units(1:lU)  = Units(1:lU);

  % deal with size:
  sformat  = [];
  for n=1:length(Size)
    sformat = [sformat,'  %',num2str(l_maxSize),'d '];
  end
  size__ = sprintf(sformat,Size);
  lS  = min(length(size__),LS);
  size_(1:lS) = size__(1:lS);

  % add + char at the end of strings:
  if length(Name) > lN,       sname(end) = '+'; end
  if length(Long_name) > lLN, lname(end) = '+'; end
  if length(size__) > lS,     size_(end) = '+'; end
  if length(Units) > lU,      units(end) = '+'; end


  if show_lname & show_units
    if i==1, fprintf(fid,'%s\n\n','[scale(*) offset(*) - Var - Long_Name - Size - Units]'); end
    str = sprintf('%s%s %s  %s  %s  %s',str1,str2,sname,lname,size_,units);
  elseif show_lname
    if i==1, fprintf(fid,'%s\n\n','[scale(*) offset(*) - Var - Long_Name - Size]');         end
    str = sprintf('%s%s %s  %s  %s',str1,str2,sname,lname,size_);
  elseif show_units
    if i==1, fprintf(fid,'%s\n\n','[scale(*) offset(*) - Var -  Size - Units]');            end
    str = sprintf('%s%s %s  %s  %s',str1,str2,sname,size_,units);
  else
    if i==1, fprintf(fid,'%s\n\n','[scale(*) offset(*) - Var - Size]');                     end
    str = sprintf('%s%s %s %s',str1,str2,sname,size_);
  end
  fprintf(fid,'%s\n',rtrim(str));
end
warning on

nc=close(nc);
fprintf(fid,'\n-------------------------------------------------------------------\n');
if openf
  fid=fclose(fid);
else
  fprintf(1,'\n');
end

function theString = rtrim(theString,charList)
if nargin < 2
  charList = ' ';
end
n=length(theString);
while 1
  if ~any(theString(n) == charList), break, end
  n=n-1;
  if n==0, break, end
end
theString = theString(1:n);
