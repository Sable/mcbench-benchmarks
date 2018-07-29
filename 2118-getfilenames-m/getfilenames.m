function filenames = getfilenames(varargin)
%---GETFILENAMES Returns a cell array of all files matching the
%---wildcard expression
%---"refiles" beginning in the root folder "root". Includes subdirectories
%---Example: mfiles = getfilenames('c:\','*.m') will return all .m files
%---on C drive to the cell array "mfiles".
%
%---If one argument, just a list of returned subfolders.
%---Example: mfiles = getfilenames('c:\') will return all subfolders recursively
%---in the root


root = varargin{1};
if nargin==2,
    refiles = varargin{2};
else
    refiles = [];
end


%---Note: Never tested on a Unix Box.

%---Joe Burgel, General Motors, 8/2002
%---Updated 3/2009 to include folder functionality and removed cd's
%---Updated 5/2009 to extend usage to Mac (and possibly/probably Linux)

filenames = cell(1,100);
i=0;

if ispc
    wildcard='*.*';
elseif ismac
    wildcard='';
end

AllFiles = dir(fullfile(root, wildcard)); %--Everything in this
%---folder, including directories
if ~isempty(refiles),
    MyFiles = dir(fullfile(root , refiles)); %--The files we need in this folder
    %---Build a list of all the files matching the regular expression in
    %---this folder
    for k=1:length(MyFiles)
        if ~MyFiles(k).isdir
            i=i+1;
            if i > length(filenames)
                filenames=[filenames cell(1,100)];
            end
            filenames{i} = fullfile(root, MyFiles(k).name);
        end
    end
else
    MyFiles = dir(root); %--All objects in this folder
    for k=1:length(MyFiles)
        if MyFiles(k).isdir,
            if ~(strcmp(MyFiles(k).name,'.')||strcmp( MyFiles(k).name,'..'))
                i=i+1;
                if i > length(filenames)
                    filenames=[filenames cell(100,1)];
                end
                filenames{i} = fullfile(root, MyFiles(k).name);
            end
        end
    end
end

filenames=filenames(1:i);

%---Do a recursive call of this function for every sub directory of this folder
for k=1:length(AllFiles)
    if AllFiles(k).isdir
        ThisFolder = fullfile(root, AllFiles(k).name);
        if ~(strcmp(AllFiles(k).name,'.')||strcmp(AllFiles(k).name,'..'))
            if  ~isempty(refiles)
                filenames = [filenames  ...
                    getfilenames(ThisFolder,refiles)];
            else
                filenames = [filenames  ...
                    getfilenames(ThisFolder)];
            end
        end
    end
end