% Write Values to the Windows Registry: 
%  writereg(rootkey,subkey,valname,value,...)
%
%  Example:
%  writereg('HKEY_LOCAL_MACHINE','SOFTWARE\My Software, Inc.\AppName',...
%           'TextSetting','c:\0.txt',...
%           'NumSetting',1);
%
%  The following registry value types are used:
%    "REG_SZ": when value is a string.
%    "REG_DWORD": when value is an integer.
%  No other value types are supported.
%
%  See also: winqueryreg
%
%  Alex Nelson, August 29, 2007
%
%  This function is available without warranty. It is recommended that
%  you comment out the last line and verify the correctness of the .reg
%  file before use, and that you backup your windows registry. 
%
%  This function was based on code available at:
%  www.compactech.com/forum/index.php?showtopic=241&mode=threaded&pid=590 
%
function writereg(rootkey,subkey,varargin)
  if mod(length(varargin),2)
    error('writereg:Value names and values must be in pairs');
  end
  tmpregfile = [getenv('TEMP') '\write_reg.reg']; 
  fp = fopen(tmpregfile,'wt'); 
  fprintf(fp,'Windows Registry Editor Version 5.00\n\n'); 
  fprintf(fp,'[%s\\%s]\n',rootkey,subkey);
  
  ii = 1;
  while ii<length(varargin) 
    valname =varargin{ii};
    value = varargin{ii+1};
    if ischar(value)                       % string value
      value = strrep(value,'\','\\');     %  escape backslashes
      vstr=sprintf('"%s"="%s"',valname,value);
    elseif isint(value) && value<2^32     % 32-bit integer values
      vstr=sprintf('"%s"=dword:%.8X',valname,value); % write as hexidecimal
    else
      error('Only values of type string or integer are supported');
    end
    ii=ii+2;
    fprintf(fp,'%s\n',vstr);
  end 
  fprintf(fp,'\n');
  fclose(fp); 

  doscmd = sprintf('C:\\windows\\regedit.exe /s %s', tmpregfile)
  dos(doscmd);


% ISINT(A) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Returns 1 for entries in matrix which are integers, and 0 for entries
%  which are non-integer.
% Alex Nelson 12/18/03
function a = isint(A)
  a = A==fix(A);

