function [output] = patch2struct(varargin)

% 'PATCH2STRUCT' CONVERTS A PATCH OBJECT TO ITS CORRESPONDING STRUCTURE.
%
% OUTPUT = patch2struct(VARARGIN)
%
% VARARGIN input may be:
% 1. A handle to an existing Patch object.
% 2. A handle to an existing Patch object, as well as a comma-separated
%    list of property/value pairs that modify the Patch object. The
%    resulting structure will include these modifications.
% 3. A comma-separated list of Patch property/value pairs. Properties
%    that are undefined will be set to default values. If an existing Patch
%    object has not been provided, a figure may briefly appear on-screen to
%    allow default properties to be stored (this effect will be
%    unnoticeable on faster machines).
%
% Note: Property names are NOT case sensitive. They will be automatically
%       formatted with the appropriate case.
%
% OUTPUT will be a structure whose field names match Patch object
% properties and whose values correspond to Patch object settings,
% including any modifications specified by the user.
%
% EXAMPLES:
% 1. If 'phandle' is a handle to an existing Patch object, encode its
%    existing properties and values into a structure.
%
%    mystruct = patch2struct(phandle);
%
% 2. Make the following modifications to the Patch object referenced by
%    'phandle' and store those settings in the resulting structure.
%
%    mystruct = ...
%    patch2struct(phandle,'cdatamapping','direct','edgealpha',0.75);
%
% 3. Define a patch using face and vertex data and store those settings in
%    a structure. A patch object does not currently exist, but its settings
%    will be stored for later use.
%
%    mystruct = ...
%    patch2struct('faces',myfaces,'vertices',myvertices,'edgecolor', ...
%                 'none','facecolor','g');
%
%                                                  Written by Adrian Abordo
%                                                  adrian.abordo@iggmoe.com
%                                                        Revised 2008-05-09
%                                                                    v1.0.1

% Determine if handle to patch object was provided as an input
patchObj = [];
if ishandle(varargin{1}) == 1,   
    if strcmp(get(varargin{1},'type'),'patch') == 1,
        patchObj = varargin{1};
    else
        error(['If a handle is provided as an input, it must reference '...
            'a Patch object.']);
    end
    % Remove the patch object handle from varargin, leaving only the
    % remainder
    varargin = varargin(2:end);
end

% Check VARARGIN
if mod(length(varargin),2) ~= 0,
    error('Patch settings must be specified as property/value pairs.');
end

% Assign user-specified property/value pairs to cells (if present)
specProps = varargin(1:2:end);
specVals = varargin(2:2:end);

if isempty(patchObj) == 1,
    % If a patch object handle has NOT been provided as an input,
    % temporarily create a patch object and extract its properties and
    % default values, then delete the object
    newfig = 0;
    newaxes = 0;
    if isempty(get(0,'currentfigure')) == 1,
        newfig = 1;
    end
    if isempty(get(get(0,'currentfigure'),'currentaxes')) == 1,
        newaxes = 1;
    end
    patchObj = patch(varargin{:});
    template = get(patchObj);
    if newfig == 0 && newaxes == 0,
        delete(patchObj);
    elseif newfig == 0 && newaxes == 1,
        delete(get(patchObj,'parent'));
    elseif newfig == 1,
        delete(get(get(patchObj,'parent'),'parent'));
    end
else
    % If a patch object has been provided, extract its properties
    template = get(patchObj);
end

% Determine if user has specified additional property/value pairs that
% modify the properties of the original patch object
templateProps = fieldnames(template);
templateVals = struct2cell(template);
[temp,templateI,specI] = intersect(lower(templateProps),lower(specProps));
templateVals(templateI) = specVals(specI);

% Create output structure
output = cell2struct(templateVals,templateProps,1);