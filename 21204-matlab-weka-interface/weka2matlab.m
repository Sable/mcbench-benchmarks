function [mdata,featureNames,targetNDX,stringVals,relationName] =...
                                                weka2matlab(wekaOBJ,mode)
% Convert weka data, stored in a java weka Instances object to a matlab
% data type, (type depending on the optional mode, [] | {} )
% 
% wekaOBJ       - a java weka Instances object storing the data.
%
% mode          - optional, [] | {} (default = []) If [], returned mdata is 
%                 a numeric array and any strings in wekaOBJ are converted 
%                 to their enumerated indices. If {}, mdata is returned as 
%                 a cell array, preserving any present strings. 
%
% mdata         - an n-by-d matlab numeric or cell array, holding the data, 
%                 (n, d-featured examples). Type depends on the mode
%                 parameter. 
%
% featureNames - a cell array listing the names of each feature/attribute
%                in the same order as they appear, column-wise, in mdata.
%
% targetNDX    - the column index of the target, (output) feature/class
%                (w.r.t 1-based indexing)
%
% stringVals   - some weka features may be non-numeric. These are
%                automatically enumerated and the enumerated indices
%                returned in mdata instead of the string versions, (unless
%                in cell mode). The corresponding strings are returned in
%                stringVals, a cell array of cell arrays. Enumeration
%                begins at 0. 
%
% relationName - The string name of the relation.

if(~wekaPathCheck),mdata = []; return,end
if(nargin < 2)
    mode = [];
end

if(not(isjava(wekaOBJ)))
    fprintf('Requires a java weka object as input.');
    return;
end

mdata = zeros(wekaOBJ.numInstances,wekaOBJ.numAttributes);
for i=0:wekaOBJ.numInstances-1
    mdata(i+1,:) = (wekaOBJ.instance(i).toDoubleArray)';
end

targetNDX = wekaOBJ.classIndex + 1;

featureNames = cell(1,wekaOBJ.numAttributes);
stringVals = cell(1,wekaOBJ.numAttributes);
for i=0:wekaOBJ.numAttributes-1
    featureNames{1,i+1} = char(wekaOBJ.attribute(i).name);
    
    attribute = wekaOBJ.attribute(i);
    nvals = attribute.numValues;
    vals = cell(nvals,1);
    for j=0:nvals-1
        vals{j+1,1} = char(attribute.value(j));
    end
    stringVals{1,i+1} = vals;    
end

relationName = char(wekaOBJ.relationName);

if(iscell(mode))
   celldata = num2cell(mdata);
   for i=1:numel(stringVals)
      vals = stringVals{1,i};
      if(not(isempty(vals)))
        celldata(:,i) = vals(mdata(:,i)+1)';
      end
   end
   mdata = celldata;
    
end


end