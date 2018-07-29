function [outStr outNum] = gunits(before,after)
%Function to convert units using Google
%SCd 09/01/2010    
%
%gunits searches using the Google convention e.g: '3ft to in'
%
%Input Arguments:
%   -before: string with number and unit such as:
%         '3ft', '17c','17lbf/in^2', '3 ft*lbf'
%   -after: unit you wish to convert such as: (respectively)
%       'mm', 'f', 'N/ft^2','Newton*m'
%
%   NOTE1: Google can be picky with the input.  It's recommended
%       to spell everything out and fill in multiplication/division/powers
%       if you're having issues.  Example:
%
%       >>gunits('3psi','psf')
%           ans = '<i>3 psi</i>' %if outNum was called; an error would've been produced
%
%       >>gunits('3lbf/in^2','lbf/ft^2')
%           ans = 3 (lbf / (in^2)) = 432 lbf / (ft^2)
%   
%   NOTE2: The units should be distinguishable with spaces removed e.g:
%      'lbf ft' becomes 'lbfft' which is not a unit.  To fix use 'lbf*ft'   
%
%Output Arguments:
%   -outStr: string with the conversion
%   -outNum: numeric value of answer (only if asked for)
%
%NOTE/DISCLAIMER:
%   The algorithm used for retrieving the string is based solely on Google's
%   web format.  As (unfortunately!), I do not own or control Google, their
%   format is subject to change, which could nullify the results of this program.  
%   Please let me know if this happens.
%

%Error checking:
assert(nargin==2,'gunits() expects two and only two input arguments!');    
assert(ischar(before),'gunits expected its first input argument to be a string!');
assert(ischar(after),'gunits expected its second input argument to be a string!');

%Create search string, remove spaces, read it
search_string = ['http://www.google.com/search?hl=en&source=hp&q=' before '+to+' after]; 
S = urlread(search_string(~isspace(search_string)));

%The first HTML bold ('<b>') in the returned string will be the initiallization of the
%answer.  Find it and corresponding close bold ('</b>').
strinit = strfind(lower(S),'<b>');
strend = strfind(lower(S),'</b>');
if isempty(strinit) || isempty(strend)
    error('Input units were not accepted: please try again!');
end
strinit = strinit(1);
strend = strend(strend>strinit);
strend = strend(1);

%Output the answer (remove the <b>, < found earlier)
outStr = S(strinit+3:strend-1);

%If the numeric value is wanted:
if nargout == 2
    %Split into parts; find equal sign; keep value after equal sign, remove
    %spaces that Google uses to show 1000's
    parts = regexp(outStr,' ','split');
    eqsign = cellfun(@(x)strcmp(x,'='),parts);
    assert(any(eqsign),'The conversion did not work: please try again');
    outNum = parts{find(eqsign)+1};
    outNum = str2double(outNum(~isspace(outNum)));
end

