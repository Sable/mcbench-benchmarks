function mml(varargin)
%MML types the MathML code of a term and displays it in a webbrowser.
%   
%   MML displays the current content of the global variable ANS in the system's 
%   standard webbrowser.
%
%   MML(TERM) displays TERM in the system's standard webbrowser. 
%   
%   MML(OPTION) displays the current content of the global variable ANS according
%   to the display parameter OPTION. 
%
%   MML(TERM,OPTION) displays TERM according to the dispaly parameter OPTION.
%
%   TERM can either be a syntactically valid symbolic or non-symbolic MATLAB 
%   expression or a string containing a syntactically valid symbolic or 
%   non-symbolic MATLAB or Maple expression.
%
%   OPTION can contain a character string from the list of display otions below.
%   'type':  Types the MathML code of the given term in the command window, 
%            and displays the term in the system's standard webbrowser.
%   'nwb':   No Web Browser. Types the MathML code of the given term in the 
%            command window. The term is not displayed in the webbrowser.
%
%   HOW MML WORKS: 
%   The MML function passes the given term to the MATHML[EXPORT] function of the 
%   Maple Kernel. MATHML[EXPORT] returns a string containing the MathML sourcecode
%   of the term.
%   The MML function embeds the MathML code in HTML code and saves it in a file 
%   with the default name "mml_code.htm". This HTML-file is then opened with the 
%   system's standard webbrowser.
%   Code is placed in the header of the HTML file to enable the browser for 
%   displaying MathML code with MathPlayer without being online. For this
%   reason a namespace "m:" is added to each MathML tag.
%   
%   SYSTEM REQUIREMENTS: 
%   1.) Symbolic Math Toolbox 3.0.1 for MATLAB with Maple 8 Kernel or later.     
%   2.) To display the expression in MS Internet Explorer install MATHPLAYER.
%       Download MATHPLAYER (freeware) at
%       http://www.dessci.com/webmath/mathplayer
%                           
%   See also: mmldemo


%   Developed by: 
%   
%   Marko Reinhold and Michael Kempf
%   Hochschule Bremen, Germany 2003 
%
%   for
%
% 	Prof. Dr.-Ing. Joerg J. Buchholz
% 	buchholz.hs-bremen.de
% 	buchholz@hs-bremen.de
% 	
%______
% Declaration of the Arguments Structure in which all option settings are
% saved in named fields. Default values are set.
arguments = struct ('input_term','' ,...
                    'no_webbrowser',0,...
                    'type',0,...
                    'filename','mml_code.htm');

%______
% Parse the user's input for optional arguments and save them to the 
% Arguments Structure.
arguments = parse_arguments(varargin, arguments);

%______
% Hand the input term to Maple's MathML export function and save the returned 
% MathML code to MATHML_SOURCECODE.
MATHML_SOURCECODE=maple('MathML[Export]', char(arguments.input_term));

%______
% Replace some tags of the Maple Kernel's MathML output with new tags.
% Delete this tag.(Replace with empty string)
MATHML_SOURCECODE = regexprep(MATHML_SOURCECODE,...
'<math xmlns=''http://www.w3.org/1998/Math/MathML''>',''); 
% Delete this tag.(Replace with empty string)
MATHML_SOURCECODE = regexprep(MATHML_SOURCECODE,'</math>',''); 
% Add namespace 'm:' to each MathML tag, opening as well as finalizing tags.
MATHML_SOURCECODE = regexprep(MATHML_SOURCECODE,'<','<m:'); 
% Finalizing tags have to have the namespace 'm:' placed behind the slash.
MATHML_SOURCECODE = regexprep(MATHML_SOURCECODE,'<m:/','</m:'); 

% Maple delivers MathML code without linebreaks. These are added here.
MATHML_SOURCECODE = regexprep(MATHML_SOURCECODE,'> ',...
                    ['>',sprintf('%s\r\n',''),' ']  ); 
%______
% Generate HTML code and embed the MathML code in it, in order to make 
% MathML readable for a webbrowser.  
MATHML_SOURCECODE = mystrvcat(...
'<html xmlns:m="http://www.w3.org/1998/Math/MathML">',...
'<head>',...
'<object ID="MathPlayer" CLASSID="clsid:32F66A20-7614-11D4-BD11-00104BD3F987">',...
'</object>',...
'<?import NAMESPACE="m" IMPLEMENTATION="#MathPlayer"?>',...
    '<title>MathML Visualization</title>',...
'</head>',...
'<body>',...
'<m:math style="font-size: 150%">',...
    MATHML_SOURCECODE,...
'</m:math>',...
'</body>',...
'</html>');
                            
%______
% Saves the MATHML_SOURCECODE string to a file.
% For saving the sourcecode the single'%' are replaced with double'%'.
% A double '%' sign is written because 'fprintf' is used below to save 
% this code in a HTML file.
%'%' is a reserved expression in 'fprintf' but '%%' is interpreted as '%'.
MATHML_SOURCECODE_for_saving = regexprep(MATHML_SOURCECODE,'%','%%');

fid = fopen(arguments.filename,'w');         
fprintf(fid,MATHML_SOURCECODE_for_saving);
fclose(fid);

%______
% Deals with the optional arguments given by the user.
% If the user wants the MathML Code to be shown in the MATLAB command window
% (default:disabled).
if arguments.type      
   disp (MATHML_SOURCECODE)  
end

% If the user wants the MathML Code to be shown in the Webbrowser 
% (default:enabled).
% Open the html-file containing the MathML code in the system's standard
% web browser.
if ~arguments.no_webbrowser      
    winopen (arguments.filename) 
end 

%_______________________________________________________________________________
%_______________________________________________________________________________
function arguments = parse_arguments(argsin, arguments_struc)
% Finds the optional arguments passed to MML.
% ARGSIN is the original cell array that is to be parsed
% for known arguments.
% ARGUMENTS_STRUC is the Arguments Structure in which all option settings
% are saved in named fields.
if numel(argsin)==0
        arguments_struc.input_term = sym(evalin('base','ans'));
end

if numel(argsin)==1
    if strcmp(char(argsin{1}),'nwb')
        arguments_struc.input_term = sym(evalin('base','ans'));
        arguments_struc.no_webbrowser = 1;
        arguments_struc.type = 1;
    else
        if strcmp(char(argsin{1}),'type')
            arguments_struc.input_term = sym(evalin('base','ans'));
            arguments_struc.no_webbrowser = 0;
            arguments_struc.type = 1;
        else
            arguments_struc.input_term = sym(argsin{1});
        end
    end        
end

if numel(argsin)==2
    arguments_struc.input_term = sym(argsin{1});
    unknown = 1;
    if strcmp(char(argsin{2}),'nwb')
        arguments_struc.no_webbrowser = 1;
        arguments_struc.type = 1;
        unknown = 0;
    else
        if strcmp(char(argsin{2}),'type')
            arguments_struc.no_webbrowser = 0;
            arguments_struc.type = 1;
            unknown = 0;
        end
    end
    if unknown 
        error(sprintf(...
        'Unknown argument: "%s". Type ''HELP MML'' for further information.',...
        char(argsin{2})))
    end
end

if numel(argsin) > 2
   error(...
   'Too many arguments(max.2). Type ''HELP MML'' for further information.')
end

arguments = arguments_struc;
%_______________________________________________________________________________
%_______________________________________________________________________________
function s = mystrvcat (varargin)
% Concatenates any number of strings linewise (carriage return / line feed)
% for e.g. saving to ASCII-files.

% initialize variable FORMAT_STRING 
format_string = '';
% For each input string.
for i = 1 : (nargin-1)                          
    % Create the format string required by the following SPRINTF function.
    % '%s' = 'wildcard' for the i'th input argument string.
    % '\r' = carriage return,
    % '\n' = line feed.                                            
    format_string = [format_string, '%s\r\n'];  
end
% Write the format_string and each input argument string to the string 's'.
s = sprintf(format_string,varargin{:});
