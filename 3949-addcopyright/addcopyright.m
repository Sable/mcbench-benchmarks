function addcopyright(organization,folder,copyright_year,update,copyright_string)
%ADDCOPYRIGHT Add copyright info to M-file.
%   ADDCOPYRIGHT(ORGANIZATION) adds the copyright info to all M-files in
%   the current folder as well as subfolders.  The copyright year is the
%   current year as a default.  The organization is set to ORGANIZATION.
%
%   The copyright line that is built up looks like the following:
%
%         %   Copyright <YEAR> <ORGANIZATION>
%
%   For example:
%
%         %   Copyright 2003 The MathWorks, Inc.
%
%   The copyright info is place directly above the Revision line.
%   Specifically is it looking for the following substring:
%
%          %   $Revision
%
%   Where the comment character is placed in the first column.  If it
%   can't find the $Revision keyword (Typically this is right after the
%   help section of the M-file.  See this file as an example), it doesn't
%   know where to insert it.  When it is finished, it will look like the
%   following example:
%
%          %   Copyright 2003 The MathWorks, Inc.
%          %   $Revision...
%
%   ADDCOPYRIGHT(ORGANIZTIONS,FOLDER) adds the copyright info to all
%   M-files in the folder FOLDER and its subfolders.  The copyright year
%   is the current year as a default.  The organization is set to
%   ORGANIZATION.
%
%   ADDCOPYRIGHT(ORGANIZATION,FOLDER,COPYRIGHT_YEAR) adds the copyright
%   info to all M-files in the folder FOLDER and its subfolders.  If
%   FOLDER is [], the default value, the current folder (pwd), is used.
%   The copyright year is set to COPYRIGHT_YEAR.  COPYRIGHT_YEAR may
%   either be a character string (for example, '2003' or '2001-2003') or
%   a numeric.  The organization is set to ORGANIZATION.
%
%   ADDCOPYRIGHT(...,UPDATE) updates the copyright info if UPDATE is set
%   to true (false by default).  If FOLDER is [], the default value, the
%   current folder, is used.  If COPYRIGHT_YEAR is [], the default value,
%   the current year, is used.
%
%   When replacing the copyright info line, it looks for the following string:
%
%          %   Copyright
%
%   Where the comment character is placed in the first column.
%
%   ADDCOPYRIGHT([],FOLDER,[],UPDATE,COPYRIGHT_STRING) ignore the
%   organization and the copyright year to build up a copyright string
%   and use COPYRIGHT_STRING instead.
%
%   Examples:
%   ---------
%   % Supply just the organization name, starting from the current
%   % folder, and use the current year but don't overwrite it if the
%   % copyright info is already there.
%   addcopyright('My Organization')
%
%   % Supply the organization name starting from the "src" folder (found
%   % in the current folder), and use the current year but don't
%   % overwrite it if the copyright info is already there.
%   addcopyright('My Organization','src')
%
%   % Supply the organization name starting from the "src" folder (found
%   % in the current folder), and use the supplied year but don't
%   % overwrite it if the copyright info is already there.
%   addcopyright('My Organization','private',2001)
%   addcopyright('My Organization','src','2001-2003')
%
%   % Supply the organization name starting from the "src" folder (found
%   % in the current folder), and use the supplied year.  If the
%   % copyright info is already in the M-file, replace it with the new
%   % copyright line.
%   % overwrite it if the copyright info is already there.
%   addcopyright('My Organization','src',2004,true)
%
%   % Replace all instances of the copyright info or add it if it's not
%   % there.  Use the supplied copyright info.
%   addcopyright([],[],[],true, ...
%        'Copyright 1984-2003 MathWorks, makers of MATLAB(R)')

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.2 $ $Date: 2003/09/11 21:25:11 $

%   Author: Raymond Norris (rayn@mathworks.com)

% Parse input arguments
error(nargchk(1,5,nargin))

if nargin<4
    update = false;
end
if nargin<3
    copyright_year = num2str(datestr(date,10));
end
if nargin<2
    folder = pwd;
end

if isempty(folder)
    folder = pwd;
end

if isempty(copyright_year)
    copyright_year = datestr(date,10);
end

if isempty(update)
    update = false;
end

if isnumeric(copyright_year)
    copyright_year = num2str(copyright_year);
end

if nargin<5
    copyright_string = ['%   Copyright ' copyright_year ' ' organization];
else
    copyright_string = ['%   ' copyright_string];
end

dlist = dir(folder);

% Order the listing so that all of the files are first, then the subfolders.
idx = [dlist.isdir];
newdlist = [dlist(~idx); dlist(idx)];

for didx = 1:length(newdlist)
    token_name = newdlist(didx);
    if strcmp(token_name.name,'.') || strcmp(token_name.name,'..') || strcmp(token_name.name,'CVS')
        continue
    end

    if token_name.isdir==true
        addcopyright([folder filesep token_name.name],copyright_year);
        continue
    end

    if length(token_name.name)>2 && strcmp(token_name.name(end-1:end),'.m')
        lAddCopyrightInfo([folder filesep token_name.name],copyright_string,update)
    end
end

function lAddCopyrightInfo(fname,copyright_string,update)

fprintf(1,'Modifying file: %s...',fname)

fid_1 = fopen(fname,'r+');
if fid_1<3
    disp(['Failed to open ' fname ' for modifying.'])
    return
end

[dummy,file,ext] = fileparts(fname);
new_fname = ['new_' file ext];
fid_2 = fopen(new_fname,'w');
if fid_2<3
    disp(['Failed to open ' new_fname ' for writing to.'])
    fclose(fid_1)
    return
end

next_line   = [];
found_token = false;
token_already_embedded = false;
while isempty(next_line) | next_line~=-1
    next_line = fgetl(fid_1);
    if next_line==-1
        break
    elseif strncmp(next_line,'%   Copyright',13)
        token_already_embedded = true;
        found_token = true;
        if update==true
            fprintf(fid_2,'%s\n',copyright_string);
            continue
        end
    end

    if found_token==false
        if strncmp(next_line,'%   $Revision',13)
            fprintf(fid_2,'%s\n',copyright_string);
            found_token = true;
        end
    end
    fprintf(fid_2,'%s\n',next_line);
end

fclose(fid_1);
fclose(fid_2);

if found_token==false
    disp('Could not find Revision token.  Copyright info will NOT be added to the file.')
    delete(new_fname)
elseif token_already_embedded==true && update==false
    disp('Copyright info was found in the file.')
    delete(new_fname)
else
    disp('Done.')
    movefile(new_fname,fname)
end
