function AddedPath = suggestFEXpackage(FEXSubmissionID, RecommendationText)
%Function suggestFEXpackage - 
%Suggest to download another submission from 
%Matlab Central File Exchange (FEX) with given ID,
%and, if this is accepted by the user, 
%installs that suggested submission into the directory chosen by the user.
%A new FEX submissions may use previous FEX submissions as its part.
%The function 'suggestFEXpackage' helps in adding related
%submissions to the user's MATLAB installation. 
%
%This function is a part of File Exchange submission 31069. 
%Download the entire submission:
%http://www.mathworks.com/matlabcentral/fileexchange/31069
%
% SYNTAX: 
%    AddedPath = suggestFEXpackage(FEXSubmissionID, RecommendationText)
%
% INPUT: 
%    FEXSubmissionID: ID of the suggested submission to File Exchange 
%    RecommendationText: text that will appear in the dialog
%
% OUTPUT: 
%    the path to that submission added to the user's MATLAB path.
%
% HOW TO CALL:
%    The command 
%           P = suggestFEXpackage(8277,'One of most useful submissions.')
%    will download and install the package with ID 8277 
%    (namely, nice 'fminsearchbnd' by John D'Errico)
%
% NOTE: on Mac platform, the title of the dialog box for 
% choosing the directory for installing the suggested FEX package 
% is not shown; this is not a bug, this is how UIGETDIR works on Macs --  
% see the documentation for UIGETDIR
% http://www.mathworks.com/help/techdoc/ref/uigetdir.html
%
% (C) Igor Podlubny, 2012


ID = num2str(FEXSubmissionID);

% Ask user for the confirmation of the installation
% of the suggested FEX package
yes = ['YES, Install package ' ID];
no = 'NO, do not install';
userchoice = questdlg(['The Matlab function/toolbox, which you are running, ' ... 
    'suggest you to download the related package ' ID ... 
    ' from Matlab Central File Exchange.' sprintf('\n\n') ... 
    'EXPLANATION: ' sprintf('\n') RecommendationText ...
     sprintf('\n\n') ... 
    'Would you like to install the suggested FEX package ' ID ' now?'] , ...
	['Suggested download: FEX package ' ID], ...
	yes, no, yes);

% Handle response
switch userchoice
    case yes,
        install = 1;			
    case no,
        install = 0;
    otherwise,
        install = 0;
end


if install == 1
    baseURL = 'http://www.mathworks.com/matlabcentral/fileexchange/';
    query = '?download=true';

    location = uigetdir(pwd, ['Select the directory for installing the suggested FEX package' ID ]);
    if location ~= 0
        % download package 'ID' from Matlab Central File Exchange
        filetosave = [location filesep ID '.zip'];
        FEXpackage = [baseURL ID query];
        [f,status] = urlwrite(FEXpackage,filetosave);
        if status==0 
            warndlg(['No connection to Matlab Central File Exchange,' ' or package ' ID ' does not exist.' ... 
                ' Package ' ID ' has not been installed. ' ...
                ' Check you internet settings and the ID of the suggested package, and try again. '] , ...
                ['No connection to Matlab Central File Exchange' ' or package ' ID ' does not exist'], ...
                'modal');
            AddedPath = '';            
            return
        end
        % unzip the downloaded file to the subdirectory 'ID'
        todir = [location filesep ID];
        % if the directory 'ID' doesn't exist at given location, create it
        if ~(exist([location filesep ID], 'dir') == 7)
            mkdir(location, ID);
        end
        try 
            unzip(filetosave, todir);
            % after unzipping, delete the downloaded ZIP file
            delete(filetosave);
            % prepend the paths to the downloaded package to the MATLAB path
            P = genpath([location filesep ID]);
            path(P,path);
        catch
            % if the FEX package is not ZIP, then it is a single m-file
            % just move the file to the ID directory
            [pathstr, name, ext] = fileparts(filetosave);
            movefile(filetosave, [todir filesep name '.m']);
            P = genpath([location filesep ID]);
            path(P,path);
        end
    else
        P = '';
    end

    AddedPath = P; 
else
    AddedPath = '';
end


if install == 1,
    % Ask user about reviewing and saving the modified MATLAB path, 
    % and take him to PATHTOOL, if the user wants to save the modified path
    yes = 'YES, I want to review and save the MATLAB path';
    no = 'NO, I don''t want to save the path permanently';
    userchoice = questdlg(['After adding the package ' ID ... 
        ' from Matlab Central File Exchange to your MATLAB installation,' ...
        ' the MATLAB path has been modified accordingly. ', ...
        'Would you like to review and save the modified MATLAB path?'] , ...
        'Review and save the modified MATLAB path for future use?', ...
        yes, no, yes);
    
    % Handle response
    switch userchoice
        case yes,
            pathtool;			
        case no,
        otherwise,
    end
end



