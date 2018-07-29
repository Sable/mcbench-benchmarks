function Out=ExcelCol(In)
%EXCELCOL  Converts between column name and number for Excel representation
%   Out=ExcelCol(In) takes the input In, which may be a number, vector,
%   char, or cell and converts it to the other representation
%
%   If IN is numeric, output will be a column cell of the column name
%   If IN is char or cell, output will be a number or column vector, 
%      ignoring any numberic part which may be included in input
%
%   EXAMPLES:
%   ExcelCol(100)                        %Number to column name
%   ExcelCol('CV')                       %Column name to number
%   ExcelCol([1 10 100 1000 16383])      %Multiple conversions
%   ExcelCol({'A' 'J' 'CV' 'ALL' 'XFC'}) %Multiple conversions
%
%

%
% $ Author: Mike Sheppard
% $ Original Date: 4/7/2010
% $ Version: 1.0


%Optional to change representation and base
ABC=['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
base=26; 

if isnumeric(In)
%Converts from column number to alpha
%1=A, 2=B,... 26=Z, 27=AA, ... 16383=XFC
In=In(:);
if ~all(In>0)
error('MATLAB:ExcelCol:NegativeColumnNumber', 'Column numbers must be positive');    
end
  for row=1:size(In,1)
   diff=1;
   i=0;
   n=In(row,:);
   while diff<=n
       letter_ind=1+mod(floor((n-diff)/base^i),base);
       i=i+1;
       temp(i)=ABC(letter_ind);
       diff=diff+base^i;
   end
   Out{row}=fliplr(temp);
   clear temp
  end  
  Out=Out(:);
else
%Converts from alpha to column number
%A=1, B=2, ..., Z=26, AA=27, ... XFC=16383   
   In=cellstr(upper(In));
   In=In(:);
   for row=1:size(In,1)
       alpha=char(In(row,:));
       %Delete any numbers which may appear
       alpha=(char(regexp(alpha,'\D','match')))';
       lng=length(alpha);
       temp=((base^(lng) - 1) / (base-1));
       for i=1:lng
           ind=strfind(ABC, alpha(i));
           if isempty(ind)  %ERROR
                 error('MATLAB:ExcelCol:Mixofcharacters', 'Must be only alpha-numeric values {A-Z}, {a-z}, {0-9}');
           end
           temp=temp+(ind-1)*(base^(lng-i));
       end
       Out(row)=temp;
   end
   Out=Out(:);
end


end
