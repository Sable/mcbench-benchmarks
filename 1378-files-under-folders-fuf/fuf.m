function srtlist = fuf (folders,reclev,opt)
%FUF recursively retrieves files under specified folder(s).
%   
%   Syntax: srtlist = fuf (folders,reclev,opt)
%
%   INPUT ARGUMENTS
%       - folders       can be a character array or a cell array of strings. Valid strings
%                       are matlab path;  
%       - reclev        {1} optional scalar/numeric array  of  booleans: 1 stands for recursive
%                       search, whilst 0 limit the search to the specified folder.
%                       reclev can be either a scalar, or a 1 X length(folders) array.
%                       Use the 2nd option to specify the search rule on a folder-basis.
%                       Default is 1, i.d., each folder is searched for recursively.
%       - opt           {'normal'} | 'detail'  is an optional field: when it's set to 'detail',
%                       FUF returns the full path of files searched for, while, when set to
%                       normal, it returns file names only.
%
%
%   OUTPUT ARGUMENT
%       - srtlist   is a sorted cell array of strings containing the name or the full path
%                       of files recursively found under the given folders.
%
%   FUF applies the wildcard * for searching files through all the directories beneath the given folder(s)
%   if the reclev parameter is set to 1. If you want to have different wildcards for folders belonging
%   to the same tree root, you need to pass them separately as input arguments.
%
%   REMARKS
%       - Folders don't have to belong to the same directory, therefore this function doesn't
%         have to be invoked from a particular directory.
%       - Matlab partial paths are not valid input arguments.
%       - Wildcard * can be used to narrow the search.
%       - To get the full path of a given file, FUF doesn't use the which command,
%         therefore it normally works also with java function that are not loaded.
%       - After completion, the working directory is set to the current directory at the time
%         of the function call.
%
%   EXAMPLES
%
%   To retrieve all files under the folder Utils:
%
%       >>  dir('C:\matlabR12\work\Interface\Utils')
%
%           .                       Contents.m              
%           ..                      my_interface_evalmcw.m  
%
%   To retrieve recursively the full path of all .m files starting with Cont under the folder work:
%
%       >> fuf('C:\matlabR12\work\Con*.m','detail')
%
%           'C:\matlabR12\work\Laboratorio_modellistica\DTT\Contents.m'
%           'C:\matlabR12\work\Laboratorio_modellistica\SDF\Contents.m'
%           'C:\matlabR12\work\PREPOSTGUIS\Contents.m'
%           'C:\matlabR12\work\PREPOSTGUIS\Utils\Contents.m'
%           'C:\matlabR12\work\Pavia\Contents.m'
%           'C:\matlabR12\work\TwoLe_front_end\Contents.m'
%           [1x74 char]
%           'C:\matlabR12\work\TwoLe_front_end\My_Classes\@Sector\Contents.m'
%           'C:\matlabR12\work\TwoLe_front_end\Utils\Contents.m'
%           'C:\matlabR12\work\Utils\Contents.m'
%
%   To retrieve recursively under the folder PREPOSTGUIS all .fig files and non recursively, under
%   the folder MatlabR12 all .txt files:
%
%       >> fuf({'C:\matlabR12\work\PREPOSTGUIS\*.fig','C:\matlabR12\*.txt'},[1,0],'detail')
%
%               'C:\matlabR12\license.txt'
%               'C:\matlabR12\work\PREPOSTGUIS\Private\MV_Manager.fig'
%               'C:\matlabR12\work\PREPOSTGUIS\R_h.fig'
%               'C:\matlabR12\work\PREPOSTGUIS\TSA.fig'
%               'C:\matlabR12\work\PREPOSTGUIS\Visual_3D.fig'       

%                                         -$-$-$-
%
%        Author:    Francesco di Pierro                  Reasearch Assistant
%                                                    Center for Water Systems (CWS)
%                                                Dep. of Engineering and Computer Science
%                                                        University of Exeter
%                                                    e-mail: <F.Di-Pierro@ex.ac.uk>
%
%                                         -$-$-$-




%--------------------CHECK INPUT ARGUMENT TYPE AND SET DEFAULT VALUES------------------------%

%argument cheking and parsing default parameters

error(nargchk(1,3,nargin));
error(nargoutchk(0,1,nargout));
INITIAL_DIR = pwd;
if nargin==1
    if ischar(folders)
        folders = cellstr(folders);
    elseif ~iscellstr(folders)
        error('The 1st argument to the function fuf must be either a string or a cellstring!')
    end
    reclev = ones(size(folders));
    opt = 'normal';
elseif nargin==2
    if ischar(folders)
        folders = cellstr(folders);
    elseif ~iscellstr(folders)
        error('The 1st argument to the function fuf must be either a string or a cellstring!')
    end
    if isnumeric(reclev)
        if ~all(ismember(reclev,[0,1]))
            error('The 2nd argument to the function  must be a scalar/vector of booleans!')
        end
        if prod(size(reclev))==1
            reclev = reclev*ones(size(folders));
        elseif prod(size(reclev))~=prod(size(folders))
            error('The 2nd argument to the function must be a either a scalar or a 1 X length(1st argument) array!')
        end
        opt = 'normal';
    elseif ~ischar(reclev) | ~any(strcmp(reclev,{'normal','detail'}))
        error('Mismatched argument specification; the 3rd argument can be either set to ''normal'' or ''detail''');
    else
        opt = reclev;
        reclev = ones(size(folders));
    end
else
    if ischar(folders)
        folders = cellstr(folders);
    elseif ~iscellstr(folders)
        error('The 1st argument to the function fuf must be either a string or a cellstring!')
    end
    if isnumeric(reclev)
        if ~all(ismember(reclev,[0,1]))
            error('The 2nd argument to the function must be a scalar/vector of booleans!')
        end
        if prod(size(reclev))==1
            reclev = reclev*ones(size(folders));
        elseif prod(size(reclev))~=prod(size(folders))
            error('The 2nd argument to the function must be a either a scalar or a 1 X length(1st argument) array!')
        end
    else
        error('The 2nd argument to the function must be a scalar/vector of booleans!')
    end
    if ~ischar(opt) | ~any(strcmp(opt,{'normal','detail'}))
        error('Mismatched argument specification: Tte 3rd argument to the function must be either set to ''normal'' or ''detail''');
    end
end

%scan folders searching for incorrect folder names and partialpaths!!!
EXIT = 0;
for i=1:length(folders)                                 
    [d,f,e] = fileparts(folders{i});                    
    if (~isdir(d) & ~isempty(e))
        warning(['"',d,'" is not a valid folder name!'])
        EXIT = 1;
    elseif (~isdir(fullfile(d,f,'')) & isempty(e))
        warning(['"',fullfile(d,f,''),'" is not a valid folder name!'])
        EXIT = 1;
    elseif (isempty(dir(d)) & ~isempty(e)) | (isempty(dir(fullfile(d,f,''))) & isempty(e))
        warning('Matlab PARTIALPATHS not allowed!') 
        EXIT = 1;
    else                                                %this cheks the very unlike event arising
        sub = dir(pwd);                                 %when the partial path provided is a directory
        [subel{1:length(sub)}] = deal(sub.name);        %under the current one: this, in fact, is the
        [subtype{1:length(sub)}] = deal(sub.isdir);     %only situation where the dir command handles 
        testel1 = strcmp(subel,fullfile(d,f,''));       %partialpaths!!!
        testel2 = strcmp(subel,d);
        if ~isempty(subtype(testel1)) | ~isempty(subtype(testel2))
            warning('Matlab PARTIALPATHS not allowed!')
            EXIT = 1;
        end
    end
end    
if EXIT 
    disp('')
    error(strvcat('One or more not valid folder names encountered! Function aborted!'))
end


%--------------------------------CORE FUNCTION--------------------------------%

sorted_list = [];                                           %initialize the output list

sorted_list = rec(sorted_list,folders,reclev,opt);          %call the function

sorted_list = sortrows(sorted_list);                        %sort the list

if nargout, srtlist = sorted_list; else disp (' '),disp(sorted_list), end

cd(INITIAL_DIR);                                            %and set current directory back to the initial one

%--------------------------------RECURSIVE FUNCTION--------------------------------%

function sorted_list = rec(sorted_list,folders,reclev,opt)

for i=1:length(folders)
    %first build the new search condition made of all files satistying the
    %search condition and all directories under the current one
    val = []; val1 = []; val2 = []; cnval1 = {}; cnval2 = {}; cdval = {}; cdva2 = {};   %initialize helper variables
    [pth,fname,ext] = fileparts(folders{i});            
    cd(pth);                                            %move to the directory: isdir only recognizes directories on the Matlab search path or the current one!
    if isdir(fname)   
        wild = '';
        cd(fname)
        pth = fullfile(pth,fname);
        val = dir;
    else
        %get the filenames satisfying the search condition
        val1 = dir(folders{i});                         
        wild = [fname,ext];
        if isempty(val1)
            cnval1 = [];    cdval1 = [];
        else
            [cnval1{1:length(val1)}] = deal(val1.name); [cdval1{1:length(val1)}] = deal(val1.isdir);
        end
        %and the directory/ies under the current one
        val2 = dir;                                     
        wo = logical(zeros(size(val2)));
        for k=1:length(val2)
            if val2(k).isdir
                wo(k) = 1;
            end
        end
        val2(~wo) = [];
        %and build the new search structure
        [cnval2{1:length(val2)}] = deal(val2.name); [cdval2{1:length(val2)}] = deal(val2.isdir);
        cnval = [cnval1,cnval2];    cdval = [cdval1,cdval2];    
        [val(1:length(cnval)).name] = deal(cnval{:}); [val(1:length(cdval)).isdir] = deal(cdval{:}); 
    end
    for j=1:length(val)
        if (val(j).isdir) & not(strcmp(val(j).name,'.')) & not(strcmp(val(j).name,'..'))    %if the jth object under the ith folder is a valid folder name(directory)...
            new_path = fullfile(pth,val(j).name);                                           %set the current directory to that one:
            cd(new_path);                           
            if reclev(i)                            %recursively call the function keeping in mind the search condition
                sorted_list = rec(sorted_list,{fullfile(new_path,wild)},reclev(i),opt);
            end
            cd ..                                   %get back to the previous directory                            
        elseif not(strcmp(val(j).name,'.')) & not(strcmp(val(j).name,'..')) %if the jth object under the ith folder is a valid file name
            if strcmp(opt,'detail')
                sorted_list =[sorted_list; cellstr(fullfile(pwd,val(j).name))];
            else
                sorted_list =[sorted_list; cellstr(val(j).name)];
            end
        end
    end
end