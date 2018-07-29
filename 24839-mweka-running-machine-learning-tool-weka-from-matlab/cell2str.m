function str = cell2str(cstr,delimiter)
%CELL2STR  One-line description here, please.
% More desciption ....                        
%                                             
% USAGE:
%         [output1] = CELL2STR(input1)
%         [output1] = CELL2STR(input1,input2)
% [output1,output2] = CELL2STR(:)
%                                             
% INPUT:
%    input1 - Description                                   
%    input2 - ...                                    
%       
% OUTPUT:
%    output1 - Description                                     
%    output2 - ...                                    
%        
% EXAMPLES:
%    Line1 of examples
%    ...
%      
% See also: 

% Author: Durga Lal Shrestha
% UNESCO-IHE Institute for Water Education, Delft, The Netherlands
% eMail: durgals@hotmail.com
% Website: http://www.hi.ihe.nl/durgalal/index.htm
% Copyright 2004-2007 Durga Lal Shrestha.
% $First created: 06-Dec-2007
% $Revision: 1.0.0 $ $Date: 06-Dec-2007 00:31:47 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(1,2,nargin))
% PLEASE START WRITING CODES FROM HERE...
n=length(cstr);
str=[];
for i=1:n
    if isnumeric(cstr{i})
        numstr=num2str(cstr{i});
    else
        numstr=cstr{i};
    end
    if i==1
        str = numstr;
    else
        str =[str delimiter numstr];
    end
end
    
