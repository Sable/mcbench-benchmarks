function makeinstall(varargin)
% MAKEINSTALL   creates a toolbox installation file.
%   Use MAKEINSTALL to create a INSTALL.M file, which
%   will include a simple installation script and all the
%   Matlab files which are needed for the toolbox. If the
%   CONTENTS.M file is missing, it will be automatically 
%   created. Furthermore the command TBCLEAN will be added to 
%   the toolbox folder, which enables to remove the toolbox 
%   folder and the startup entries.
%
%   Call MAKEINSTALL in the toolbox folder or specify this
%   folder with MAKEINSTALL TB-FOLDER.
%
%   In order to initialize some needed variables, call this
%   programme the first time and then modify the entries in 
%   the automatically created resource file MAKEINSTALL.RC.
%   You may change the entries in MAKEINSTALL.RC for your
%   convenience. 
%
%   Please note, that further files will be automatically 
%   generated in the toolbox folder if they do not exist yet: 
%   CONTENTS.M, INFO.XML and TBCLEAN.M.
%
%   The contents of CONTENTS.M will be generated from the help
%   lines in the M-files. If there are no help lines or if 
%   this help text is not correctly placed, a warning message 
%   will occur. Please ensure that the help text corresponds 
%   with the predefined structure of M-files:
%
%       function p = angle(h)
%       % ANGLE Polar angle.
%       %   ANGLE(H) returns the phase angles, in radians, of
%       %   a matrix with complex elements. Use ABS for the 
%       %   magnitudes.
%       p = atan2(imag(h),real(h));
%
%   where there is a first help line (H1) below the function 
%   line and a following help text. The H1 line is used also 
%   by other functions like LOOKFOR. If you like to generate 
%   CONTENTS.M automatically with MAKEINSTALL although 
%   CONTENTS.M already exists, you have to remove the old 
%   CONTENTS.M file. Thus, manual modifications will be kept.
%
%   The contents of INFO.XML can be modified with some 
%   variables in the resource file MAKEINSTALL.RC. However, 
%   you have to remove the old INFO.XML file, if you like to 
%   modify it the next time with MAKEINSTALL. Thus, manual 
%   modifications will be preserved.
%
%   This programme is free software under the BSD License.  
%   To view the text of this license, type
%   MAKEINSTALL BSD.

% Copyright (c) 2008-2012
% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 2002-2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
% 
%     * Redistributions of source code must retain the above
%       copyright notice, this list of conditions and the following
%       disclaimer.
%     * Redistributions in binary form must reproduce the above
%       copyright notice, this list of conditions and the following
%       disclaimer in the documentation and/or other materials provided
%       with the distribution.
%     * All advertising materials mentioning features or use of this 
%       software must display the following acknowledgement:
%       This product includes software developed by the University of
%       Potsdam, Germany, the Potsdam Institute for Climate Impact
%       Research (PIK), and its contributors.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
% CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
% BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS
%
% I'm grateful for every suggestion and hint which improves this
% programme. Thanks to Gaetan Koers of Vrije Universiteit Brussel
% for hints about Windows compatibility and improvement the help-text
% parser. Thanks also to Volkmar Glauche of University of Hamburg 
% (Universitatsklinikum) and Eduard vander Zwan (Wageningen 
% Universiteit) for usefule hints and comments about the
% root-folder of the toolbox and the startup.m entries.
%
% $Date: 2013/09/05 15:43:02 $
% $Revision: 3.23 $
%
% $Log: makeinstall.m,v $
% Revision 3.23  2013/09/05 15:43:02  marwan
% isoctave bug in deinstall script fixed
%
% Revision 3.22  2013/09/02 07:33:02  marwan
% octave compatibility for windows added
%
% Revision 3.21  2013/08/30 17:42:52  marwan
% added octave compatibility (default path and .octaverc support)
%
% Revision 3.20  2012/04/07 12:47:22  marwan
% changed to BSD license
% added errorcode during deleting old toolbox
% changed toolbox location from general Matlab folder to user's matlab folder in Windows
%
% Revision 3.19  2009/06/12 07:50:23  marwan
% change from GPL to BSD License
%
% Revision 3.18  2009/03/24 09:19:58  marwan
% updated contact data and copyright address
%
% Revision 3.17  2008/02/25 12:32:53  marwan
% fixed checksum error on 64bit machines
%
% Revision 3.16  2006/11/07 07:55:43  marwan
% several bug fixes and upwards compatibility
%
% Revision 3.15  2006/10/30 17:32:21  marwan
% include subdirectories support
%
% Revision 3.14  2006/07/03 08:04:36  marwan
% Checksum error bug in Matlab 2006a solved
%
% Revision 3.13  2006/03/17 08:31:01  marwan
% code optimised and flattened
%
% Revision 3.12  2006/02/07 13:45:11  marwan
% pcode bug resolved (R14 incompatibility)
%
% Revision 3.11  2005/08/23 07:21:21  marwan
% fixed downwards compatibility of mfilename command
%
% Revision 3.10  2005/05/20 09:56:14  marwan
% bug in relative-to-absolute-path conversion fixed
% confusing of DOS and Unix fileseparators resolved
% bug due to DOS line end (CR instead of LF) resolved
% bug due to Makeinstall self packaging resolved (Makeinstall.m now excluded)
%
% Revision 3.9  2005/04/08 11:17:07  marwan
% comment combination (for container) changed
% small bugfixes, suggested by Gaetan Koers
%
% Revision 3.8  2005/02/22 12:27:14  marwan
% windoof bug fixed (ocurred during removing of old toolbox)
%
% Revision 3.7  2004/11/15 10:09:49  marwan
% change addpath -end to addpath -begin
%
% Revision 3.6  2004/11/10 07:52:15  marwan
% CVS compatibility included
%
% Revision 3.5  2004/11/10 06:29:16  marwan
% Initial commitment
%
%

% initialization some variables
error(nargchk(0,1,nargin));
olddir = pwd;
toolbox_name = ''; install_file = ''; install_path = ''; deinstall_file = ''; src_dir = ''; 
install_dirPC = ''; install_dirUNIX = ''; version_file = ''; version_number = ''; release = ''; 
infostring = ''; old_dirs = ''; xml_name = ''; xml_start = ''; xml_demo = ''; xml_web = ''; restart = 0;
count_warnings = 0;
max_warnings = 10; % more warnings than this number will be suppressed - feel free to change this number

% read the resource file
if nargin == 1
    if exist(char(varargin{1}),'dir') == 7
        src_dir = varargin{1};
        cd(src_dir); 
        disp(['   Change to directory ', src_dir,''])
    else
        toolbox_name = varargin{1};
    end
elseif nargin == 2
    if exist(char(varargin{2}),'dir') == 7
        src_dir = varargin{2};
        cd(src_dir); 
        disp(['   Change to directory ', src_dir,''])
    end
    toolbox_name = varargin{1};
end

% get version number of the makeinstall-script
mi_file = which(mfilename);
mi_version = 'none';
fid = fopen(mi_file,'r');
if fid ~= -1
    while 1
        temp = fgetl(fid);
        if ~ischar(temp), break
        elseif ~isempty(temp)
            if temp(1) == '%'
                i = findstr(temp,'Version:');
                if ~isempty(i), mi_version = temp(i(1)+9:end); break, end
                i = findstr(temp,'$Revision:');
                if ~isempty(i), mi_version = strtok(temp(i(1)+11:end),'$'); break, end
            end
        end
    end
    fclose(fid);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% splash the BSD License

filename = 'makeinstall';

txt = {'';'BSD LICENSE';
'';'Copyright (c) 2008-2012';
'Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany';
'http://www.pik-potsdam.de';
'';
'Copyright (c) 2002-2008';
'Norbert Marwan, Potsdam University, Germany';
'http://www.agnld.uni-potsdam.de';
'';
'All rights reserved.';
'';
'Redistribution and use in source and binary forms, with or without';
'modification, are permitted provided that the following conditions';
'are met:';
'';
'    * Redistributions of source code must retain the above';
'      copyright notice, this list of conditions and the following';
'      disclaimer.';
'    * Redistributions in binary form must reproduce the above';
'      copyright notice, this list of conditions and the following';
'      disclaimer in the documentation and/or other materials provided';
'      with the distribution.';
'    * All advertising materials mentioning features or use of this ';
'      software must display the following acknowledgement:';
'      This product includes software developed by the University of';
'      Potsdam, Germany, the Potsdam Institute for Climate Impact';
'      Research (PIK), and its contributors.';
'';
'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND';
'CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,';
'INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF';
'MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE';
'DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS';
'BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,';
'EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED';
'TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,';
'DATA, OR PROFITS; OR BUSINESS'
};


which_res = which([filename,'.m']);
bsdrc_path = [strrep(which_res,[filename,'.m'],''), 'private'];
bsdrc_file = [bsdrc_path, filesep, '.bsd.',filename];
if ~exist(bsdrc_path,'dir')
    mkdir(strrep(which_res,[filename,'.m'],''),'private')
end
if ~exist(bsdrc_file,'file') | strcmpi(varargin,'bsd')
    if ~exist(bsdrc_file,'file') 
        disp('First click on the license to accept them.')
    else
        disp('Click on the license to close them.')
    end
    fid = fopen(bsdrc_file,'w');
    fprintf(fid,'%s\n','If you delete this file, the BSD License will');
    fprintf(fid,'%s','splash up at the next time the programme starts.');
    fclose(fid);

    h = figure('NumberTitle','off',...,
            'ButtonDownFcn','close',...
            'Name','BSD License');
    ha = get(h,'Position');
    h = uicontrol('Style','Listbox',...
            'ButtonDownFcn','close',...
            'CallBack','close',...
            'Position',[0 0 ha(3) ha(4)],...
            'Value',1,...
            'FontName','Courier',...
            'BackgroundColor',[.8 .8 .8],...
            'String',txt);
    waitfor(h)
end

if isempty(varargin) | ~strcmpi(varargin,'bsd') % create install file if not the 'bsd' is called
    files = what;
    if isempty(files.m)
        warning on; warning('No M-files found in this directory.'); 
    end

    rc_file = fullfile(pwd,'makeinstall.rc');
    time_string = datestr(now);

    fid = fopen(rc_file,'r');
    if fid > 0 % begin main part
        disp('   Reading the resource file')
        while 1
            l = fgetl(fid);
            if ~ischar(l), break, end
            if ~isempty(l), eval(l); end
        end
        fclose(fid);

        if isempty(toolbox_name), [dummy toolbox_name] = fileparts(pwd); end
        if isempty(install_file), install_file = 'install.m'; end
        if isempty(deinstall_file), deinstall_file = 'tbclean.m'; end
        if isempty(src_dir), src_dir = pwd; end
        if isempty(install_dirPC), install_dirPC = pwd; end
        if isempty(install_dirUNIX), install_dirUNIX = install_dirPC; end
        if isempty(version_number), version_number = 'none'; end
        if isempty(release), release = ' '; end
        %  if isempty(infostring), infostring = ''; end
        old_dirs = lower(old_dirs);
        if ~iscell(old_dirs), old_dirs = cellstr(old_dirs); end
        check_for_old = '[findstr([lower(toolboxpath),''demo''],lower(p))';
        check_for_old = [check_for_old,' findstr(lower(toolboxpath),lower(p))'];
        for i = 1:length(old_dirs)
            check_for_old = [check_for_old,' findstr(''',old_dirs{i},''',lower(p))'];
        end
        check_for_old = [check_for_old,']'];


        % make install file
        disp('   Reading the install source code')
        fid = fopen(mi_file, 'r'); warning off
        i = 1; flag = 0;
        while 1
            temp = fgetl(fid);
            if ~ischar(temp), break, end
            if length(temp) > 1
                if strcmpi(temp,'%<-- ASCII begins here: install -->')
	                eofbyte = ftell(fid);
	                flag = 1;
                elseif strcmpi(temp,'%<-- ASCII begins here: clean -->')
	                eofbyte = ftell(fid)-eofbyte-1000;
	                flag = 2;
                elseif strcmpi(temp,'%<-- ASCII ends here -->')
	                flag = 0; i = 1;
                end

                if findstr(temp(1:2),'%@') == 1
                    aline = repmat('-',1,length(toolbox_name)+17);
                    switch flag
                    case 1
                         % read install part
                         temp = strrep(temp,13,''); % remove the CR end of a line (if DOS style)
                         b(i,1) = {temp(3:end)};
	                     b(i) = strrep(b(i),'$lines$',aline);
	                     b(i) = strrep(b(i),'$installpath$',install_path);
	                     b(i) = strrep(b(i),'$toolboxdirpc$',install_dirPC);
	                     b(i) = strrep(b(i),'$toolboxdirunix$',install_dirUNIX);
	                     b(i) = strrep(b(i),'$toolboxname$',toolbox_name);
	                     b(i) = strrep(b(i),'$generation_date$',time_string);
	                     b(i) = strrep(b(i),'$check_for_old$',check_for_old);
	                     b(i) = strrep(b(i),'$mi_version$',mi_version);
	                     if isempty(infostring)
	                        b(i) = strrep(b(i),'$infostring$','');
	                     else
	                        b(i) = strrep(b(i),'$infostring$',['disp(''',infostring,''')']);
	                     end
                    case 2
                         % read uninstall part
                         temp = strrep(temp,13,''); % remove the CR end of a line (if DOS style)
                         c(i,1) = {temp(3:end)};
	                     c(i) = strrep(c(i),'$lines$',aline);
	                     c(i) = strrep(c(i),'$toolboxdir$',install_dirPC);
	                     c(i) = strrep(c(i),'$toolboxname$',toolbox_name);
	                     c(i) = strrep(c(i),'$deinstall_file$',strtok(deinstall_file,'.'));
	                     c(i) = strrep(c(i),'$deinstall_file_up$',strtok(upper(deinstall_file),'.'));
	                     c(i) = strrep(c(i),'$generation_date$',time_string);
                    end
                    i = i+1;
                end
            end
        end
        fclose(fid);

        if exist(fullfile(olddir,'install.m'),'file'), delete(fullfile(olddir,'install.m')); end
        fid = fopen(fullfile(olddir,install_file),'w');
        startbyte = eofbyte;
        for i2 = 1:length(b), b(i2) = strrep(b(i2),'$startbyte$',num2str(startbyte-1000)); fprintf(fid,'%s\n',char(b(i2))); end
        fclose(fid);

        disp(['   Source directory ', src_dir,''])
        if ~exist(src_dir,'dir'), error('Predefined source directory is nonexistent. Check the resource file.'), end
        cd(src_dir)

        % make clean file
        %  if ~exist(deinstall_file)
        disp(['   Create ', deinstall_file,''])
        fid = fopen(deinstall_file,'w');
        for i2 = 1:length(c), fprintf(fid,'%s\n',char(c(i2))); end
        fclose(fid);
        %  end

        % get version number
        fid = fopen(version_file,'r');
        if fid ~= -1
            while 1
                temp = fgetl(fid);
                if ~ischar(temp), break
                elseif ~isempty(temp)
                    if temp(1) == '%'
                        i = findstr(temp,'Version:');
                        if ~isempty(i), version_number = temp(i(1)+9:end); break, end
                        i = findstr(temp,'$Revision:');
                        if ~isempty(i), version_number = strtok(temp(i(1)+11:end),'$'); break, end
                    end
                end
            end
            fclose(fid);
        end
        if strcmpi(version_number,'none')
            if max_warnings & count_warnings == max_warnings
                disp('   ** TOO MUCH WARNINGS!') 
                disp('   I give up! Following warning messages will be suppressed.') 
            end
            if count_warnings < max_warnings
                disp('   ** Warning: No version number found!') 
                disp('   Please provide a version file or number in the makeinstall.rc file.')
            end
            count_warnings = count_warnings + 1;
        else
            disp(['   Found version number ', version_number,''])
        end
        if ~strcmpi(release,' ') & ~isempty(release)
            disp(['   Found release ', release,''])
        end
        if ~isempty(infostring)
            if length(infostring)>40, txt = [infostring(1:37),'...']; else txt = infostring; end
            disp(['   Found infotext ''', txt,''''])
        end
        disp(['   Time stamp ', time_string,''])

        % make launch pad file
        if ~exist(fullfile(src_dir,'info.xml'),'file') & ~isempty(xml_name) 
            disp('   Create info.xml')
            files.m(strcmpi(files.m,'info.xml')) = [];
            files.m(strcmpi(files.m,install_file)) = [];
            v = version;
            mrelease = str2double(v(findstr(v,'(R')+2:findstr(v,')')-1));
            if mrelease>12, area = 'toolbox'; icon_path = '$toolbox/matlab/icons'; else area = 'matlab'; icon_path = '$toolbox/matlab/general'; end
            fid = fopen('info.xml','w'); 
            fprintf(fid,'%s\n','<productinfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.mathworks.com/namespace/info/v1/info.xsd">');
            fprintf(fid,'%s\n\n','<?xml-stylesheet type="text/xsl" href="http://www.mathworks.com/namespace/info/v1/info.xsd"?>');
            fprintf(fid,'%s\n',['<matlabrelease>',num2str(mrelease),'</matlabrelease>']);
            fprintf(fid,'%s\n',['<name>',xml_name,'</name>']);
            fprintf(fid,'%s\n',['<type>',area,'</type>']);
            fprintf(fid,'%s\n\n',['<icon>',icon_path,'/matlabicon.gif</icon>']);
            fprintf(fid,'%s\n\n','<list>');
            if ~isempty(xml_start)
                fprintf(fid,'%s\n','<listitem>');
                fprintf(fid,'%s\n',['<label>Start ',toolbox_name,'</label>']);
                fprintf(fid,'%s\n',['<callback>',xml_start,'</callback>']);
                fprintf(fid,'%s\n',['<icon>',icon_path,'/figureicon.gif</icon>']);
                fprintf(fid,'%s\n\n','</listitem>');
            end
            fprintf(fid,'%s\n','<listitem>');
            fprintf(fid,'%s\n','<label>Help</label>');
            if isunix
                fprintf(fid,'%s\n',['<callback>helpwin ',install_dirUNIX,'/</callback>']);
            else
                fprintf(fid,'%s\n',['<callback>helpwin ',install_dirPC,'/</callback>']);
            end
            fprintf(fid,'%s\n',['<icon>',icon_path,'/bookicon.gif</icon>']);
            fprintf(fid,'%s\n\n','</listitem>');
            if ~isempty(xml_demo)
                fprintf(fid,'%s\n','<listitem>');
                fprintf(fid,'%s\n','<label>Demo</label>');
                fprintf(fid,'%s\n',['<callback>',xml_demo,'</callback>']);
                fprintf(fid,'%s\n',['<icon>',icon_path,'/demoicon.gif</icon>']);
                fprintf(fid,'%s\n\n','</listitem>');
            end
            if ~isempty(xml_web)
                fprintf(fid,'%s\n','<listitem>');
                fprintf(fid,'%s\n','<label>Product Page (Web)</label>');
                fprintf(fid,'%s\n',['<callback>web ',xml_web,' -browser;</callback>']);
                fprintf(fid,'%s\n',['<icon>',icon_path,'/webicon.gif</icon>']);
                fprintf(fid,'%s\n\n','</listitem>');
            end
            fprintf(fid,'%s\n\n','</list>');
            fprintf(fid,'%s','</productinfo>');
            fclose(fid);
        end

        % make contents file
        if ~exist(fullfile(src_dir,'Contents.m'),'file')
            disp('   Create Contents.m')
            files.m(strcmpi(files.m,'Contents.m')) = [];
            files.m(strcmpi(files.m,install_file)) = [];
            fid = fopen('Contents.m','w'); 
            fprintf(fid,'%s\n',['% ',toolbox_name]);
            fprintf(fid,'%s\n',['% Version ',num2str(version_number),'   ',date]);
            fprintf(fid,'%s\n','%');
            for i = 1:length(files.m)
                helptext = help(char(files.m{i}));
                ind = findstr(char(10),helptext);
                if isempty(ind)
                    if max_warnings & count_warnings == max_warnings
                        disp('   ** TOO MUCH WARNINGS!') 
                        disp('   I give up! Following warning messages will be suppressed.') 
                    end
                    if count_warnings < max_warnings
                        disp(['   ** Warning: ',char(files.m{i}),' does not contain any helptext. It is highly',char(10),'   recommended to include a helptext in every M-file.'])
                    end
                    count_warnings = count_warnings + 1;
                else
                    helpline = deblank(helptext(1:ind(1)));
                    [fnname,helpstring] = strtok(helpline(2:length(helpline)));
                    fnname = fliplr(deblank(fliplr(fnname)));
                    if ~strcmpi(fnname,strtok(char(files.m{i}),'.'))
                        if max_warnings & count_warnings == max_warnings
                            disp('   ** TOO MUCH WARNINGS!') 
                            disp('   I give up! Following warning messages will be suppressed.') 
                        end
                        if count_warnings < max_warnings
                            disp(['   ** Warning: ',char(files.m{i}),' does not have a valid helptext. Please refer ',char(10),'   the Matlab manual for the correct structure of M-files.'])
                        end
                        count_warnings = count_warnings + 1;
                        fnname = lower(strtok(char(files.m{i}),'.'));
                    end
                    line = [lower(fnname),blanks(size(char(files.m),2)-length(fnname)-1),'- ',helpstring];
                    fprintf(fid,'%s\n',['%    ', line]);
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % this part was suggested by Gaetan Koers (Vrije Universiteit Brussel)
            for i = 1:numel(files.classes)
                line = [files.classes{i}, ' methods:'];
                fprintf(fid,'%%\n%s\n%%\n',['%    ', line]);
                gk_list = dir(['@', files.classes{i}]);
                for j = 1:numel(gk_list)
                    gk_fname = gk_list(j).name;
                    if ~gk_list(j).isdir %~strcmp(gk_fname, '.') & ~strcmp(gk_fname, '..')
                        helptext = help(fullfile(files.classes{i},gk_fname));
                        ind = findstr(char(10),helptext);
                        if isempty(ind)
                            if max_warnings & count_warnings == max_warnings
                                disp('   ** TOO MUCH WARNINGS!') 
                                disp('   I give up! Following warning messages will be suppressed.') 
                            end
                            if count_warnings < max_warnings
                                disp(['   ** Warning: ', files.classes{i}, ' method ', char(gk_fname),' does not contain any helptext. It is highly',char(10),'   recommended to include a helptext in every M-file.'])
                            end
                            count_warnings = count_warnings + 1;
                        else
                            helpline = deblank(helptext(1:ind(1)));
                            [fnname,helpstring] = strtok(helpline(2:length(helpline)));
                            fnname = fliplr(deblank(fliplr(fnname)));
                            if ~strcmpi(fnname,strtok(char(gk_fname),'.'))
                                if max_warnings & count_warnings == max_warnings
                                    disp('   ** TOO MUCH WARNINGS!') 
                                    disp('   I give up! Following warning messages will be suppressed.') 
                                end
                                if count_warnings < max_warnings
                                    disp(['   ** Warning: ', files.classes{i}, ' method ',char(gk_fname),' does not have a valid helptext. Please refer ',char(10),'   the Matlab manual for the correct structure of M-files.'])
                                end
                                count_warnings = count_warnings + 1;
                                fnname = lower(strtok(char(gk_fname),'.'));
                            end
                            line = [lower(fnname),blanks(size(char(files.m),2)-length(fnname)-1),'- ',helpstring];
                            fprintf(fid,'%s\n',['%    ', line]);
                        end
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fprintf(fid,'\n%s\n\n',['% Generated at ',time_string,' by MAKEINSTALL']);
            fclose(fid);
        else
            % modify contents file
            disp('   Modify Contents.m')
            fid = fopen('Contents.m','r'); contents = ''; 
            while 1
                temp = fgetl(fid);
                if ~ischar(temp), break, end
                contents = [contents;{temp}];
            end
            fclose(fid);

            if length(contents) > 1 & isempty(findstr(lower(contents{2}),'version'))
                contents(3:end+1) = contents(2:end);
            end
            if ~strcmp(release,' ') & ~isempty(release), release = [' (',release,') ']; end
            contents{2} = ['% Version ',version_number,release,date];
            if (isempty(contents{end}) | findstr(contents{end},'Modified at')>0); l = length(contents); else l = length(contents)+1; end
            contents{l} = ['% Modified at ',time_string,' by MAKEINSTALL'];

            fid = fopen('Contents.m','w'); 
            for i = 1:length(contents)
                fprintf(fid,'%s\n',contents{i});
            end
            fclose(fid);
        end


        % find sub-directories
        dirnames = ''; filenames = '';
        temp = '.:';
        while ~isempty(temp)
            [temp1 temp] = strtok(temp,':');
            if ~isempty(temp1)
                dirnames = [dirnames; {temp1}];
                temp2 = strrep(temp1,'./','');
                if isempty(findstr(lower(fliplr(temp2(end-min([3,length(temp2)])+1:end))), 'svc'))
                    x2 = dir(temp1);
                    for i = 1:length(x2)
                        if ~x2(i).isdir, filenames = [filenames; {[temp1,'/', x2(i).name]}]; end
                        if x2(i).isdir & ~strcmp(x2(i).name,'.') & ~strcmp(x2(i).name,'..'), temp = [temp,temp1,filesep,x2(i).name,':']; end
                    end
                end
            end
        end
        dirnames = strrep(dirnames,filesep,'/');
        dirnames = strrep(dirnames,'./','');
        filenames = strrep(filenames,filesep,'/');
        filenames = strrep(filenames,'./','');

        % ignore CVS folders
        remove = [];
        for i = 1:length(dirnames)
            test_string = fliplr(dirnames{i});
            if strcmpi(test_string(1:min([3,length(test_string)])),fliplr('CVS')), remove = [remove; i]; end
        end
        dirnames(remove) = [];


        % ignore makeinstall.rc, makeinstall.m and .cvsignore
        i = 1;
        while i <= length(filenames)
            if strncmpi('p.',fliplr(filenames{i}),2), filenames(i) = []; i = i-1; end
            if strcmpi('makeinstall.rc',filenames{i}), filenames(i) = []; i = i-1; end
            if strcmpi('makeinstall.m',filenames{i}), filenames(i) = []; i = i-1; end
            if strcmpi('.cvsignore',filenames{i}), filenames(i) = []; i = i-1; end
            i = i+1;
        end

        % read the toolbox files 
        i = 0;

        while i <= length(filenames), 
            i = i+1;
            if i>length(filenames), break, end
            if strcmp(filenames{i},'.') | strcmp(filenames{i},'..') | strcmpi(filenames{i},install_file) | strcmpi(filenames{i},'install.m') | strncmpi(filenames{i},'private/.bsd',12)
                filenames(i) = []; i = i-1;
            end
        end

        b = []; c = []; bfile = '';
        for i = 1:length(filenames),
            disp(['   Reading ', char(filenames{i}),''])
            fid = fopen(char(filenames{i}),'r');

            % ASCII data
            if ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'txt') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'xet') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'m') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'cr') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'lmx') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'lmth') | ...
                strcmpi(lower(strtok(fliplr(filenames{i}),'.')),'mth')

                c = [c, ['%<-- ASCII begins here: __',char(filenames{i}),'__ -->'], 10];
                in = char(fread(fid)');
                in = strrep(in,char(10),[char(10),'%@']);
                %      while 1
                %         temp = fgetl(fid);
                %         if ~ischar(temp), break
                %         else
                c = [c, ['%@',in],10];
                %         end
                %      end
                c = [c, '%<-- ASCII ends here -->', 10];

                % binary data
            else
                clear temp
                bfile = [bfile; filenames(i)];
                temp_in = fread(fid);
                if ~isempty(temp_in)
                    temp(2,:) = temp_in'; 
                end
                temp(1,:) = '%';
                temp = temp(:);
                btemp = temp';
                b = [b, ['%<-- Binary begins here: __',char(filenames(i)),'__ __',num2str(length(btemp)),'__ -->',10]];
                b = [b, btemp, 10];
                b = [b, ['%<-- Binary ends here -->',10]];
            end

            fclose(fid);

        end

        % compute a checksum
        c = double([c, b]);
        checksum = dec2hex(sum((1:length(c)).*c));
        disp(['   Checksum is ', checksum,''])

        % write the archiv into the install file
        disp(['   Writing ', install_file,''])
        fid = fopen(fullfile(olddir,install_file),'a');
        fprintf(fid,'%s\n','% -------------------------------------------');
        fprintf(fid,'%s\n','% GENERATED ENTRIES - DO NOT MODIFY ANYTHING!');
        fprintf(fid,'%s\n','%<-- Header begins here -->');
        fprintf(fid,'%s\n',['%@',checksum]);
        fprintf(fid,'%s\n',['%@',time_string]);
        fprintf(fid,'%s\n',['%@',version_number, release]);
        fprintf(fid,'%s\n','%<-- Header ends here -->');
        fwrite(fid,c); 
        fclose(fid);

        cd(olddir)
        

    else
        % make makeinstall.rc file
        if isempty(toolbox_name), [dummy toolbox_name] = fileparts(pwd); end
        fid = fopen(rc_file,'w');
        if fid ~= -1
            warning on
            disp('   ** Warning: Could not find the makeinstall resource file.')
            disp('   Creating now the makeinstall resource file.')
            disp('   Please modify the entries in ')
            disp(['     ',rc_file])
            disp('   and restart if you would like to use other than the default')
            disp('   settings. Now automatically restart with default settings.')
            fprintf(fid,'%s\n\n','% modify the following lines for your purpose');
            fprintf(fid,'%s\n\n',['toolbox_name=''',toolbox_name,''';          % name of the toolbox']);
            fprintf(fid,'%s\n','install_file=''install.m'';             % name of the install script');
            fprintf(fid,'%s\n','deinstall_file=''tbclean.m'';           % name of the deinstall script');
            fprintf(fid,'%s\n','old_dirs='''';                          % possible old (obsolete) toolbox folders');
            fprintf(fid,'%s\n','install_path='''';                      % the root folder where the toolbox folder will be located (default is $USER$/matlab or $MATLABROOT$/toolbox, or $USERS$/octave when installing for Octave)');
            fprintf(fid,'%s\n',['install_dirUNIX=''',toolbox_name,''';   % the folder where the toolbox files will be extracted (UNIX)']);
            fprintf(fid,'%s\n','install_dirPC=install_dirUNIX;          % the folder where the toolbox files will be extracted (PC)');
            fprintf(fid,'%s\n\n',['src_dir=''',pwd,'''; % folder with the origin toolbox']);
            fprintf(fid,'%s\n','version_file='''';                      % include in this file a line like this: % $Revision: 3.23 $');
            fprintf(fid,'%s\n','version_number='''';                    % or put the version number in this variable');
            fprintf(fid,'%s\n','release='''';                           % the release number');
            fprintf(fid,'%s\n\n','infostring='''';                        % further information displayed during installation');
            fprintf(fid,'%s\n','% if the info.xml does not yet exist it will be created with the following');
            fprintf(fid,'%s\n','% parameters; else these parameters have no effect');
            fprintf(fid,'%s\n',['xml_name=''',toolbox_name,''';                          % name of the toolbox for the launch pad entry']);
            fprintf(fid,'%s\n','xml_start='''';                         % start programme for the launch pad entry');
            fprintf(fid,'%s\n','xml_demo='''';                          % demo programme for the launch pad entry');
            fprintf(fid,'%s\n','xml_web='''';                           % link to the toolbox web site in the launch pad entry');
            fclose(fid);
            restart = 1;
        else
            disp('Sorry. A problem during file system access occurred.')
            error('Could not open the makeinstall resource file.')
        end
        cd(olddir)
    end % end main part
end % end check 'bsd'
warning on

if restart, makeinstall(varargin{:}), end

% --------------------------------
% GENERATED ENTRIES - DO NOT EDIT!
%<-- ASCII begins here: install -->
%@function install(varargin)
%@% INSTALL   Install script for $toolboxname$.
%@%    INSTALL creates the $toolboxname$ folder and (optionally) 
%@%    the needed entries in the startup.m file.
%@% 
%@%    INSTALL PATH creates the $toolboxname$ folder 
%@%    in the specified PATH.
%@%    
%@%    This installation script was generated by using 
%@%    the MAKEINSTALL tool. For further information
%@%    visit http://matlab.pucicu.de
%@
%@% Copyright (c) 2008-2012
%@% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
%@% http://www.pik-potsdam.de
%@%
%@% Copyright (c) 2001-2008
%@% Norbert Marwan, Potsdam University, Germany
%@% http://www.agnld.uni-potsdam.de
%@%
%@% THIS IS A GENERATED INSTALL-FILE, DO NOT EDIT!
%@% Generation date: $generation_date$
%@% $Date: 2013/09/05 15:43:02 $
%@% $Revision: 3.23 $
%@
%@install_file='';install_path='$installpath$';installfile_info.date='';installfile_info.bytes=[];
%@time_stamp='';checksum='';checksum_file=''; instpaths = '';
%@errcode=0;
%@
%@try
%@  warning('off')
%@  if isoctave
%@     disp(['  You are trying to install the toolbox in Octave.',10,'  Some compatibility issues might appear.'])
%@     warning('off','Octave:possible-matlab-short-circuit-operator')
%@     more off
%@  end
%@  if nargin
%@    install_path = varargin{1};
%@  end
%@
%@  if exist('install.log','file') == 2, delete('install.log'), end
%@  %rehash
%@  disp('$lines$')
%@  disp('  INSTALLATION $toolboxname$');
%@  disp('$lines$')
%@  install_file=[mfilename,'.m'];
%@  currentpath=pwd; time_stamp='time_stamp not yet obtained'; checksum='checksum not yet obtained';
%@  
%@%%%%%%% read the archive
%@%%%%%%% and look for checksum and date in archive
%@  errcode=90;
%@  disp('  Reading the archiv ')
%@  fid=fopen(install_file,'r'); 
%@  fseek(fid,0,'eof'); eofbyte=ftell(fid);
%@  fseek(fid,$startbyte$,'bof'); % location where the container starts
%@  while 1
%@     temp=fgetl(fid);
%@     startbyte=ftell(fid);
%@     if length(temp)>1
%@       if strcmpi(temp,'%<-- Header begins here -->')
%@          errcode=90.1;
%@          checksum=fgetl(fid);
%@          temp1=fgetl(fid);
%@          temp2=fgetl(fid);
%@       end
%@       if strcmpi(temp,'%<-- Header ends here -->')
%@          startbyte=ftell(fid);
%@          break
%@       end
%@     end
%@  end
%@  checksum(1:2)=[];
%@  fseek(fid,startbyte,'bof');
%@  errcode=90.2;
%@  A=fread(fid,eofbyte);
%@  errcode=90.3;
%@  checksum_file=dec2hex(sum((1:length(A))'.*A));
%@  if ~strcmpi(checksum_file,checksum)
%@    error(['The installation file is corrupt!',10,'Ensure that the archive container was ',...
%@           'not modified (check FTP/ ',10,'proxy/ firewall settings, anti-virus scanner for emails etc.)!'])
%@  else
%@    disp(['  Checksum test passed (', checksum,')'])
%@  end
%@  fclose(fid);
%@
%@  disp(['  $toolboxname$ version ', temp2(3:end),''])
%@  time_stamp=temp1(3:end); disp(['  $toolboxname$ time stamp ', time_stamp,'']); 
%@  
%@  errcode=91;
%@  if isunix
%@    toolboxpath='$toolboxdirunix$';
%@  else
%@    toolboxpath='$toolboxdirpc$';
%@  end
%@  
%@  
%@%%%%%%% check for older versions
%@  
%@  p=path; i1=0;
%@  rem_old = '';
%@  
%@  while any($check_for_old$>i1) & ~strcmpi('N',rem_old)
%@    errcode=92;
%@    i1=$check_for_old$;
%@    if ~isempty(i1)
%@      i1=i1(1);
%@      if isunix, i2=findstr(':',p); else i2=findstr(';',p); end
%@      i3=i2(i2>i1);                 % last index pathname
%@      if ~isempty(i3), i3=i3(1)-1; else i3=length(p); end
%@      i4=i2(i2<i1);                 % first index pathname
%@      if ~isempty(i4), i4=i4(end)+1; else i4=1; end
%@      oldtoolboxpath=p(i4:i3);
%@      if isempty(rem_old)
%@          disp(['  Old $toolboxname$ found in ', oldtoolboxpath,''])
%@          rem_old = input('> Delete old toolbox? Y/N [Y]: ','s');
%@      end
%@      if isempty(rem_old), rem_old = 'Y'; end
%@      if strcmpi('Y',rem_old)
%@%%%%%%% removing old entries in startup-file
%@        errcode=94;
%@        rmpath(oldtoolboxpath)
%@        if i4>1, p(i4-1:i3)=''; else p(i4:i3)=''; end
%@        startup_exist = exist('startup','file');
%@        if isoctave startup_exist = exist('~/.octaverc','file'); end
%@        if startup_exist
%@             startupfile=which('startup');
%@             startuppath=startupfile(1:findstr('startup.m',startupfile)-1);
%@             if isoctave
%@                startuppath = '~/';
%@                startupfile = '~/.octaverc';
%@             end
%@             errcode=94.1;
%@             if ~isunix
%@               if isoctave
%@                   toolboxroot=fullfile(matlabroot);
%@               else
%@                   toolboxroot=fullfile(matlabroot,'toolbox');
%@               end
%@               curr_pwd = pwd; home_pwd = matlabroot; 
%@             else
%@               toolboxroot=startuppath;
%@               curr_pwd = pwd; cd ('~'); home_pwd = pwd; cd(curr_pwd);
%@             end
%@             fid = fopen(startupfile,'r');
%@             k = 1;
%@             while 1
%@                 tmp = fgetl(fid);
%@                 if ~ischar(tmp), break, end
%@                 instpaths{k} = tmp;
%@                 k = k + 1;
%@             end
%@             fclose(fid);
%@             k=1;
%@             while k <= length(instpaths)
%@               if findstr(oldtoolboxpath,strrep(instpaths{k},'~',home_pwd))
%@                 errcode=94.2;
%@                 instpaths(k)=[];
%@               else
%@                 k=k+1;
%@               end
%@             end
%@             fid=fopen(startupfile,'w');
%@             errcode=94.3;
%@             if fid < 0
%@               disp(['  ** Warning: Could not get access to ',startupfile,'.']);
%@               disp('  ** Could not remove toolbox from the startup.m file.');
%@               disp('  ** Ensure that you have write access!');
%@             else
%@               for i2=1:length(instpaths), 
%@                 fprintf(fid,'%s\n', char(instpaths{i2})); 
%@               end
%@               fclose(fid);
%@             end
%@        end
%@%%%%%%% removing old paths
%@        errcode=93;
%@        if exist(oldtoolboxpath,'dir') == 7
%@           disp(['  Change to ',oldtoolboxpath,''])
%@           cd(oldtoolboxpath)
%@           dirnames='';filenames='';
%@           temp='.:';
%@           errcode=93.1;
%@           while ~isempty(temp)
%@             [temp1 temp]=strtok(temp,':');
%@             if ~isempty(temp1)
%@               dirnames=[dirnames; {temp1}];
%@               x2=dir(temp1);
%@               for i=1:length(x2)
%@                 if ~x2(i).isdir, filenames=[filenames; {[temp1,'/', x2(i).name]}]; end
%@         	   if x2(i).isdir & ~strcmp(x2(i).name,'.') & ~strcmp(x2(i).name,'..'), temp=[temp,temp1,filesep,x2(i).name,':']; end
%@               end
%@             end
%@           end
%@           errcode=93.2;
%@           dirnames=strrep(dirnames,['.',filesep],'');
%@           for i=1:length(dirnames),l(i)=length(dirnames{i}); end
%@           [i i4]=sort(l);
%@           dirnames=dirnames(fliplr(i4));
%@           errcode=93.3;
%@           for i=1:length(dirnames)
%@              if dirnames{i} == '.', continue, end
%@              delete([dirnames{i}, filesep,'*']),
%@              if exist('rmdir') == 5 & exist(dirnames{i}) == 7, rmdir(dirnames{i},'s'), else, delete(dirnames{i}), end
%@              disp(['  Removing files in ',char(dirnames{i}),''])
%@           end
%@           errcode=93.4;
%@           cd(currentpath)
%@           if exist('rmdir') == 5 & exist(oldtoolboxpath) == 7, rmdir(oldtoolboxpath,'s'), else, delete(oldtoolboxpath), end
%@           errcode=93.5;
%@           disp(['  Removing ',oldtoolboxpath,''])
%@        end
%@%%%%%%%
%@      end
%@    end
%@    p = path; i1 = 0;
%@  end
%@  clear p i i1 i2 i3 i4 temp* x2
%@  
%@%%%%%%% add entry into startpath in startup.m
%@  i=findstr(toolboxpath,path);
%@  startupPos = 0;
%@  startup_exist = exist('startup','file');
%@  if isoctave startup_exist = exist('~/.octaverc','file'); end
%@  if startup_exist
%@        errcode=95.1;
%@        startupfile=which('startup');
%@        startuppath=startupfile(1:findstr('startup.m',startupfile)-1);
%@        if isoctave
%@           startuppath = '~/';
%@           startupfile = '~/.octaverc';
%@        end
%@  
%@        if ~isunix
%@           errcode=95.11;
%@           %toolboxroot=fullfile(matlabroot,'toolbox');
%@           if isoctave
%@               toolboxroot=matlabroot;
%@           else
%@               toolboxroot=strtok(userpath,';');
%@           end
%@        else
%@           errcode=95.12;
%@           toolboxroot=startuppath;
%@        end
%@        fid = fopen(startupfile,'r');
%@        k = 1;
%@        while 1
%@            tmp = fgetl(fid);
%@            if ~ischar(tmp), break, end
%@            instpaths{k} = tmp;
%@            k = k + 1;
%@        end
%@        fclose(fid);
%@  end
%@  if isempty(i)
%@     errcode=95;
%@     startupfilestr = 'startup.m';
%@     if isoctave startupfilestr = '~/.octaverc'; toolboxroot = pkg('prefix'); end
%@     if exist(startupfilestr,'file')
%@        errcode=95.1;
%@     else
%@        errcode=95.2;
%@        if ~isunix
%@           errcode=95.21;
%@           if isoctave
%@               toolboxroot=matlabroot;
%@           else
%@               toolboxroot=strtok(userpath,';');
%@           end
%@           err = 1;
%@           if exist(toolboxroot,'file') ~= 7, err=mkdir(toolboxroot); end
%@           if ~err | exist(toolboxroot,'file') ~= 7, error('Could not create toolbox path.'), end
%@           cd(toolboxroot)
%@           startupfile=fullfile(toolboxroot,'startup.m');
%@           instpaths={''};
%@        else
%@           errcode=95.22;
%@           cd ~
%@   	     startuppath=[pwd,filesep];
%@           if isoctave
%@              if exist(pkg('prefix'),'file') ~= 7, mkdir pkg('prefix'), end
%@              cd octave
%@  	          startupfile=[startuppath,'.octaverc'];
%@           else
%@              if exist('matlab','file') ~= 7, mkdir matlab, end
%@              cd matlab
%@  	          startupfile=[startuppath,'startup.m'];
%@           end
%@           
%@  	     toolboxroot=startuppath;
%@  	     instpaths={''};
%@        end
%@     end
%@    
%@        errcode=95.23;
%@        if ~isempty(install_path)
%@           switch ( exist(install_path,'dir') )
%@              case 0
%@                in = input(['> Create ', install_path, '? Y/N [Y]: '],'s');
%@                if isempty(in), in = 'Y'; end
%@                if strcmpi('Y',in)
%@                   err = mkdir(install_path);
%@                   if ~err
%@                     disp(['  ** Could not create ', install_path, '! Using ',startuppath,' as installation path.'])
%@                   else                
%@                     toolboxroot = install_path;
%@                   end                
%@                else 
%@                   disp(['  ** Do not create ', install_path, '! Using ',startuppath,' as installation path.'])
%@                end
%@              case 2
%@                disp(['  ** ', install_path, ' is not a directory! Using ',startuppath,' as installation path.'])
%@              case 7
%@                toolboxroot = install_path;
%@           end
%@        end
%@
%@     errcode=95.3;
%@     TBfullpath=fullfile(toolboxroot,toolboxpath);
%@     if ~exist(TBfullpath,'dir'), mkdir(toolboxroot,toolboxpath); end
%@
%@%%%%%%% resolve relative path (starting with ./ and ../) to absolute path
%@
%@     isrelpath = findstr('./',TBfullpath);
%@     isrelpathDos = findstr('.\',TBfullpath);
%@     if ( ~isempty(isrelpath) & isrelpath == 1 ) | ( ~isempty(isrelpathDos) & isrelpathDos == 1 )
%@         TBfullpath = fullfile(pwd, TBfullpath(3:end));
%@     end
%@
%@     isrelpath = findstr('../',TBfullpath);
%@     isrelpathDos = findstr('..\',TBfullpath);
%@     if ( ~isempty(isrelpath) & isrelpath == 1 ) | ( ~isempty(isrelpathDos) & isrelpathDos == 1 )
%@         TBfullpath = fullfile(pwd, TBfullpath(4:end));
%@     end
%@     
%@
%@%%%%%%% ask where to add entry in startup file
%@
%@     disp(['> In order to get permanent access, the toolbox should be added',10,'> to the end (default) or top (E) of your startup path.'])
%@     in = input('> Add toolbox permanently into your startup path (highly recommended)? Y/T/N [Y]: ','s');
%@     if isempty(in), in = 'Y'; end
%@     if strcmpi('Y',in)
%@       startupPos = '-begin';
%@       disp('  Adding Toolbox at the end of the startup.m file')
%@     elseif strcmpi('T',in)
%@       startupPos = '-end';
%@       disp('  Adding Toolbox at the top of the startup.m file')
%@     end
%@
%@     if startupPos
%@         errcode=95.4;
%@         loc = ['addpath ''',TBfullpath,''' ', startupPos];
%@         if ~ismember(loc, instpaths)
%@             instpaths{end+1} = loc;
%@         end
%@     end
%@
%@  else
%@     errcode=96;
%@     startupfile=which('startup');
%@     startuppath=startupfile(1:findstr('startup.m',startupfile)-1);
%@     if isoctave
%@         startuppath = '~/';
%@         startupfile = '~/.octaverc';
%@     end
%@     if ~isunix
%@        if isoctave
%@            toolboxroot=matlabroot;
%@        else
%@            toolboxroot=strtok(userpath,';');
%@        end
%@        %toolboxroot=fullfile(matlabroot,'toolbox');
%@     else
%@        toolboxroot=startuppath;
%@     end
%@    
%@        errcode=96.21;
%@        if ~isempty(install_path)
%@           switch ( exist(install_path,'dir') )
%@              case 0
%@                disp(['> Create ', install_path, '?'])
%@                in = input('> Create ', install_path, '? Y/N [Y]: ','s');
%@                if isempty(in), in = 'Y'; end
%@                if strcmpi('Y',in)
%@                   err = mkdir(install_path);
%@                   if ~err
%@                     disp(['  ** Could not create ', install_path, '! Using ',startuppath,' as installation path.'])
%@                   else                
%@                     toolboxroot = install_path;
%@                   end                
%@                else 
%@                   disp(['  ** Do not create ', install_path, '! Using ',startuppath,' as installation path.'])
%@                end
%@              case 2
%@                disp(['  ** ', install_path, ' is not a directory! Using ',startuppath,' as installation path.'])
%@              case 7
%@                toolboxroot = install_path;
%@           end
%@        end
%@        TBfullpath=fullfile(toolboxroot,toolboxpath);
%@        if ~exist(TBfullpath,'dir'), mkdir(toolboxroot,toolboxpath); end
%@  end
%@  
%@  
%@%%%%%%% read the archive
%@  errcode=97;
%@  fprintf('  Importing the archiv ')
%@  cd(currentpath)
%@  max_sc=30;
%@  scale=[sprintf('%3.0f',0),'% |',repmat(' ',1,max_sc),'|'];
%@  fprintf('%s',scale)
%@  b=''; c.file=''; c.data=''; bfile=''; folder=''; i2=0;
%@    
%@    % read ASCII
%@    errcode=97.1;
%@    i1=findstr(char(A'),'%<-- ASCII begins here');
%@    i2=findstr(char(A'),'%<-- ASCII ends here -->');
%@    
%@    for k=1:length(i1),
%@      wb=round(i1(k)*max_sc/eofbyte);
%@      errcode=97.11;
%@      scale=[sprintf('%3.0f',100*wb/max_sc),'% |',repmat('*',1,wb),repmat(' ',1,max_sc-wb),'|'];
%@      fprintf([repmat('\b',1,max_sc+7),'%s'],scale)
%@      B=A(i1(k):i2(k)-2);
%@     
%@      i4=find(B == 10);
%@      i3=[0;i4(1:end-1)]+1;
%@      filename=strrep(...
%@                strrep(char(B(i3(1):i4(1)-1)'),'%<-- ASCII begins here: __',''),...
%@  	      '__ -->','');
%@      errcode=['97.1',reshape(dec2hex(double(filename))',1,length(filename)*2)];
%@      filename = strrep(filename, '/', filesep);
%@      i6=findstr(filename, filesep);
%@      if i6>0
%@         folder=[folder; {filename(1:i6(end)-1)}];
%@      end
%@      c(k).file={filename};
%@      c(k).data=strrep(char(B(i4(1)+3:end)'),[char(10),'%@'],char(10));
%@    end
%@  
%@    % read binary
%@    errcode=97.2;
%@    i1=findstr(char(A'),'%<-- Binary begins here');
%@    i2=findstr(char(A'),'%<-- Binary ends here -->');
%@    for k=1:length(i1),
%@      wb=round(i1(k)*max_sc/eofbyte);
%@      errcode=97.21;
%@      scale=[sprintf('%3.0f',100*wb/max_sc),'% |',repmat('*',1,wb),repmat(' ',1,max_sc-wb),'|'];
%@      fprintf([repmat('\b',1,max_sc+7),'%s'],scale)
%@      B=A(i1(k):i2(k));
%@  
%@      i4=find(B == 10);
%@      i3=[0;i4(1:end-1)]+1;
%@      i5=findstr(char(B(i3(1):i4(1))'),'__');
%@      filename=char(B(i5(1)+2:i5(2)-1)');
%@      errcode=['97.2',reshape(dec2hex(double(filename))',1,length(filename)*2)];
%@      filename = strrep(filename, '/', filesep);
%@      i6=findstr(filename, filesep);
%@      if i6>0
%@      folder=[folder; {filename(1:i6(end)-1)}];
%@      end
%@      bfile=[bfile; {filename}];
%@      nbytes=str2double(char(B(i5(3)+2:i5(4)-1)'));
%@      if nbytes>=2
%@        temp=reshape(B(i4(1)+1:i4(1)+nbytes),2,nbytes/2);
%@        b=[b;{temp(2,:)}];
%@      else
%@        b=[b;{''}];
%@      end
%@  
%@    end
%@    wb=max_sc;
%@    scale=[sprintf('%3.0f',100*wb/max_sc),'% |',repmat('*',1,wb),repmat(' ',1,max_sc-wb),'|'];
%@    fprintf([repmat('\b',1,max_sc+7),'%s'],scale)
%@  fprintf('\n')
%@  clear temp* i i1 i2 i3 i4 i5 i6 A B
%@  
%@  errcode='97.3';
%@  cd(TBfullpath)
%@  disp(['  Toolbox folder is ',TBfullpath,''])
%@  
%@%%%%%%% make sub-directories
%@  errcode='97.4';
%@  for i=1:length(folder);
%@     i1=folder{i}; i2='.'; olddir=pwd;
%@     if exist([TBfullpath, filesep, i1],'file') ~= 7
%@        while ~isempty(i2) & ~isempty(i1)
%@          cd(i2)
%@          [i2 i1]=strtok(i1,'/');
%@          if exist([pwd, filesep, i2],'file') ~= 7 & exist([pwd, filesep, i2],'file')
%@             disp(['  ** Warning: Found ', i2, ' will be overwritten.'])
%@             errcode=['97.5',reshape(dec2hex(double(i2))',1,length(i2)*2)];
%@             delete(i2)
%@          end
%@          if ~exist([pwd, filesep, i2],'file')
%@            disp(['  Make directory ',pwd, filesep, i2,''])
%@            errcode=['97.6',reshape(dec2hex(double(i2))',1,length(i2)*2)];
%@            mkdir(i2)
%@            errcode=97.7;
%@            if ~strcmpi(i2,'private') & i2 ~= '@'
%@                 if isempty(startupPos) startupPos = '-end'; end
%@                 loc = ['addpath ''',pwd, filesep, i2,''' ', startupPos];
%@                 eval(loc);
%@                 if ~ismember(loc, instpaths)
%@                     instpaths{end+1} = loc;
%@                 end
%@            end
%@          end
%@        end
%@        cd(olddir)
%@     end
%@  end
%@  
%@%%%%%%% make toolbox accessible in the current matlab session
%@  if ~startupPos, startupPos = '-end'; end
%@  addpath(TBfullpath,startupPos);
%@
%@
%@%%%%%%% write startup file
%@  if startupPos
%@    errcode=95.4;
%@    if ~exist('startupfile','var')
%@        if isoctave
%@            startupfile = '~/.octaverc';
%@        else
%@            startupfile = '~/matlab/startup.m';
%@        end
%@    end
%@
%@    fid=fopen(startupfile,'w');
%@    if fid < 0
%@      disp(['  ** Warning: Could not get access to ',startupfile,'.']);
%@      disp('  ** Could not add toolbox into the startup.m file.');
%@      disp('  ** Ensure that you have write access!');
%@    else
%@      for i2=1:length(instpaths), fprintf(fid,'%s\n', char(instpaths{i2})); disp(char(instpaths{i2}));end
%@      fclose(fid);
%@    end
%@  end
%@
%@
%@%%%%%%% write the programme files
%@  errcode=98;
%@  num_errors=0;
%@  for i=1:length(c),
%@    disp(['  Creating ',char(c(i).file),''])
%@    fid=fopen(char(c(i).file),'w');
%@    if fid < 0
%@       disp('  ** Warning: Could not get access to ',char(c(i).file),'.');
%@       disp('  ** Ensure that you have write access in this filesystem!');
%@       num_errors=num_errors+1;
%@       if num_errors == 2; 
%@         disp('Abort!')
%@         disp('Too much errors due to write access failure in this filesystem.')
%@         cd(currentpath), return
%@       end
%@    else
%@      if strcmpi(c(i).file,'info.xml')
%@        v=version;
%@        release=str2double(v(findstr(v,'(R')+2:findstr(v,')')-1));
%@        if release>12, area='toolbox'; icon_path='$toolbox/matlab/icons'; else area='matlab'; icon_path='$toolbox/matlab/general'; end
%@        i3=findstr(c(i).data,'<matlabrelease>'); i4=findstr(c(i).data,'</matlabrelease>');
%@        if ~isempty(i3) & i4>i3;
%@          c(i).data=strrep(c(i).data,c(i).data(i3:i4-1),['<matlabrelease>',num2str(release)]);
%@        end
%@        i3=findstr(c(i).data,'<area>'); i4=findstr(c(i).data,'</area>');
%@        if ~isempty(i3) & i4>i3;
%@          c(i).data=strrep(c(i).data,c(i).data(i3:i4-1),['<area>',area]);
%@        end
%@        c(i).data=strrep(c(i).data,'<icon>$toolbox/matlab/general',['<icon>',icon_path]);
%@        c(i).data=strrep(c(i).data,'<icon>$toolbox/matlab/icons',['<icon>',icon_path]);
%@      end
%@      fprintf(fid,'%s',char(c(i).data));
%@      fclose(fid);
%@    end
%@  end
%@
%@%%%%%%% pcode the programme files
%@  for i=1:length(c),
%@    try
%@      [tPath tFile tExt]=fileparts(char(c(i).file));
%@      if strcmpi(tExt,'.m') & ~strcmpi(tFile,'Readme') & ~strcmpi(tFile,'Contents')
%@        if mislocked(char(c(i).file)), munlock(char(c(i).file)); clear(char(c(i).file)); end
%@        disp(['  Pcode ',char(c(i).file),''])
%@        if sum(c(i).file == '.') < 2
%@           pcode(char(c(i).file),'-inplace')
%@        end  
%@      end  
%@    catch
%@    end
%@  end
%@
%@%%%%%%% write the binary files
%@  num_errors=0;
%@  for i=1:length(b),
%@    disp(['  Creating ',char(bfile(i)),''])
%@    fid=fopen(char(bfile(i)),'w');
%@    if fid < 0
%@       disp(['  ** Warning: Could not get access to ',char(bfile(i)),'.']);
%@       disp('  ** Ensure that you have write access in this filesystem!');
%@       num_errors=num_errors+1;
%@       if num_errors == 2; 
%@         disp('Abort!')
%@         disp('Too much errors due to write access failure in this filesystem.')
%@         cd(currentpath), return
%@       end
%@    else
%@      fwrite(fid,b{i}); 
%@      fclose(fid);
%@    end
%@  end
%@  tx=version; tx=strtok(tx,'.'); 
%@  if str2double(tx)>=5 & exist('rehash','builtin'), rehash, end
%@  if str2double(tx)>=6 & exist('rehash','builtin'), eval('rehash toolboxcache'), end
%@  
%@%%%%%%% removing installation file
%@  errcode=99;
%@  cd(currentpath)
%@  i = input('> Delete installation file? Y/N [Y]: ','s');
%@  if isempty(i), i = 'Y'; end
%@  
%@  if strcmpi('Y',i)
%@    disp('  Removing installation file')
%@    delete(install_file)
%@  end
%@  
%@  disp('  Installation finished!')
%@  
%@  if ~exist('rehash','builtin')
%@    disp('  ** Warning: Could not rehash your Matlab system.')
%@    disp('  ** Probably a restart of Matlab will be necessary in order')
%@    disp('  ** to get access to the installed toolbox.')
%@  end
%@  
%@  disp('$lines$')
%@  $infostring$
%@  disp('For an overview type:')
%@  disp(['helpwin ',toolboxpath])
%@  warning('on')
%@  if isoctave
%@      more on
%@  end
%@  
%@  
%@%%%%%%% error handling
%@
%@catch
%@  z2=whos;x_lasterr=lasterr;y_lastwarn=lastwarn;
%@  if ~strcmpi(x_lasterr,'Interrupt')
%@    if fid>-1, 
%@      try, z_ferror=ferror(fid); catch, z_ferror=''; end
%@    else
%@      z_ferror='File not found.'; 
%@    end
%@    installfile_info=dir([currentpath,filesep,install_file]);
%@    fid=fopen(fullfile(currentpath,'install.log'),'w');
%@    checksum_test=findstr(x_lasterr,'The installation file is corrupt!');
%@    if isempty(checksum_test),checksum_test=0; end
%@    if ~checksum_test
%@      fprintf(fid,'%s\n','This script is under development and your assistance is');
%@      fprintf(fid,'%s\n','urgently welcome. Please inform the distributor of the');
%@      fprintf(fid,'%s\n','toolbox, where the error occured and send us the following');
%@      fprintf(fid,'%s\n','error report and the informations about the toolbox (distributor,');
%@      fprintf(fid,'%s\n','name etc.). Provide a brief description of what you were');
%@      fprintf(fid,'%s\n','doing when this problem occurred.');
%@      fprintf(fid,'%s\n','E-mail or FAX this information to us at:');
%@      fprintf(fid,'%s\n','    E-mail:  marwan@pik-potsdam.de');
%@      fprintf(fid,'%s\n','       Fax:  ++49 +331 288 2640');
%@      fprintf(fid,'%s\n\n\n','Thank you for your assistance.');
%@      fprintf(fid,'%s\n',repmat('-',50,1));
%@      fprintf(fid,'%s\n',datestr(now,0));
%@      fprintf(fid,'%s\n',['Matlab ',char(version),' on ',computer]);
%@      fprintf(fid,'%s\n',repmat('-',50,1));
%@      fprintf(fid,'%s\n','Makeinstall Version ==> $mi_version$');
%@      fprintf(fid,'%s\n',['Install File ==> ',install_file,'/',installfile_info.date,'/',num2str(installfile_info.bytes)]);
%@      fprintf(fid,'%s\n',['Container ==> ',time_stamp,'/',checksum]);
%@      fprintf(fid,'%s\n\n',repmat('-',50,1));
%@      fprintf(fid,'%s\n',x_lasterr);
%@      fprintf(fid,'%s\n',y_lastwarn);
%@      fprintf(fid,'%s\n',z_ferror);
%@      fprintf(fid,'%s\n',[' errorcode ==> ',num2str(errcode)]);
%@      fprintf(fid,'%s\n',' workspace dump ==>');
%@      if ~isempty(z2), 
%@        fprintf(fid,'%s\n',['Name',char(9),'Size',char(9),'Bytes',char(9),'Class']);
%@        for j=1:length(z2);
%@          fprintf(fid,'%s',[z2(j).name,char(9),num2str(z2(j).size),char(9),num2str(z2(j).bytes),char(9),z2(j).class]);
%@          if ~strcmp(z2(j).class,'cell') & ~strcmp(z2(j).class,'struct')
%@            content=eval(z2(j).name);
%@            try, content=mat2str(content(1:min([size(content,1),500]),1:min([size(content,2),500])));end
%@            fprintf(fid,'\t%s',content(1:min([length(content),500])));
%@          elseif strcmp(z2(j).class,'cell')
%@            content=eval(z2(j).name);
%@            fprintf(fid,'\t');
%@            for j2=1:min([length(content),500])
%@              if isnumeric(content{j2})
%@                fprintf(fid,'{%s} ',content{j2}(1:end));
%@              elseif iscell(content{j2})
%@                fprintf(fid,'{%s} ',content{j2}{1:end});
%@              end
%@            end
%@          elseif strcmp(z2(j).class,'struct')
%@            content=fieldnames(eval(z2(j).name));
%@            content=char(content); content(:,end+1)=' '; content=content';
%@            fprintf(fid,'\t%s',content(:)');
%@          end
%@          fprintf(fid,'%s\n','');
%@        end
%@      end
%@    else
%@      fprintf(fid,'%s\n','Installation aborted due to a failed checksum test!');
%@      fprintf(fid,'%s\n',['Checksum should be:     ', checksum]);
%@      fprintf(fid,'%s\n\n',['Checksum of archive is: ', checksum_file]);
%@      fprintf(fid,'%s\n','Ensure that the installation file was not modified by any');
%@      fprintf(fid,'%s\n','other programme, as an anti-virus scanner for emails, a');
%@      fprintf(fid,'%s\n','mis-configured HTTP proxy or FTP programme.');
%@    end
%@    fclose(fid);
%@    disp('----------------------------');
%@    disp('       ERROR OCCURED ');
%@    disp('    during installation');
%@    disp('----------------------------');
%@    disp(x_lasterr);
%@    if errcode == 95.21
%@       disp('----------------------------');
%@       disp('   This error means that the toolbox directory could not');
%@       disp('   be created. Probably, there is a file of the same name.');
%@       disp('   or there are in-appropriate permission settings in its');
%@       disp('   parent folder.');
%@       disp('   Please check the output of the following command:');
%@       disp('      userpath(''reset'')');
%@       disp('   which might help to locate the problem.');
%@       disp('----------------------------');
%@    end
%@    if ~checksum_test
%@      disp(z_ferror);
%@      disp(['   errorcode is ',num2str(errcode)]);
%@      disp('----------------------------');
%@      disp('   This script is under development and your assistance is ')
%@      disp('   urgently welcome. Please inform the distributor of the')
%@      disp('   toolbox, where the error occured and send us the error')
%@      disp('   report and the informations about the toolbox (distributor,')
%@      disp('   name etc.). For your convenience, this information has been')
%@      disp('   recorded in: ')
%@      disp(['   ',fullfile(currentpath,'install.log')]), disp(' ')
%@      disp('   Provide a brief description of what you were doing when ')
%@      disp('   this problem occurred.'), disp(' ')
%@      disp('   E-mail or FAX this information to us at:')
%@      disp('       E-mail:  marwan@pik-potsdam.de')
%@      disp('          Fax:  ++49 +331 288 2640'), disp(' ')
%@      disp('   Thank you for your assistance.')
%@    end
%@  end
%@  warning('on')
%@  cd(currentpath)
%@  if isoctave
%@      more on
%@  end
%@end
%@
%@function flag = isoctave
%@% ISOCTAVE   Checks whether the code is running in Octave
%@%   ISOCTAVE is returning the value TRUE if executed within the
%@%   Octave environment, else it is returning FALSE (e.g. when
%@%   called within Matlab.
%@
%@a = ver('Octave');
%@
%@if ~isempty(a) && strfind(a(1).Name,'Octave')
%@    flag = true;
%@else
%@    flag = false;
%@end
%<-- ASCII ends here -->
%<-- ASCII begins here: clean -->
%@function $deinstall_file$
%@%$deinstall_file_up$   Removes $toolboxname$.
%@%    $deinstall_file_up$ removes all files of $toolboxname$ from
%@%    the filesystem and its entry from the Matlab
%@%    startup file.
%@%    
%@%    This installation script was generated by using 
%@%    the MAKEINSTALL tool. For further information
%@%    visit http://matlab.pucicu.de
%@
%@% Copyright (c) 2008-2012
%@% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
%@% http://www.pik-potsdam.de
%@%
%@% Copyright (c) 2002-2008
%@% Norbert Marwan, Potsdam University, Germany
%@% http://www.agnld.uni-potsdam.de
%@%
%@% Generation date: $generation_date$
%@% $Date: 2013/09/05 15:43:02 $
%@% $Revision: 3.23 $
%@
%@error(nargchk(0,0,nargin));
%@
%@try
%@  if isoctave
%@      more off
%@  end
%@  warning('off')
%@  disp('$lines$')
%@  disp('    REMOVING $toolboxname$    ')
%@  disp('$lines$')
%@  currentpath=pwd;
%@  oldtoolboxpath = fileparts(which(mfilename));
%@
%@  disp(['  $toolboxname$ found in ', oldtoolboxpath,''])
%@  i = input('> Delete $toolboxname$? Y/N [Y]: ','s');
%@  if isempty(i), i = 'Y'; end
%@
%@  if strcmpi('Y',i)
%@%%%%%%% check for entries in startup
%@  
%@        p=path; i1=0; i = '';
%@  
%@        while findstr(upper('$toolboxdir$'),upper(p)) > i1
%@           i1=findstr(upper('$toolboxdir$'),upper(p));
%@           if ~isempty(i1)
%@               i1=i1(end);
%@               if isunix, i2=findstr(':',p); else, i2=findstr(';',p); end
%@               i3=i2(i2>i1);                 % last index pathname
%@               if ~isempty(i3), i3=i3(1)-1; else, i3=length(p); end
%@               i4=i2(i2<i1);                 % first index pathname
%@               if ~isempty(i4), i4=i4(end)+1; else, i4=1; end
%@               rmtoolboxpath=p(i4:i3);
%@%%%%%%% removing entry in startup-file
%@               rmpath(rmtoolboxpath)
%@               if i4>1, p(i4-1:i3)=''; else, p(i4:i3)=''; end
%@               startup_exist = exist('startup','file');
%@               if startup_exist
%@                    startupfile=which('startup');
%@                    startuppath=startupfile(1:findstr('startup.m',startupfile)-1);
%@                    instpaths=textread(startupfile,'%[^\n]');
%@                    k=1;
%@                    while k <= length(instpaths)
%@                        if ~isempty(findstr(rmtoolboxpath,instpaths{k}))
%@                            disp(['  Removing startup entry ', instpaths{k}])
%@                            instpaths(k)=[];
%@                        end
%@                        k=k+1;
%@                    end
%@                    fid=fopen(startupfile,'w');
%@                    for i2=1:length(instpaths), 
%@                        fprintf(fid,'%s\n', char(instpaths(i2,:))); 
%@                    end
%@                    fclose(fid);
%@               end
%@           end
%@           p = path; i1 = 0;
%@       end
%@%%%%%%% removing old paths
%@        if exist(oldtoolboxpath,'dir') == 7
%@           disp(['  Removing files in ',oldtoolboxpath,''])
%@           cd(oldtoolboxpath)
%@           dirnames='';filenames='';
%@           temp='.:';
%@           while ~isempty(temp)
%@               [temp1 temp]=strtok(temp,':');
%@               if ~isempty(temp1)
%@                   dirnames=[dirnames; {temp1}];
%@                   x2=dir(temp1);
%@                   for i=1:length(x2)
%@                       if ~x2(i).isdir, filenames=[filenames; {[temp1,'/', x2(i).name]}]; end
%@         	             if x2(i).isdir & ~strcmp(x2(i).name,'.') & ~strcmp(x2(i).name,'..'), temp=[temp,temp1,filesep,x2(i).name,':']; end
%@                   end
%@               end
%@           end
%@           dirnames = strrep(dirnames,['.',filesep],'');
%@           dirnames(strcmpi('.',dirnames)) = [];
%@           l = zeros(length(dirnames),1); for i=1:length(dirnames),l(i)=length(dirnames{i}); end
%@           [i i4]=sort(l); i4 = i4(:);
%@           dirnames=dirnames(flipud(i4));
%@           for i=1:length(dirnames)
%@              delete([dirnames{i}, filesep,'*'])
%@              if exist('rmdir') == 5 & exist(dirnames{i}) == 7, rmdir(dirnames{i},'s'), else, delete(dirnames{i}), end
%@              disp(['  Removing files in ',char(dirnames{i}),''])
%@           end
%@           if exist(currentpath), cd(currentpath), else, cd .., end
%@           if strcmpi(currentpath,oldtoolboxpath), cd .., end
%@           if exist('rmdir') == 5 & exist(oldtoolboxpath) == 7, rmdir(oldtoolboxpath,'s'), else, delete(oldtoolboxpath), end
%@           disp(['  Removing folder ',oldtoolboxpath,''])
%@        end
%@       disp(['  $toolboxname$ now removed.'])
%@  else
%@       disp(['  Nothing happened. Keep smiling.'])
%@  end
%@  tx=version; tx=strtok(tx,'.'); if str2double(tx)>=6 & exist('rehash','builtin'), rehash, end
%@  warning on
%@  if isoctave
%@      more on
%@  end
%@  if exist(currentpath,'dir') ~= 7, cd(fileparts(currentpath)), else, cd(currentpath), end
%@  
%@%%%%%%% error handling
%@
%@catch
%@  x=lasterr;y=lastwarn;
%@  if ~strcmpi(lasterr,'Interrupt')
%@    if fid>-1, 
%@      try, z=ferror(fid); catch, z='No error in the installation I/O process.'; end
%@    else
%@      z='File not found.'; 
%@    end
%@    fid=fopen('deinstall.log','w');
%@    fprintf(fid,'%s\n','This script is under development and your assistance is');
%@    fprintf(fid,'%s\n','urgently welcome. Please inform the distributor of the');
%@    fprintf(fid,'%s\n','toolbox, where the error occured and send us the following');
%@    fprintf(fid,'%s\n','error report and the informations about the toolbox (distributor,');
%@    fprintf(fid,'%s\n','name etc.). Provide a brief description of what you were');
%@    fprintf(fid,'%s\n','doing when this problem occurred.');
%@    fprintf(fid,'%s\n','E-mail or FAX this information to us at:');
%@    fprintf(fid,'%s\n','    E-mail:  marwan@pik-potsdam.de');
%@    fprintf(fid,'%s\n','       Fax:  ++49 +331 288 2640');
%@    fprintf(fid,'%s\n\n\n','Thank you for your assistance.');
%@    fprintf(fid,'%s\n',repmat('-',50,1));
%@    fprintf(fid,'%s\n',datestr(now,0));
%@    fprintf(fid,'%s\n',['Matlab ',char(version),' on ',computer]);
%@    fprintf(fid,'%s\n',repmat('-',50,1));
%@    fprintf(fid,'%s\n','$toolboxname$');
%@    fprintf(fid,'%s\n',x);
%@    fprintf(fid,'%s\n',y);
%@    fprintf(fid,'%s\n',z);
%@    fclose(fid);
%@    disp('----------------------------');
%@    disp('       ERROR OCCURED ');
%@    disp('   during deinstallation');
%@    disp('----------------------------');
%@    disp(x);
%@    disp(z);
%@    disp('----------------------------');
%@    disp('   This script is under development and your assistance is ')
%@    disp('   urgently welcome. Please inform the distributor of the')
%@    disp('   toolbox, where the error occured and send us the error')
%@    disp('   report and the informations about the toolbox (distributor,')
%@    disp('   name etc.). For your convenience, this information has been')
%@    disp('   recorded in: ')
%@    disp(['   ',fullfile(pwd,'deinstall.log')]), disp(' ')
%@    disp('   Provide a brief description of what you were doing when ')
%@    disp('   this problem occurred.'), disp(' ')
%@    disp('   E-mail or FAX this information to us at:')
%@    disp('       E-mail:  marwan@pik-potsdam.de')
%@    disp('          Fax:  ++49 +331 288 2640'), disp(' ')
%@    disp('   Thank you for your assistance.')
%@  end
%@  warning('on')
%@  if exist(currentpath,'dir') == 7, cd(fileparts(currentpath)), else, cd(currentpath), end
%@  if isoctave
%@      more on
%@  end
%@end
%@
%@function flag = isoctave
%@% ISOCTAVE   Checks whether the code is running in Octave
%@%   ISOCTAVE is returning the value TRUE if executed within the
%@%   Octave environment, else it is returning FALSE (e.g. when
%@%   called within Matlab.
%@
%@a = ver('Octave');
%@
%@if ~isempty(a) && strfind(a(1).Name,'Octave')
%@    flag = true;
%@else
%@    flag = false;
%@end
%<-- ASCII ends here -->
