%% Using the Google Toolbox
% By Matthew Simoneau
% 
% This is a basic introduction to the Google Toolbox, available on the 
% MATLAB Central File Exchange:
% <http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1613>

%% Setup
% Download this submission and put the M-files on your MATLAB path. One
% way to do this is to add the directory containing them with ADDPATH. For
% more information on ADDPATH, see
% <http://www.mathworks.com/access/helpdesk/help/techdoc/ref/addpath.shtml>.

cd P:\Matthew_Simoneau\google
addpath(pwd)

%% 
% Go to <http://www.google.com/apis/> and download the developer's kit.
% Unzip the download and copy googleapi.jar to a convenient place.

zipUrl = 'http://api.google.com/googleapi.zip';
unzip(zipUrl,'.')

%%
% Add JAR file to your Java classpath.  On older versions of MATLAB, you 
% need to modify |toolbox/local/classpath.txt|, but on newer versions you can
% use JAVAADDPATH.  For more info, see
% <http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_external/f4867.html>.

%edit classpath.txt
javaaddpath(fullfile(pwd,'googleapi','googleapi.jar'))

%%
% Back at Google's site, <http://www.google.com/apis/>, create a Google
% account. You'll just need to give them your e-mail address so they can
% validate it and send you an access key.

web http://www.google.com/apis/ -browser

%%
% Before using the functions, set the key in your preferences:

%key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
setpref('google','key',key);


%% Finding Pages about MATLAB
% Now use GOOGLESEARCH to get information about a search for "matlab".

s = googlesearch('matlab',30);
disp(s)

%%
disp(char(s.ResultElements.URL))

%%
disp(s.EstimatedTotalResultsCount)

%%
for i = 1:s.EndIndex
    % Strip HTML from the title.
    title = s.ResultElements(i).Title;
    title = regexprep(title,'<\/?b>','');
    title = strrep(title,'&gt;','>');
    title = strrep(title,'&lt;','<');
    title = regexprep(title,'&#(\d+);','${char(str2double($1))}');
    title = strrep(title,'&amp;','&');
    
    % Display the title and URL for each page.
    fprintf('%4.0f) %s\n      %s\n\n', ...
        i,title,s.ResultElements(i).URL)
end

%% Opening Up a Web Page
% Use FEELINGLUCKY to jump straight to the first hit for "MathWorks".

feelinglucky MathWorks
