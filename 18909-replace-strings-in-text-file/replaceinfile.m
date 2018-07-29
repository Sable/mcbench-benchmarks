function [s, msg] = replaceinfile(str1, str2, infile, outfile)
%REPLACEINFILE replaces characters in ASCII file using PERL
%  
% [s, msg] = replaceinfile(str1, str2, infile)
%    replaces str1 with str2 in infile, original file is saved as "infile.bak"
%
% [s, msg] = replaceinfile(str1, str2, infile, outfile)
%    writes contents of infile to outfile, str1 replaced with str2
%    NOTE! if outputfile is '-nobak' the backup file will be deleted
%
% [s, msg] = replaceinfile(str1, str2)
%    opens gui for the infile, replaces str1 with str2 in infile, original file is saved as "infile.bak"
%
% in:  str1      string to be replaced
%      str2      string to replace with
%      infile    file to search in
%      outfile   outputfile (optional) if '-nobak'
%
% out: s         status information, 0 if succesful
%      msg       messages from calling PERL 

% Pekka Kumpulainen 30.08.2000
% 16.11.2008 fixed for paths having whitespaces, 
% 16.11.2008 dos rename replaced by "movefile" to force overwrite
% 08.01.2009 '-nobak' option to remove backup file, fixed help a little..
%
% TAMPERE UNIVERSITY OF TECHNOLOGY  
% Measurement and Information Technology
% www.mit.tut.fi

message = nargchk(2,4,nargin);
if ~isempty(message)
    error(message)
end

%% check inputs
if ~(ischar(str1) && ischar(str2))
    error('Invalid string arguments.')
end
% in case of single characters, escape special characters 
% (at least someof them)
switch str1
    case {'\' '.'}
        str1 = ['\' str1];
end

%% uigetfile if none given
if nargin < 3;
    [fn, fpath] = uigetfile('*.*','Select file');
    if ~ischar(fn)
        return
    end
    infile = fullfile(fpath,fn);
end

%% The PERL stuff
perlCmd = sprintf('"%s"',fullfile(matlabroot, 'sys\perl\win32\bin\perl'));
perlstr = sprintf('%s -i.bak -pe"s/%s/%s/g" "%s"', perlCmd, str1, str2,infile);

[s,msg] = dos(perlstr);

%% rename files if outputfile given
if ~isempty(msg)
    error(msg)
else
    if nargin > 3 % rename files
        if strcmp('-nobak',outfile)
            delete(sprintf('%s.bak',infile));
        else
            movefile(infile, outfile);
            movefile(sprintf('%s.bak',infile), infile);
        end
    end
end
