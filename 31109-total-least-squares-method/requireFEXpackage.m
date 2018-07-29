function AddedPath = requireFEXpackage(FEXSubmissionID)
%Function requireFEXpackage - 
%installs Matlab Central File Exchange (FEX) submission 
%with given ID into the directory chosen by the user.
%A new FEX submissions may use previous FEX submissions as its part.
%The function 'requireFEXpackage' helps in adding those previous
%submissions to the user's MATLAB installation. 
%
% SYNTAX: 
%    AddedPath = requireFEXpackage(FEXSubmissionID)
%
% INPUT: 
%    ID of the required submission to File Exchange 
%
% OUTPUT: 
%    the path to that submission added to the user's MATLAB path.
%
% HOW TO CALL:
%    The command 
%           P = requireFEXpackage(8277)
%    will download and install the package with ID 8277 
%    (namely, nice 'fminsearchbnd' by John D'Errico)
%
% EXAMPLES -- HOW TO USE:
%
% EXAMPLE 1 (using 'exist' command):
%
%     % first, somewhere in the very beginning of your code,
%     % check if the function 'fminsearchbnd' from the FEX package 8277 
%     % is on your MATLAB path, and if it is not there, 
%     % require the FEX package 8277:
%     if ~(exist('fminsearchbnd', 'file') == 2)
%         P = requireFEXpackage(8277);  % fminsearchbnd is part of 8277
%     end
% 
%     % Then just use 'fminsearchbnd' where you need it:
%     syms x
%     RosenbrockBananaFunction = @(x) (1-x(1)).^2 + 100*(x(2)-x(1).^2).^2;
%     x = fminsearchbnd(RosenbrockBananaFunction,[3 3])

% EXAMPLE 2 (using 'try-catch' command):
%
%     syms x
%     RosenbrockBananaFunction = @(x) (1-x(1)).^2+100*(x(2)-x(1).^2).^2;
%     try 
%        % if function 'fminsearchbnd' already exists in your MATLAB
%        % installation, just use it:
%        x = fminsearchbnd(RosenbrockBananaFunction,[3 3])
%     catch 
%        % if function 'fminsearchbnd' is not present in your MATLAB
%        % installation, first get the package 8277 (to which it belongs) 
%        % from the MATLAB Central File Exchange (FEX)
%        P = requireFEXpackage(8277);  % fminsearchbnd is part of 8277
%        % and then use that function:
%        x = fminsearchbnd(RosenbrockBananaFunction,[3 3])
%     end
% 
%
% NOTE: on Mac platform, the title of the dialog box for 
% choosing the directory for installing the required FEX package 
% is not shown; this is not a bug, this is how UIGETDIR works on Macs --  
% see the documentation for UIGETDIR
% http://www.mathworks.com/help/techdoc/ref/uigetdir.html
%
% (C) Igor Podlubny, 2011


ID = num2str(FEXSubmissionID);

% Ask user for the confirmation of the installation
% of the required FEX package
yes = ['YES, Install package ' ID];
no = 'NO, do not install';
userchoice = questdlg(['The Matlab function/toolbox, which you are running, ' ... 
    'requires the presence of the package ' ID ... 
    ' from Matlab Central File Exchange.' ...
    'Would you like to install the FEX package ' ID ' now?'] , ...
	['Required package ' ID], ...
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

    location = uigetdir(pwd, ['Select the directory for installing the required FEX package' ID ]);
    if location ~= 0
        % download package 'ID' from Matlab Central File Exchange
        filetosave = [location filesep ID '.zip'];
        FEXpackage = [baseURL ID query];
        [f,status] = urlwrite(FEXpackage,filetosave);
        if status==0 
            warndlg(['No connection to Matlab Central File Exchange,' ' or package ' ID ' does not exist.' ... 
                ' Package ' ID ' has not been installed. ' ...
                ' Check you internet settings and the ID of the required package, and try again. '] , ...
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
        unzip(filetosave, todir);
        % after unzipping, delete the downloaded ZIP file
        delete(filetosave);
        % prepend the paths to the downloaded package to the MATLAB path
        P = genpath([location filesep ID]);
        path(P,path);
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



