function [outputmat]=cell2num(inputcell)
% Function to convert an all numeric cell array to a double precision array
% ********************************************
% Usage: outputmatrix=cell2num(inputcellarray)
% ********************************************
% Output matrix will have the same dimensions as the input cell array
% Non-numeric cell contest will become NaN outputs in outputmat
% This function only works for 1-2 dimensional cell arrays

if ~iscell(inputcell), error('Input cell array is not.'); end

outputmat=zeros(size(inputcell));

for c=1:size(inputcell,2)
  for r=1:size(inputcell,1)
    if isnumeric(inputcell{r,c})
      outputmat(r,c)=inputcell{r,c};
    else
      outputmat(r,c)=NaN;
    end
  end  
end

end