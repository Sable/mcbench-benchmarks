function [dimensionsout, datatypesout]=byte2any(dimensions, datatypes)

% BYTE2ANY - Mask Initialization function for UDP Byte Un-Pack Block
% Derived from The MathWorks, Inc. MXPCREADME
% $Revision: 1 $ $Date: 2008/03/07 $

if ~isa(dimensions,'cell')
  error('dimensions argument must be a cell array');
end

if ~isa(datatypes,'cell')
  error('datatypes argument must be a cell array');
end

if length(dimensions)~=length(datatypes)
  error('dimension cell array and datatypes cell array must have the same length');
end

dimensionsout=[];
datatypesout=[];
for i=1:length(dimensions)
  dimension=dimensions{i};
  if ~isa(dimension,'double')
    error('dimensions elements must be double arrays');
  end
  if size(dimension,1)>1 | size(dimension,2)>2
    error('dimensions elements must be either scalar or a row vector with two elements');
  end
  if length(dimension)==1
    dimensionsout=[dimensionsout,dimension,0];
  else
    dimensionsout=[dimensionsout,dimension];
  end
  datatype=datatypes{i};
  if ~isa(datatype,'char')
    error('datatypes elements must be char arrays');
  end
  if strcmp(datatype,'double')
     dtypeout=0;
  elseif strcmp(datatype,'single')
    dtypeout=1;
  elseif strcmp(datatype,'int8')
    dtypeout=2;
  elseif strcmp(datatype,'uint8')
    dtypeout=3;
  elseif strcmp(datatype,'int16')
    dtypeout=4;
  elseif strcmp(datatype,'uint16')
    dtypeout=5;
  elseif strcmp(datatype,'int32')
    dtypeout=6;
  elseif strcmp(datatype,'uint32')
    dtypeout=7;
  elseif strcmp(datatype,'boolean')
    dtypeout=8;
  else
    error('the supported data types are: double, single, int, uint8, int16, uint16, int32, uint32, boolean');
  end
  datatypesout=[datatypesout,dtypeout];
end

  
  

         
   



