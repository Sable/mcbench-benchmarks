function  filelist =  filehound(filespec)
%==========================================================================
% syntax: 
%         filelist =  filehound(filespec)
% or:     filelist =  filehound   
%         for default search for *.m files
%
% description   : recursively examines directories for presence of files 
% 		  matching the filter defined by input parameter 'filespec'
%
% parameters in : filespec = (optional) filter for filenames default = '*.m'
% filespec can be of any kind: a wild card can be used both for filename
% and for extension.
%
% Examples:
%   filelist = filehound('*')
%   filelist = filehound('*.*')
% 
% Search for all files in current directory and subdirectories
%
%   filelist = filehound('myfile')
%   filelist = filehound('myfile.*')
%
% Search for all files whose name is 'myfile' independently from extension
%
%   filelist = filehound('*.ext')
%   
% Search for files with specific extension 'ext'
%
% Search of file is powered also by wild-card handling (i.e.: '*'). The
% only assumption is that the current program assumes that '*' is at least
% a permitted char, i.e. '*' cannot be an empty string. In this way: 'ab*c'
% cannot be equivalent to 'abc' in the search. Moreover '*abc' refers to
% the last part of a string, 'ab*c' sets constraints on first two letters
% of the string and the last letter, 'abc*', requires that the first three
% letters of the string are 'abc'. The string here is meant both filename
% and extension. Hence possible calls of filehound can be:
%
%  filelist = filehound('*x.m*t')
%  filelist = filehound('a*x.mt*')
%  filelist = filehound('ax*.*mt')
%  ...
%  ... 
%  and all the other possbile combinations. Only one wild-card for filename
%  and extension is allowed.
%
% parameters out: filelist = cell array with paths for specified files
%
% filename      : filehound.m
%      
%==========================================================================

%==========================================================================
% author        : Maurizio De Pitta', Tel-Aviv University
%                 mauriziodepitta@gmail.com, maurizio@post.tau.ac.il
% 
% Based on filehound.m by Ronald Ouwerkerk, File ID: 171 on Matlab Central
% / File Exchange
%
% version 1.1, Tel Aviv, Sept 1st, 2008: Adopts filesep use (thanks to
% Thierry Dalon for the suggestion)
% version 1.0, Tel Aviv, July 7th, 2008
% 
% To do: user-defined option to produce report TXT file with all the file
% found according to specified criteria
%==========================================================================
% global fout
global delimiter

%==========================================================================
% set default
%==========================================================================
if nargin == 0
  filespec = '*.m';
end; 

% Original directory
olddir = pwd;

% Identifies filename part and extention part in filespec
delimiter = '.';
k = findstr(filespec,delimiter);    
if isempty(k) % filespec is only the name of the file
    fnspec = filespec;
    extspec = '*';
else
    fnspec = filespec(1:k-1); % assumes that k is scalar (i.e.: only one '.' is in the file name and it is associated to extension
    extspec = filespec(k+1:end);
end

% %==========================================================================
% % Get parent directory to search and filename for collected files
% %==========================================================================
% fileuititle = 'Select directory and filename for report'; 
% [filename, pathname] = uiputfile('*.txt', fileuititle);
% if isempty(filename)
%   filename = 'report.txt';
%   pathname = pwd;
% else
%   eval(['cd ',pathname]);
% end; 

% %==========================================================================
% % create filename for collected files delete old copies
% %==========================================================================
% topdir = pwd;
% outfilename = [topdir, filesep, filename];
% if exist(outfilename, 'file')
%   eval(['delete ',outfilename]);
% end;  

%==========================================================================
% recursively scan all subdirectories
%==========================================================================
filelist = [];
% fout = fopen(outfilename,'a');
filelist = scandir(filelist, fnspec, extspec);
% fclose(fout);
eval(['cd ',olddir,';']);

%==========================================================================
% END main
%==========================================================================
%==========================================================================
% local function scandir
% Scans the present directory and recursively scans all directories below 
%==========================================================================
function filelist = scandir(filelist, fnspec, extspec)
%==========================================================================
% define the global file ID
%==========================================================================
% global fout
global delimiter

%==========================================================================
% define set of leagl chars for dirnames
%==========================================================================
legalchar = '-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

%==========================================================================
% get dir list
%==========================================================================
thisdir = pwd;
thisdirlist = dir(thisdir);

%==========================================================================
% find files (not isdir)
%==========================================================================
kdir = [thisdirlist(:).isdir];
allfilelist = struct2cell(thisdirlist(~kdir));
allfilelist = allfilelist(1,:);

% Builds cell array of filename and extension strings (only though if there
% are files in the current directory, in case not it skips to
% subdirectories)
if ~isempty(allfilelist)
    for i = 1:length(allfilelist)
        [tok,rem] = strtok(allfilelist(i),delimiter);
        filename(i) = tok;
        % This assignment takes all the extensions without '.'
        extension(i) = {rem{1}(2:end)};
    end

    % Wildcard handling on extspec
    iext = wildcardhandling(extspec,extension);
    % Wildcard handling on fnspec
    ifn = wildcardhandling(fnspec,filename);

%==========================================================================
% files matching the pattern of filespec
%==========================================================================
    % redefine k
    k = intersect(ifn,iext);
    allfilelist = allfilelist(k);
    nfiles = length(allfilelist);
    listpos = length(filelist);
    count = 0;

    for filei = 1:nfiles
        filestr = [thisdir,filesep,allfilelist{filei}];
        count = count+1;
        filelist{listpos + count} = filestr;
    end
end

%==========================================================================
% find subdirectories
%==========================================================================
kdir = [thisdirlist(:).isdir];
thisdirlist = thisdirlist(kdir);
ndirs = length(thisdirlist);

%==========================================================================
% scan all subdirectories recursively
%==========================================================================
for diri= 1:ndirs
  subdirname = thisdirlist(diri).name;
  if ~strcmp(subdirname,'.') & ~strcmp(subdirname,'..')
     ipos =  ismember(subdirname,legalchar);     
     if length(subdirname(ipos)) < length(subdirname)
       msgstr = sprintf('Skipped directory %s because its name', subdirname);
       msgstr = sprintf('%s contains illegal characters\n',msgstr);
       disp(msgstr) 
     else
       cmdstr = ['cd ',subdirname,';'];
       % Subdirectory checking - output messaging
       disp(cmdstr);
       eval(cmdstr);
       filelist = scandir(filelist, fnspec, extspec);
       cmdstr = ['cd ',thisdir,';'];
       eval(cmdstr);
    end;   
  end
end
%==========================================================================
%END local function scandir
%==========================================================================
%==========================================================================
%local function wildcardhandling
%==========================================================================
function index = wildcardhandling(chkstr,liststr)
% Returns indexes of strings in liststr that match generic chkstr
% expression, this latter containing at most one '*' in any position
% 
index = 1:length(liststr);
lstr = length(chkstr);
wcpos = findstr(chkstr,'*');
if isempty(wcpos) % liststr is specified
    k = strmatch(chkstr,liststr,'exact');
else
    k = [];
    % There is a wildcard in liststr specification - depending on the
    % position, different actions are taken
    if (wcpos==1)&(wcpos==lstr) % chkstr = '*'
        k = index;
    elseif (wcpos==1)&(wcpos<length(chkstr))  %'.*xx'
        for i = 1:length(liststr)
            if (length(liststr{i}(2:end))>=(lstr-1)) & strcmp(chkstr(2:end),liststr{i}(end-length(chkstr(2:end))+1:end))
                k = [k i];
            end
        end
    elseif (wcpos~=1)&(wcpos<length(chkstr))  %'.x*x'
        for i = 1:length(liststr)
            if (length(liststr{i}(liststr{i}~=wcpos))>=(lstr-1)) & strcmp(chkstr(1:wcpos-1),liststr{i}(1:length(chkstr(1:wcpos-1)))) & strcmp(chkstr(wcpos+1:end),liststr{i}(end-length(chkstr(wcpos+1:end))+1:end))
                k = [k i];
            end
        end
    else (wcpos~=1)&(wcpos==length(chkstr))   %'.xx*'
        for i = 1:length(liststr)
            if (length(liststr{i}(1:end-1))>=(lstr-1)) & strcmp(chkstr(1:end-1),liststr{i}(1:length(chkstr(1:end-1))))
                k = [k i];
            end
        end
    end
end
index = index(k);        
%==========================================================================
%END local function wildcardhandling
%==========================================================================
