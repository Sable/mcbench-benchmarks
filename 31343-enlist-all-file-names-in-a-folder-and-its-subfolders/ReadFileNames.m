function [ FList ] = ReadImageNames(DataFolder)
% Author: Thokare Nitin D.
% 
% This function reads all file names contained in Datafolder and it's subfolders
% with extension given in extList variable in this code...
% Note: Keep each extension in extension list with length 3
% i.e. last 3 characters of the filename with extension
% if extension is 2 character length (e.g. MA for mathematica ascii file), use '.'
% (i.e. '.MA' for given example)
% Example:
% extList={'jpg','peg','bmp','tif','iff','png','gif','ppm','pgm','pbm','pmn','xcf'};
% Gives the list of all image files in DataFolder and it's subfolder
% 
DirContents=dir(DataFolder);
FList=[];

if(strcmpi(computer,'PCWIN') || strcmpi(computer,'PCWIN64'))
    NameSeperator='\';
elseif(strcmpi(computer,'GLNX86') || strcmpi(computer,'GLNXA86'))
    NameSeperator='/';
end

extList={'jpg','peg','bmp','tif','iff','png','gif','ppm','pgm','pbm','pmn','xcf'};
% Here 'peg' is written for .jpeg and 'iff' is written for .tiff
for i=1:numel(DirContents)
    if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
        if(~DirContents(i).isdir)
            extension=DirContents(i).name(end-2:end);
            if(numel(find(strcmpi(extension,extList)))~=0)
                FList=cat(1,FList,{[DataFolder,NameSeperator,DirContents(i).name]});
            end
        else
            getlist=ReadImageNames([DataFolder,NameSeperator,DirContents(i).name]);
            FList=cat(1,FList,getlist);
        end
    end
end

end

