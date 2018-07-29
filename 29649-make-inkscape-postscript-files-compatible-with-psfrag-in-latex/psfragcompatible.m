function [s, msg] = psfragcompatible(infile, outfile)
%REPLACEINFILE replaces characters in ASCII file using PERL
%  
% [s, msg] = replaceinfile(infile)
%    replaces stupid cairo style in infile, original file is saved as "infile.bak"
%
% [s, msg] = replaceinfile(infile, outfile)
%    writes contents of infile to outfile, replaces stupid cairo style in infile
%    NOTE! if outputfile is '-nobak' the backup file will be deleted
%
% [s, msg] = replaceinfile()
%    opens gui for the infile, replaces stupid cairo style in infile, original file is saved as "infile.bak"
%
% in:  infile    file to search in
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
%
% Ulrich Sachs 07.12.2010
% 07.12.2010 converted original replaceinfile.m from Kumpulainen to
% psfragcompatible

message = nargchk(0,2,nargin);
if ~isempty(message)
    error(message)
end

%% uigetfile if none given
if nargin < 1;
    [fn, fpath] = uigetfile('*.*','Select file');
    if ~ischar(fn)
        return
    end
    infile = fullfile(fpath,fn);
end

% replace strings with the pattern 
% <01020304>Tj or 
% [<010203>-1<0405>-1<06>-1<07>1<08>129<090a06>]TJ 
% by (placeholder)Tj

str1 = '(<[0-9a-z]+>Tj|\[<[0-9a-z<>-]+>\]TJ)';
%str2 = 'sprintf(''(%d)Tj'', $count+$count2+1)';
str2 = 'sprintf(''(%d)Tj'', $count+1)';

%% The PERL stuff
perlCmd = sprintf('"%s"',fullfile(matlabroot, 'sys\perl\win32\bin\perl'));
%perlstr = sprintf('%s -i.bak -pe "$count2 = $count2+$count; $count = 0; while(s/%s/%s/se){ $count++ +1 }" "%s"', perlCmd, str1, str2, infile);
perlstr = sprintf('%s -i.bak -pe "while(s/%s/%s/se){ $count++ }" "%s"', perlCmd, str1, str2, infile);
disp(perlstr)
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
