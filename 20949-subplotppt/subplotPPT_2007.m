function subplotPPT(m,n,p,FigH,filename,SlideNum,varargin)

% Print a figure to a region of a powerpoint slide.
%
% syntax:
%       subplotPPT(m,n,p)
%       subplot(m,n,p,h)
%       subplot(m,n,p,h,filename)
%       subplot(m,n,p,h,filename,SlideNum)
%       subplot(m,n,p,h,filename,SlideNum,prop,propval,...)
%
% Inputs:
%   m:          number of rows of subplots wanted in the slide (similar to subplot)
%   n:          number of columns of subplot wanted in the slide (similar to
%               subplot)
%   p:          indices of subplots to use.
%   FigH:       Handles of figure to use (if missing, use GCF)
%   filename:   Name of powerpoint file to use. If absent, create a new file
%               called temp.ppt in current directory
%   SlideNum:   number of slide to print to. If not present create a new
%               slide and print to that.
%
% Additional porperties:
%   Region:     Area of slide to put grid, represented as
%               [left bottom width hight] where these values are relative
%               to the scaling of the slide (i.e. all values between 0 and
%               1). Default is [0 0 1 1] (in normalised units)
%   units:      units to measure in - pixels or <norm>
%   hgap:       horizontal gap between columns, default is 0
%   vgap:       vertical gap between layers, default is 0
%   GapUnits:   Units for specifying gaps in - <pixels> or norm. Here
%               because if a 10 point gap is required working out that this
%               is /72 time the slide width might prove a hassle. Used for
%               both vgap and hgap.
%   ImageFormat:What type of image file should we print to for the image 
%               files before they get pasted into PowerPoint? All standard 
%               options as provided by saveas are catered for, default is 
%               jpg
%
% If you wish to plot a figure to several subplot locations then p can take
% the value: p = [q,s] where q and s are the indices of the first and last
% grid locations to merge.
%
% If you wish to plot multiple figures to the same axis then h can be a
% vector of figure handles to use and p can then either be an n by 1 or n
% by 2 matrix of grid locations.
%
% Examples
%
%   % Create some image files:
%   
%   h(1) = figure; peaks;
%   h(2) = figure; membrane;
%   h(3) = figure; spy;
%   h(4) = figure; klein1;
%   h(5) = figure; tori4;
%
%   % Powerpoint file to use   
%   filename = [pwd,filesep,'test.ppt'];
%
%   % Paste the first 4 figures to powerpoint in a loop:
%   for ii = 1:numel(h)-1
%       subplotPPT(2,2,ii,h(ii),filename,1);
%   end
%
%   % Paste the first 4 figures (in reverse order) to powerpoint in one statement
%   subplotPPT(2,2,[4:-1:1],h(1:4),filename,2);
%
%   % Paste the five figures to power point merging the cells, specifying
%   % the region to paste in normalised units
%   subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,filename,3,...
%       'region',[.1 .1 .8 .8],'hgap',10,'vgap',10);
%
%   % Paste the five figures to powerpoint using a different region
%   subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,filename,4,...
%       'region',[200 100 500 340],'hgap',10,'vgap',10,'units','pixels');
%
%   % Paste the figures to powerpoint using a different image format
%   subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,filename,5,...
%       'region',[200 100 500 340],'hgap',.1,'vgap',.1,'gapunits','norm','units','pixels',...
%       'ImageFormat','emf');
%   
%   % Open the powerpoint file
%   winopen(filename);
%
% 
% Copyright 2008, The MathWorks, Inc. MATLAB and Simulink are registered
% trademarks of The MathWorks, Inc. See www.mathworks.com/trademarks for a 
% list of additional trademarks. Other product or brand names may be 
% trademarks or registered trademarks of their respective holders.


if nargin < 3
    error('subplotPPT requires at least three inputs');
end
if nargin < 4 || isempty(FigH)
    FigH = gcf;
end
if nargin < 5
    filename = []; % place holder - will promt user to specify a file
end
if nargin < 6 || isempty(SlideNum)
    SlideNum = -1; % place number 
end

FormatData = [];
FileData = [];

nProcessInputs(varargin{:});

% If p is 1 by n, n > 2 then transpose p, If p is 1 by 2 and h has two
% elements, transpose p, if p is 1 by 2 and h has 1 element leave p,
% otherwise p has to be n by 2

S = size(p); 
if S(1) == 1
    if S(2) > 2
        p = p';
    elseif S(2) == 2 
        if numel(FigH) == 2
            p = p';
        elseif numel(FigH) == 1
            % leave
        else 
            error(['Number of grid locations must be the same length as the',...
        ' number of figures to print']);
        end
    end
else
    if S(2) ~= 2
        error('Grid locations must be a matrix with either 1 or 2 columns');
    end
end

if size(p,1) ~= numel(FigH)
    error(['Number of grid locations must be the same length as the',...
        ' number of figures to print']);
end

% create directory for the images

OK = nProcessFileName(filename);
if ~OK 
    % User cancelled out when prompted to select a file
    return
end

% Get a handle to PowerPoint
pptHandle = actxserver('PowerPoint.Application');

% Create a new presentation
if exist(FileData.FileName,'file') == 2 && FileData.FileType == 1
    presentation = invoke(pptHandle.Presentations,'Open',FileData.FileName,[],[],0);
else
    presentation = pptHandle.Presentations.Add;
end

% Work out dimensions of slide
SlideWdh = presentation.PageSetup.SlideWidth;
SlideHgt = presentation.PageSetup.SlideHeight;

% Find dimensions of the region we print to.
if strcmpi(FormatData.Units,'norm')
    RegLeft = SlideWdh*FormatData.Region(1);
    RegTop = SlideHgt*(1-FormatData.Region(2)-FormatData.Region(4));
    RegWdh = SlideWdh*FormatData.Region(3);
    RegHgt = SlideHgt*FormatData.Region(4);
else
    RegLeft = FormatData.Region(1);
    RegTop = SlideHgt-FormatData.Region(2)-FormatData.Region(4);
    RegWdh = FormatData.Region(3);
    RegHgt = FormatData.Region(4);
end

% No work out the sizes of the gaps
if strcmpi(FormatData.GapUnits,'norm')
    hgap = FormatData.hgap*SlideHgt;
    vgap = FormatData.vgap*SlideWdh;
else
    hgap = FormatData.hgap;
    vgap = FormatData.vgap;
end
% get relevant slide

SlideCount = presentation.Slides.Count;
% Add slides until we get to the right number
if SlideNum < 0
    % Create a new slide at the end of the presentation
    SlideNum = SlideCount+1;
end
    
while SlideNum > SlideCount
    presentation.Slides.AddSlide(SlideCount+1,presentation.SlideMaster.CustomLayouts.Item(7));
    SlideCount = presentation.Slides.Count;
end

slide = presentation.Slides.Item(SlideNum);

for ii = 1:numel(FigH)
    % Save the file to the relevant format
    % Find out how many files there are in the ImageHome directory
    saveas(FigH(ii),[FileData.ImageHome,filesep,'temp'],FormatData.ImageFormat);
    cpos = nGetLocation(p(ii,:));
    slide.Shapes.AddPicture([FileData.ImageHome,filesep,'temp','.',FormatData.ImageFormat],...
        0,1,cpos(1),cpos(2),cpos(3),cpos(4));
end

switch FileData.FileType
    case 1
        presentation.SaveCopyAs(FileData.FileName,FileData.Flag,0);
    case 2
        % We are saving to an image file. 
        % Powerpoint does this by saving to a folder with the same name as
        % the file and putting an image of "SlideN.ext" in the file. We
        % want to save to our particular filename. Do this by invoking the
        % powerpoint save first (saving to a directory of our choosing),
        % then move the resulting file and save it under the chosen name.
        SaveName = [FileData.SaveFolder,FileData.Extension];
        presentation.SaveCopyAs(SaveName,FileData.Flag,0);
        % Now move the slide file and save it as the the file we want to
        % save it as
        SourceFile = [FileData.SaveFolder,filesep,'Slide1',FileData.Extension];
        copyfile(SourceFile,FileData.FileName);
        rmdir(FileData.SaveFolder,'s');
end
presentation.Close;

rmdir(FileData.ImageHome,'s');
pptHandle.Quit;
delete(pptHandle);

% -------------------------------------------------------------------------
    function nProcessInputs(varargin)

        if rem(numel(varargin),2) ~= 0
            error('Incorrect number of inputs');
        end
        
        % Set up defaults
        FormatData.Region = [0 0 1 1];
        FormatData.Units = 'norm';
        FormatData.hgap = 0;
        FormatData.vgap = 0;
        FormatData.GapUnits = 'pixels';
        FormatData.ImageFormat = 'jpg';
        
        for jj = 1:2:numel(varargin)
            prop = varargin{jj};
            value = varargin{jj+1};
            switch lower(prop)
                case 'region'
                    % Must be non -ve four element vector
                    if ~isnumeric(value) || any(value) < 0 || numel(value ) ~= 4
                        error('Region must have consist of four non negative elements');
                    end
                    FormatData.Region = value;
                case 'units'
                    % Either norm or pixels
                    if ~ischar(value) || ~(strcmpi(value,'norm') || strcmpi(value,'pixels'))
                        error('Units must be either norm or pixels');
                    end
                    FormatData.Units = lower(value);
                case 'hgap'
                    % non negative number
                    if ~isnumeric(value) || value < 0
                        error('hgap must be a non negative number');
                    end
                    FormatData.hgap = value;
                case 'vgap'
                    % non negative number
                    if ~isnumeric(value) || value < 0
                        error('vgap must be a non negative number');
                    end
                    FormatData.vgap = value;
                case 'gapunits'
                    % norm or pixels
                    if ~ischar(value) || ~(strcmpi(value,'norm') || strcmpi(value,'pixels'))
                        error('GapUnits must be either norm or pixels');
                    end
                    FormatData.GapUnits = value;
                case 'imageformat'
                    % Valid image type
                    ImgTypes = {'ai','bmp','emf','eps','jpg','pbm','pcx','png','ppm','tif'}';
                    Idx = strmatch(value,ImgTypes);
                    if isempty(Idx)
                        error(['Invalid image type specified, image type must be one of: ',...
                            strvcat(ImgTypes)]);
                    end
                    FormatData.ImageFormat = value;
            end
        end
    end
% -------------------------------------------------------------------------
    function cpos = nGetLocation(P)

        CellWdh = (RegWdh-(n-1)*hgap)/n;
        CellHgt = (RegHgt-(m-1)*vgap)/m;

        % Find "indices" for the subregion we care about
        J = rem(P,n);  J(J == 0) = n;
        I = (P-J)/n+1;
        
        cpos(1) = (J(1)-1)*(CellWdh+hgap)+RegLeft;
        cpos(2) = (I(1)-1)*(CellHgt+vgap)+RegTop;
        cpos(3) = (J(end)-J(1)+1)*(CellWdh+hgap)-hgap;
        cpos(4) = (I(end)-I(1)+1)*(CellHgt+vgap)-vgap;
        
    end
% -------------------------------------------------------------------------
    function OK = nProcessFileName(filename)
       
        % Analyse the file name - are we saving as a power point file or as
        % an image file
        OK = true;
        if isempty(filename)
            % Prompt user to select a file
            FileTypes = {...
                '*.ppt','PowerPoint File (*.ppt)';...
                '*.bmp','Bitmap File (*.bmp)';...
                '*.emf','Meta File (*.emf)';...
                '*.gif','GIF File (*.gif)';...
                '*.jpg','JPG File (*.jpg)';...
                '*.png','PNG File (*.png)';...
                '*.tif','TIF File (*.tif)'};
            [fname,pname] = uiputfile(FileTypes,...
                'Select a file','temp.ppt');
            if isempty(fname)
                % User cancelled out
                OK = false;
            end
            filename = [pname,fname];
        end
        [path,file,ext] = fileparts(filename);
        if isempty(path)
            % Path is not given - assume pwd
            path = pwd;
            filename = [path,filesep,filename];
        end
        FileData.Path = path;
        FileData.FileName = filename;
        FileData.Extension = ext; % We store this since we'll use it if 
                                  % we need to save the result as an image file
        
        % Create a unique folder to save images to.
        FileData.ImageHome = nUniqueFolder;                          
        switch lower(strrep(ext,'.',''))
            case 'ppt'
                % PowerPoint File
                FileType = 1;
                flag = 11; % ppSaveAsDefault
            case 'bmp'
                % Bitmap
                FileType = 2;
                flag = 19; % ppSaveAsBMP
            case 'gif'
                % GIF
                FileType = 2;
                flag = 16; % ppSaveAsGIF
            case 'jpg'
                % JPEG
                FileType = 2;
                flag = 17; % ppSaveAsJPG
            case 'emf'
                % Meta file
                FileType = 2;
                flag = 15; % ppSaveAsMetaFile
            case 'png'
                 % PNG 
                FileType = 2;
                flag = 18; % ppSaveAsPNG
            case 'tif'
                % TIF
                FileType = 2;
                flag = 21; % ppSaveAsTIF
            otherwise
                error('subplotPPT:: Unknown file format');
        end
        FileData.FileType = FileType;
        if FileType == 2
            % we are printing to an image file, reset slide number to 1
            SlideNum = 1;
            FileData.SaveFolder = nUniqueFolder;
        end
        FileData.Flag = flag;
    end
% -------------------------------------------------------------------------
    function FolderName = nUniqueFolder
        % Create a folder with a unique name so that we don't overwrite or
        % destroy any existing folders.
        stub = [pwd,filesep,'subplotPPT_Folder'];
        count = 1;
        FolderName = [stub,sprintf('%g',count)];
        while exist(FolderName,'dir') == 7
            count = count+1;
            FolderName = [stub,sprintf('%g',count)];
        end
        OK = mkdir(FolderName);
        if ~OK
            error('MATLAB could not create the folder to store image files');
        end
    end   
end