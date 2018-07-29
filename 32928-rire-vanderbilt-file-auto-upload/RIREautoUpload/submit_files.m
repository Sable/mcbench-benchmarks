function status = submit_files(login, password, method_http, filepath, submitFlag)

% This function constructs the system command line to call the java upload
% script to interact with RIRE website. The java script logs into the RIRE
% website, creates new method there, uploades the files and optionally
% submits the method. The name of the method is derived from the name of
% the folder that contains files to be uploaded. This folder is also
% supposed to contain the method description file, which is an ASCII text 
% file with extension .desc
%
% Parameters:
%
% login       - your RIRE login, for example boris.oreshkin@mail.mcgill.ca
% password    - your RIRE password
% method_http - your RIRE personal page, http://www.insight-journal.org/rire/myprofile.php
% filepath    - directory containing files to be uploaded
% submitFlag  - whether or not to submit the method (1 submit, 0 do not submit)
%
%(c) Borislav N. Oreshkin

if ispc 
    command_string = ['java -jar ', pwd, '\UploadScript.jar ', ...
        login, ' ' password, ' ', method_http, ' ', filepath];
elseif isunix
    command_string = ['java -jar ', pwd, '/UploadScript.jar ', ...
        login, ' ' password, ' ', method_http, ' ', filepath];
end;

if submitFlag
    command_string = [command_string, ' submit'];
else
    command_string = [command_string, ' nosubmit'];
end

[status,result] = system(command_string,'-echo');
