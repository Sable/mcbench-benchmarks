function [KMZFullFile] = kml2kmz(varargin)
%kml2kmz converts .kml file types into self-contained .kmz filetypes.
%   kml2kmz(KMLFullFile) copies all the support documents used by the kml 
%   into a single 'files' folder, and updates the file path in the kml to
%   the new relative path accordingly.  The kml is also copied, then zipped
%   up with the new copies of supporting files.  The zip file is then 
%   renamed with a .kmz extension, and put in the same folder as the 
%   original kml.  The new copies of supporting documents are then deleted 
%   by default.  Supporting documents referenced by KML attributes are not yet
%   supported.
% 
%   kml2kmz(KMLFullFile,'keepsupportfiles') keeps the extra copies of the 
%   supporting documents.
%
%   kml2kmz(KMLFullFile, 'deleteoriginalkml') deletes the original kml. 
% 
%   Both 'keepsupportfiles' and 'deleteoriginalkml' can be used at the same time.
%
%%%%%%%%%%%%%%%%%%%%
%
%   Still to be Considered: Please contact me if you can help me solve these
%   questions/points.
%       1:  Currently checks for addresses in kml elements, but we need to deal with
%       the kml attribute case too.  I don't have an example to work with.
%       2:  Haven't checked fucntionality on Linux or Mac, but should work
%       as far as I know
%       3:  Haven't checked if ".." notation is handled properly
%       4:  I haven't worked with Alias' before.  Are Targethref and
%       Sourcehref handled properly?
%       5:  Are there other element types I've missed?
%   
% 
%   Author(s): Ryan Bell, ryan.bell@viu.ca
%   Vancouver Island University
%   Version 2.1, December 05, 2012
%
%
%   version 1.0  - intial coding
%   version 2.0  - added internet file download
%                - added check to prevent downloading same file twice
%                - added check to ensure file names don't conflict
%                - removed platform check
%                - added <a href> to catch description text
%                - improved description text and added a todo list
%   version 2.1  - added conditional check for existing, but empty, elements

%% Setup Inputs
    
%     % Defaults;
    keep_support = 0;
    delete_original = 0;
    KMLFullFile = varargin{1};
    % holds a list of files accessed, so we don't copy the same one more than once
    FileList={'source files','destination files'};    
    nin = length(varargin);
    

%% check for incorrect arguments
    % if the input args is more than 1 - it should be either
    % 'keeplimits' or 'keepticks' or both.
    if nin > 1
        for i = nin:-1:2
            if ~(strcmpi(varargin{i},'keepsupportfiles') || strcmpi(varargin{i},'deleteoriginalkml'))
                error('Incorrect input arguments');
            end
        end
    end
    
    % Look for 'keeplimits'
    for i=2:nin
        if strcmpi(varargin{i},'keepsupportfiles')
            keep_support = 1;
        elseif strcmpi(varargin{i},'deleteoriginalkml')
            delete_original = 1;      
        end
    end
  
%% Setup support file/folder names
   % Decide where to keep the temporary support files
    if keep_support
        %put the support files where they can be found
        parentfolder = fileparts(KMLFullFile);
    else
        %put the temporary support files where they won't be noticed
        parentfolder = tempname;
    end

    %location of the temporary support documents
    filesPath = fullfile(parentfolder,'files'); 
    %location of the temporary kml
    tempKMLFullFile = fullfile(parentfolder,'doc.kml');  
    %location of the new kmz
    KMZFullFile = [KMLFullFile(1:end-3) 'kmz'];
    %make sure folder exists
    if ~isdir(filesPath)
        mkdir(filesPath);
    end
    
%% Open file and look for references to local and internet addresses

    %open the original kml as an xDocument
    xDoc = xmlread(KMLFullFile);

    % Go through the kml and find all the referenced files, copy them in to
    % support folder, and update the file names in the kml to relative paths   
    
    % checks for address in elements, but 
    for tag = {'href','targetHref','sourceHref','description'}  %others?  https://developers.google.com/kml/documentation/kmzarchives
        allListitems = xDoc.getElementsByTagName(tag);  %find all the references to external files
        for k = 0:allListitems.getLength-1 %go through each refence (Java index starts at 0)
            thisListitem = allListitems.item(k);
            %make sure xml element isn't empty
            if ~isempty(thisListitem.getFirstChild)
                Contents = char(thisListitem.getFirstChild.getData);  %this is the location of support file
                if strcmp(tag,'description')
                    Description = Contents; %Contents are the description html text
                    [Description, FileList] = handle_description(Description, filesPath,FileList);
                    thisListitem.getFirstChild.setData(Description);
                else
                    SourceFile = Contents; %Contents are the source file
                    [DestinationFile_GE, FileList] = handle_link(SourceFile, filesPath,FileList);
                    thisListitem.getFirstChild.setData(DestinationFile_GE);
                end
            end
        end
    end
    


%% Save the work and Tidy up
    
    % Rewrite the kml with its new file paths
    write_XML_no_extra_lines(tempKMLFullFile,xDoc) %bug fix see:http://www.mathworks.com/matlabcentral/newsreader/view_thread/245555
    % xmlwrite(tempKMLFullFile,xDoc);  %write the updated xml file into out temp directory
 
 
    % This creates a zipped file named 'myKmz.kmz.zip'
    zip(KMZFullFile,{filesPath tempKMLFullFile});   
    %renames the zipped file to 'mykmz.kmz'.
    movefile([KMZFullFile '.zip'], KMZFullFile); 

    if keep_support == 0
        % Delete supporting files
        delete(tempKMLFullFile) %Delete the temp kml
        rmdir(filesPath,'s');  %delete the files folder
    end
    if delete_original == 1
        delete(KMLFullFile);  %delete original kml
    end
    
end

%% Functions...  

%% Check description text for instances of images of 
function [Description, FileList] = handle_description(Description, filesPath,FileList)  
    addresses = [strfind(Description,'img src'),...
                 strfind(Description,'a href')];
    for i = addresses
        j = strfind(Description(i:end),'"')+i;
        SourceFile = Description(j(1):j(2)-2);
        DestinationFile_GE = handle_link(SourceFile, filesPath,FileList);
        Description = [Description(1:j(1)-1) DestinationFile_GE Description(j(2)-1:end)];
    end
end

% Move support file into 'files' folder and convert address relative 
function [DestinationFile_GE, FileList] = handle_link(SourceFile, filesPath,FileList)

    if ~any(strcmp(SourceFile,FileList(:,1)))  %Check if we've copied or download this file already
        [~,FileName,FileExt] = fileparts(SourceFile);
        DestinationFile_GE = ['files/' FileName FileExt]; %relative GE filepath, using GE file separator (/)
        n=1;
        while any(strcmp(DestinationFile_GE,FileList(:,2)))  %Check if this path is already used (eg the file shares a file name, but was in a different folder from a previous support file)
            FileNameOld = FileName;
            FileName = [FileNameOld ' ' num2str(n,'%.0f')];
            DestinationFile_GE = ['files/' FileName FileExt]; %add a numeric extension to this file that shared the same name as a previous support file
            n=n+1;
        end       
        DestinationFile_Local = fullfile(filesPath,[FileName FileExt]);  %destination file path using local file separator
       
        if strcmp(SourceFile(1:4),'http') || strcmp(SourceFile(1:3),'ftp')  %file is on the internet                        
            [~,status] = urlwrite(SourceFile,DestinationFile_Local); %download the file this can be painfully slow for some reason...
            if status == 0
                error(['Problem downloading ' SourceFile]);
            end     

        else  %file is local           
            if ~strcmp(SourceFile(2),':')  %file path relative, add the current folder to the filepath
                SourceFile = fullfile(currentFolder, SourceFile); %change file path from relative to absolute
            end      

            if exist(SourceFile,'file') %check if file to be copied exists              
                status = copyfile(SourceFile,DestinationFile_Local);  % copyfile into the 'files' folders
                if status == 0
                    error(['Problem copying ' SourceFile]);
                end
            else
                error(['Can not find file:' SourceFile]);
            end
        end
        FileList{size(FileList(:,1),2)+1,1} = SourceFile;                %Store the source file for later checking
        FileList{size(FileList(:,1),2)+1,2} = DestinationFile_GE;        %Store the GE relative path for possible, this path may be reused later 
    else
        DestinationFile_GE = FileList{strcmp(SourceFile,FileList(:,1)),2}; % This file is being used again, get the GE relative path 
    end
%     save('kmldata')  %for debug
end

%% bug fix.  See: http://www.mathworks.com/matlabcentral/newsreader/view_thread/245555
function write_XML_no_extra_lines(save_name,XDOC)
    
    XML_string = xmlwrite(XDOC); %open KML as string
    XML_string = regexprep(XML_string,'\n[ \t\n]*\n','\n'); %removes extra tabs, spaces and extra lines

    %Write to file
    fid = fopen(save_name,'w');
    fprintf(fid,'%s\n',XML_string);
    fclose(fid); 
end



         
