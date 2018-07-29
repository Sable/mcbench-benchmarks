function [patchObj] = struct2patch(inStruct,varargin)

% 'STRUCT2PATCH' CREATES A PATCH OBJECT FROM A STRUCTURE.
%
% PATCHOBJ = struct2patch(INSTRUCT,VARARGIN)
%
% INSTRUCT must be a structure whose fields specify Patch object properties
% and values. It may be obtained by the 'get(h)' command if 'h' is a
% handle to an existing patch object, or it may be derived from the
% 'PATCH2STRUCT' function.
%
% If provided, VARARGIN optional input may contain a comma-separated list
% of Patch property/value pairs that will be applied to the resulting Patch
% object. (Property names are NOT case sensitive. They will be automatically
% formatted with the appropriate case.)
%
% NOTE: When the new patch object is created, the 'Parent' field in the
%       source structure is ignored, because it is assumed that the parent
%       of the original patch object no longer exists and the referenced
%       handle is obsolete. To specify a parent for the new patch object,
%       enter the desired property/value pair as part of VARARGIN.
%
% PATCHOBJ output will be a handle to the newly-created Patch object.
%
% EXAMPLES:
% 1. Create a Patch object whose settings are stored in structure
%    'mystruct' and return the handle as 'p'.
%
%    p = struct2patch(mystruct);
%
% 2. Create a Patch object with the following modifications.
%
%    p = ...
%    struct2patch(mystruct,'parent',h,'ambientstrength',0.47);
%
%                                                  Written by Adrian Abordo
%                                                  adrian.abordo@iggmoe.com
%                                                        Revised 2008-05-09
%                                                                    v1.0.1

% These properties will be ignored if they are empty or no longer reference
% valid objects
condBlackList = {'facevertexalphadata' 'parent'};

% Extract property/value pairs from input structure
structProps = fieldnames(inStruct);
structVals = struct2cell(inStruct);

% Extract property/value pairs from VARARGIN (if provided)
specProps = varargin(1:2:end);
specVals = varargin(2:2:end);

% Determine if the user has specified in VARARGIN any properties listed on
% the conditional blacklist and determine the definitive blacklist
[temp,I,temp] = intersect(condBlackList,lower(specProps));
if length(I) == 1 && I == 1,
    blackList = {'Annotation' 'BeingDeleted' 'Parent' 'Type'};
elseif length(I) == 1 && I == 2,
    if isempty(inStruct.FaceVertexAlphaData) == 1,
        blackList = {'Annotation' 'BeingDeleted' 'FaceVertexAlphaData'...
            'Type'};
    else
        blackList = {'Annotation' 'BeingDeleted' 'Type'};
    end    
elseif length(I) == 2,
    blackList = {'Annotation' 'BeingDeleted' 'Type'};
else
    if isempty(inStruct.FaceVertexAlphaData) == 1,
        blackList = {'Annotation' 'BeingDeleted' 'FaceVertexAlphaData'...
            'Parent' 'Type'};
    else
        blackList = {'Annotation' 'BeingDeleted' 'Parent' 'Type'};
    end
end

% Assign user-specified properties
[temp,structI,specI] = intersect(lower(structProps),lower(specProps));
structVals(structI) = specVals(specI);

% Keep only non-blacklisted properties and values
[temp,keepI] = setdiff(structProps,blackList);
structProps = structProps(keepI);
structVals = structVals(keepI);

% Ensure that instantiated Patch object is invisible until the patch is
% fully defined with correct settings
I = strmatch('Visible',structProps,'exact');
origVisible = structVals{I};    % store original setting
structVals{I} = 'off';

% Prepare settings list
objSettings = cell(1,length(keepI)*2);  % pre-allocation
objSettings(1:2:end) = structProps;
objSettings(2:2:end) = structVals;

% Instantiate patch object
patchObj = patch(objSettings{:});

% Correct for 'Vertices' and 'Faces' matrices growing 6-times larger by
% re-applying the original settings to the instantiated Patch object
I = strmatch('Vertices',structProps,'exact');
set(patchObj,'Vertices',structVals{I});
I = strmatch('Faces',structProps,'exact');
set(patchObj,'Faces',structVals{I});

% Restore original visibility setting
set(patchObj,'Visible',origVisible);