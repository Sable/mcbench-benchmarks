function manage_pref(defdir)
%MANAGE_PREF - Save or restore matlab preference
% 
% Syntax:
%	manage_pref
%	manage_pref(defdir)
% 
% Inputs:
%	defdir: defaut save or restore path
% 
% Outputs:
%	none
% 
% Examples:
%	manage_pref('D:\document\MATLAB\Others\pref')
% 
% Other m-files required:
% 
% See also: 

% Author: Wang Lei
% Organization: Nanjing University of Aeronautics and Astronautics (NUAA), China
% Email: wanglei_1982@nuaa.edu.cn
% Last revision: 07-Jan-2011


% save? restore?
prompt = '============== Preference Manager (Author: STONE) ==============\n[1] Save Matlab Preference? (defaut)\n[2] Load Matlab Preference?\n';
response = input_(prompt, [1 2]);

% defaut dir
if nargin<1 || isempty(defdir)
	defdir = fullfile(pwd, 'pref');
	if ~isdir(defdir)
		mkdir(defdir);
	end
end

% Save preference
if response == '1'
	
	% dst path
	path_2 = inputdir(['Destination path: ' '[' transpathstr_C(defdir) ']? [press 0 to select]  '], defdir);
	disp(' ');
	disp('===============================================================');	
	path_1 = prefdir;
	copyfile_('shortcuts.xml', path_1, path_2);	% save shortcut
	copyfile_('matlab.prf', path_1, path_2);	% save preference
	copyfile_('MATLABDesktop.xml', path_1, path_2);	% save MATLABDesktop
	copyfile_('Your_Saved_LayoutMATLABLayout.xml', path_1, path_2, 'mute');	% save Your_Saved_LayoutMATLABLayout
	copyfile_('CodepadMATLABToolBar.xml', path_1, path_2);	%
	copyfile_('Editor ToolbarMATLABToolBar.xml', path_1, path_2);	%
	copyfile_('help_browser_toolbar.xml', path_1, path_2);	%
	copyfile_('MainMATLABToolBar.xml', path_1, path_2);	%	
	disp('---------------------------------------------------------------');
	path_1 = toolboxdir('local');
	copyfile_('pathdef.m', path_1, path_2);
	fileattrib(fullfile(path_2,'pathdef.m'),'+w'); % cancel file read-only attribute
	disp('---------------------------------------------------------------');
	path_1 = [];	% matlab search path
	[status,dstfilname] = copyfile_('startup', path_1, path_2, 'mute');	% matlabroot\toolbox\local\startup.m
	fileattrib(fullfile(path_2,dstfilname),'+w'); % cancel file read-only attribute
	[status,dstfilname] = copyfile_('finish', path_1, path_2, 'mute');	% matlabroot\toolbox\local\finish.m
	fileattrib(fullfile(path_2,dstfilname),'+w'); % cancel file read-only attribute
	disp(['===============================================================' char(10)]);	
	
% Restore preference
elseif  response == '2'
	
	% src path
    path_1 = inputdir(['Source path: ' '[' transpathstr_C(defdir) ']?  [press 0 to select]  '], defdir);
	disp(' ');
	disp('===============================================================');	
	path_2 = prefdir;
	copyfile_('shortcuts.xml', path_1, path_2);
	copyfile_('matlab.prf', path_1, path_2);
	copyfile_('MATLABDesktop.xml', path_1, path_2);
	copyfile_('Your_Saved_LayoutMATLABLayout.xml', path_1, path_2, 'mute');
	copyfile_('CodepadMATLABToolBar.xml', path_1, path_2);	%
	copyfile_('Editor ToolbarMATLABToolBar.xml', path_1, path_2);	%
	copyfile_('help_browser_toolbar.xml', path_1, path_2);	%
	copyfile_('MainMATLABToolBar.xml', path_1, path_2);	%
	disp('---------------------------------------------------------------');
	addpathfile('pathdef.m', path_1);
	disp('---------------------------------------------------------------');
	path_2 = toolboxdir('local');
	copyfile_('startup', path_1, path_2, 'mute');
	copyfile_('finish', path_1, path_2, 'mute');
	disp(['===============================================================' char(10)]);	
	
	% add file associate?  
	response = input_(['Add file associate for ".m .mat .fig .p .mdl .' mexext '", y/n? [n]'], ['n';'y']);
	if strcmpi(response, 'y')
		fileassoc_;	
	end
	disp(char(10));
	
else
	error('type error.');
end


function addpathfile(filename, filepath)
% add path from filename

% get old path
oldpath = path;       
% get new path
copyfile_(filename, filepath, toolboxdir('local')); % change path file
newpath = path;
% merge two path
p = [oldpath pathsep newpath pathsep];

% path string -> cellstr
c = textscan(p, '%s', 'delimiter', pathsep, 'MultipleDelimsAsOne', 1);
% 去除重复的路径
c = unique(c{1});
% 添加 ';'
for i_ = 1:numel(c)
    c{i_} = [c{i_} pathsep];
end
% cellstr -> path string
p = strcat(c{:});

% save path
path(p);    % changes the search path to newpath
savepath;   % Save current search path

function [success dstfilename] = copyfile_(filename, src, dst, prompt)
% copyfile_('a.txt')
% copyfile_('a.txt', 'c:\', 'd:\')
% copyfile_('a.txt', 'c:\', 'd:\', prompt)
%
% prompt : 'mute' not prompt when copy failed

if nargin<2
	src = [];
end

% defaut destination path is the desktop path
if nargin<3 || isempty(dst)
	dst = getDesktopPath;
end

% get source file full name
srcfilename = fullfile_(src,filename);
% parse src and dst filename
[dummy, srcname, srcext] = fileparts(srcfilename);
[dstpath, dstname, dstext] = fileparts(dst);
if isempty(dstname)
	dstname = srcname;
	dstext = srcext;
end
dstfilename = [dstname dstext];
% defaut prompt
if nargin<4 || isempty(prompt) || strcmpi(prompt, 'mute')
	headstr = [' ' srcname srcext ' --> ' dstname];
else
	headstr = prompt;
end

% copy
[ success msg ] = copyfile(srcfilename, dst, 'f');

% disp
midstr = [ '  ' ];
if success
	disp(['Succeeded!' midstr headstr  ]);
else
	if nargin<4 || ~strcmpi(prompt, 'mute')
		disp(['Failed!' midstr headstr '(' msg ')']);
	end
end

function result = input_(prompt,selection, defsel)
% input_
% input_(prompt)	% selection maybe anything
% input_(prompt, [1 2 3]) % defaut selection is the first element of selection
% input_(prompt, ['y'; 'n'])
% input_(prompt, {'1' '2' 'yes' 'no'})	
% input_(..., defsel)	% defsel为默认选择

if nargin<1 || isempty(prompt)
	prompt = '[1] (defaut)\n[2]\n';		% defaut prompt
end

% n selection
if nargin<2 || isempty(selection)
	nSel = 0;
else
	% convert selection to cell
	if isnumeric(selection) || islogical(selection)
		selection = num2cell_(selection);
	elseif ischar(selection);
		selection = cellstr(selection);
	end
	if ~iscell(selection)
		error('selection type error!');
	end
	% number of selection
	nSel = numel(selection);	
	% defaut selection
	if nargin<3 || isempty(defsel)
		defsel = selection{1};
	end
end

% -------wating for correct input char---------------
if nSel == 0 % 没有选择范围，可以为任意输入
	result = input(prompt, 's');
	return;
end

while true % 有选择范围，必须为指定输入
	reply = input(prompt, 's');
	% 输入回车，返回默认选择
	if isempty(reply) 
		result = defsel;
		return; %
	end
	% 根据输入匹配选择
	for i_ = 1:nSel
		if strcmpi(reply,selection{i_})
			result = selection{i_};
			return; %
		end
	end
end

function fileassoc_
% add file associate

cwd = pwd; 
cd([matlabroot '\toolbox\matlab\winfun\private']); 
fileassoc('add',{'.m','.mat','.fig','.p','.mdl',['.' mexext]}); % 重点
cd(cwd); 
disp('Changed Windows file associations. FIG, M, MAT, MDL, MEX, and P files are now associated with MATLAB.')

function path2 = transpathstr_C(path)
% add escape char in path string
% transpathstr_C('E:\MatlabSim\ProjectM');	----> E:\\MatlabSim\\ProjectM

% get path seperate '\'
sep = filesep;

% add escape char
j_ = 1;
for i_ = 1:length(path)
	if path(i_)==sep;
		path2(j_) = '\';	%#ok<*AGROW> % escape char in string
		j_ = j_ + 1;
	end
	path2(j_) = path(i_);	%
	j_ = j_ + 1;
end

function result = inputdir(prompt,defpath)
% inputdir	% 
% inputdir(prompt) % defaut path is desktop path
% inputdir(prompt, defpath)

if nargin<1 || isempty(prompt)
	prompt = 'path: [desktop]? [press 0 to select]';		% defaut prompt
end

% defaut path is desktop path
if nargin<2 || isempty(defpath)
	defpath = getDesktopPath;
end

% get input char
while true
	% get reply
	reply = input(prompt, 's');
	% enter selection (defaut)
	if isempty(reply)
		result = defpath;
	else
		if reply=='0'
			result = uigetdir(defpath);
		else
			result = reply;
		end
	end
	
	% check path
	if isdir(result)
		break;
    else
        display(['"' result '" is not a valid path']);
        display(' ');
	end
end
result = getfullpath(result);


function c = num2cell_(a)
% Convert numeric array to cell array as string
% num2cell_([1 2;3 4])

c = cellstr(num2str(a(:)));
c = reshape(c,size(a));

function fullfilename = fullfile_(pname, fname)
% atempt to get pathstr and ext in matlab pname or specific pname if they are empty
% fullfile_('C:\', 'aaa') --> 'c:\aaa.m' if c:\aaa.m exist

fullfilename = fullfile(pname, fname);

% -----extra process ------------
[pathstr, name, ext] = fileparts(fullfilename);

if isempty(pathstr)	% 缺少路径
	% search matlab pname
	fullfilename = which(fullfilename);
elseif isempty(ext) % 缺少后缀
	% search specific pname	
	if exist([fullfilename '.' mexext], 'file')==3
		ext = ['.' mexext];
	elseif exist([fullfilename '.dll'], 'file')==3
		ext = '.dll';
	elseif exist([fullfilename '.mdl'], 'file')==4
		ext = '.mdl';
	elseif exist([fullfilename '.p'], 'file')==6
		ext = '.p';
	elseif exist([fullfilename '.m'], 'file')==2
		ext = '.m';
	end
	fullfilename = [fullfilename ext];
end

function folder2 = getfullpath(folder)
% 用当前路径将相对路径转化为全路径 
% 全路径为c:\...\...\

if isempty(folder)||(folder(2)~=':')	% folder为相对路径
	folder = fullfile(pwd, folder);
else % folder为全路径
	folder = folder;
end

if folder(end) ~= filesep
	folder = [folder filesep];
end

folder2 = folder;


function path = getDesktopPath
% get desktop dictionary path

% desktop dictionary path for english version
eng_path = [getenv('UserProfile') '\desktop'];
% desktop dictionary path for chinese version
chs_path = [getenv('UserProfile') '\桌面'];

if exist(eng_path, 'dir')==7
	path = eng_path;
elseif exist(chs_path, 'dir')==7
	path = chs_path;
end
