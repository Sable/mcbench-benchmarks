function figtopdf(filename, comment, figures)
% -------------------------------------------------------------------------
%FIGTOPDF - Save the current figure as a .pdf image with the (optional)
% given string (without the '.pdf' extension). If no name is given as
% argument, the current figure is saved with the default name 'myfigure'.
% 
% A boolean can be passed as an argument so the function doesn't display any
% comment in the command window. 
% 
% If multiple figures exist in the Matlab environnement, figures can contain
% either all the handles of figures to be saved; otherwhise, only the
% current active figure will be saved.
%
% Syntax: figtopdf(filename, comment, figures)
% -------------------------------------------------------------------------
% Inputs:
%    myfigname  - Optional. Name of the image to save (witouth the '.pdf'
%                  extension)
%    comment    - Optional. Boolean that is true if you don't want the 
%                  function to display any text on the cmmand window. 
%                  Default is false (the function will display a comment 
%                  in the command window by default)
%    figures     - Optional. Either the handles to the figures to be saved
%                   or a string containing 'all' that specifies that all
%                   the existing figures have to be saved. In the latter
%                   case, '-i' is added after the file name, with i the
%                   number of the figure.
%
% Outputs:
%    none
%
% Examples: 
%    figtopdf()                                     % Save the current figure as "myfigure.pdf".
%    figtopdf('nameofmyfigure')                     % Save the current figure as "nameofmyfigure.pdf".
%    figtopdf('nameofmyfigure', false)              % Save the current figure as "nameofmyfigure.pdf" and
%                                                       don't display any message in the command window.
%    figtopdf('nameofmyfigure', false, [h1, h2])    % Save the figures that have h1 and h2 as handles figure as
%                                                       "nameofmyfigure-1.pdf" and "nameofmyfigure-2.pdf" and don't
%                                                       display any message in the command window.
%    figtopdf('nameofmyfigure', false, 'all')       % Save all the existing figures as "nameofmyfigure-i.pdf", 
%                                                       with i the number of the figure, and don't display 
%                                                       any message in the command window.
% -------------------------------------------------------------------------
% Other m-files required:   none
% Subfunctions:             none
% MAT-files required:       none
% Other file required:      none
% -------------------------------------------------------------------------
% Copyright 2013
% Author: Alexandre Willame & Antoine Berthelemot
% June 2013; Last revision: 11-June-2013
% -------------------------------------------------------------------------

%------------- BEGIN CODE --------------



%% Initialisation

if (~exist('filename', 'var'))
    filename = 'myfigure';                  % Default figure name
end
if (~exist('comment', 'var'))
    comment = false;                      % Display message in the command window by default
end
if (~exist('figures', 'var'))
    figures = gcf;                          % Print the active figure by default
elseif(strcmpi(figures, 'all'))
        figures = findobj('Type','figure'); % Print all the figures if asked
end                                         % Otherwhise, just print the figures whose handles are the ones given in 'figures'
n = length(figures);

%% Save figures

% Save each figure
for i=1:n
    if (n>1)
        finalfilename = sprintf('%s-%d', filename, i);
    else
        finalfilename = filename;
    end
    
    figure(figures(n-i+1));                    % Make the (n-i)th figure the active one
    print('-depsc','-tiff', finalfilename);    % fig to eps
    dos(['epstopdf "' finalfilename '".eps']); % eps to pdf
    delete([finalfilename '.eps']);            % delete extra '.eps' file
    
    %% Message in the Command Window
    if (~comment)
        str = sprintf('Image "%s.pdf" saved.', finalfilename);
        disp(str);                        % Confirmation message in the command window
    end
end

%------------- END OF CODE --------------
end

