function F = myls(D)
% F = myls(D)  returns a cell array of strings containing the files
%        in directory D.
%
% 2008-10-29 Dan Ellis dpwe@ee.columbia.edu

%%%%% Check for network mode
OVERNET = 0;
if length(D) > 6
  if strcmp(lower(D(1:7)),'http://') == 1 ...
        | strcmp(lower(D(1:6)),'ftp://')
    % mp3info not available over network
    OVERNET = 1;
  end
end

if ~OVERNET
  S = ls('-1',D);
  F = tokenize(S,char(10));
else
  
  % Network mode - experimental
  % Will only work on Unix, with curl installed etc.
  
  % Break up the request string into root and pattern
  [p,n,e] = fileparts(D);
  p = [p,'/'];
  n = [n,e];
  if length(n) == 0;  n = '*'; end
  % Convert glob pattern to grep pattern
  % "." becomes "\."
  n = stringsub(n,'.','\.');
  % "*" becomes ".*"
  n = stringsub(n,'*','.*');

  n = ['^',n,'$'];
  
  r = mysystem(['curl -s ',p,...
          ' | grep href | sed -e ''s/.*href=\"\([^\"]*\)\".*/\1/'' | grep ''',...
          n,'''']);
  % break into cell array on line feeds
  F = tokenize(r,char(10));  
  % prepend the root URL in each case
  % If returned URL is complete, keep it all
  % If it begins with "/", just keep the host we got it from
  % else, prepend the whole root URL
  ix = find(p == '/');
  % find the 3rd one (first two are from http://)
  machpart = p(1:ix(3)-1);
  for i = 1:length(F)
    f = F{i};
    if f(1) == '/'
      F{i} = [machpart,f];
    elseif strcmp(f(1:7),'http://') == 0
      F{i} = [p,f];
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function T = stringsub(S,F,R)
% Replace all instances of substring F in string S with substring R.
% Return as T.

ix = strfind(S,F);
T = '';
b = 1;
for i = ix
  T = [T,S(b:(i-1)),R];
  b = i + length(F);
end
T = [T,S(b:end)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w = mysystem(cmd)
% Run system command; report error; return lines
[s,w] = system(cmd);
if s ~= 0 
  error(['unable to execute ',cmd,' (',w,')']);
end
% Debug
%disp([cmd,' -> ','*',w,'*']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = tokenize(s,t)
% Break space-separated string into cell array of strings
% 2004-09-18 dpwe@ee.columbia.edu
if nargin < 2;  t = ' '; end
a = [];
p = 1;
n = 1;
l = length(s);
nss = findstr([s(p:end),t],t);
for ns = nss
  % Skip initial spaces (tokens)
  if ns == p
    p = p+1;
  else
    if p <= l
      a{n} = s(p:(ns-1));
      n = n+1;
      p = ns+1;
    end
  end
end

