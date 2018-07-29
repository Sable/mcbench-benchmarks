function stemleafplot(v,p)
% Plots stem and leaf plot to command window
%
% stemleafplot(v)
% stemleafplot(v,p)
%
% STEMLEAFPLOT plots stem-leaf plots of the input V to the command window.
% Leaf precision may be defined by the user. Note that inputs will be
% rounded to the nearest leaf unit (http://en.wikipedia.org/wiki/Stemplot).
%
% INPUT
%   V   : Array of numerical inputs (NaN values are ignored)
%
% OPTION
%   P   : Leaf precision (defined as integer power of 10)
%         Stem precision (by default) is 10^(P+1).
%         P is automatically rounded at the beginning of the function.
%         Leaf and stem units are printed at the bottom of the graph.
%         Examples: P = -3 rounds V to the nearest 10^-3 = 0.001
%                   P = 3 rounds V to the nearest 10^3 = 1000
%         [DEFAULT: P = 0]
%
% OUTPUT
%   Command window output
%
% EXAMPLES
%   % Stem-leaf plot of V with unit precision
%   V = 10.*randn(1,50);
%   stemleafplot(V)
%
%   % Stem-leaf plot of V with precision of 0.1
%   V = randn(1,50);
%   stemleafplot(V,-1)
%
%   % Stem-leaf plot of V with precision of 100
%   V = 5000.*randn(1,50);
%   stemleafplot(V,2)
%   
% Jered Wells
% 01/28/2011
% jered [dot] wells [at] duke [dot] edu
%
% v1.2 (02/14/2012)
%

if ~isnumeric(v); error 'Input V must be numeric'; end
if ~exist('p','var'); p = 0; elseif isempty(p); p = 0; end
if ~isnumeric(p); error 'Input P must be an integer'; end
p = round(p);


% Condition V
v = v(~isnan(v));
v = v(:);
v = roundn(v,p);

% Organize stems and leaves
allstems = floor(v./10^(p+1));
allleaves = round(abs(v./10^p));

nstems = allstems(allstems<0)+1; 	% Negative stems
nstems = nstems(:);
pstems = allstems(~(allstems<0));	% Positive stems
pstems = pstems(:);

nleaves = allleaves(allstems<0);    % Negative leaves
nleaves = nleaves(:);
pleaves = allleaves(~(allstems<0)); % Negative leaves
pleaves = pleaves(:);

dig = ceil(max(log10(abs(allstems))))+1;    % Max # of digits in stem
form = strcat(['%' num2str(dig+1) 'i']);    % Format string for SPRINTF

% Plot negative stems
if ~isempty(nstems)
    for ii = min(nstems(:)):0
        strstem = sprintf(form,ii);
        if ii==0; strstem(end-1:end) = '-0'; end
        strleaves = sprintf('%2i',mod(sort(nleaves(nstems==ii)),10));
        s = strcat([strstem ' |' strleaves]);
        disp(s)
    end % NSTEMS
end % IF

% Plot positive stems
if ~isempty(pstems)
    for ii = 0:max(pstems(:))
        strstem = sprintf(form,ii);
        strleaves = sprintf('%2i',mod(sort(pleaves(pstems==ii)),10));
        s = strcat([strstem ' |' strleaves]);
        disp(s)
    end % PSTEMS
end % IF

% Print out key and units
form = strcat(['%.' num2str(max(0,-p)) 'f']); 
s = strcat(['key: 36|5 = ' sprintf(form,36*10^(p+1)+5*10^p)]);
disp(s)
s = strcat(['stem unit: ' sprintf(form,10^(p+1))]);
disp(s)
s = strcat(['leaf unit: ' sprintf(form,10^p)]);
disp(s)

end % MAIN
