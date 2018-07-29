function newstruct = filterstruct(oldstruct,filterlogic)
% filterstruct - Filter fields of a structure array using a logical array
% newstruct = filterstruct(oldstruct,filterlogic)
%
% Filterstruct allows one to use a logical matrix to filter the various
% fields of a structure identically. If filterlogic has one column and the
% fields contain more than one column the rows of each field will be
% filtered. If filterlogic has multiple columns, the fields that are
% filtered must be identical in size to filterlogic.
%
% Will only filter those fields with the same number of rows as filterlogic
% (if only one column) or that are the same size as filterlogic (if
% multiple columns).
%
% Example:
% s.t1 = [1; 2; 3;];
% s.t2 = [4; 5; 6;];
% s.t3 = [7; 8];
% filterlogic = logical([1; 0; 1]);
%
% r = filterstruct(s,filterlogic);
%
% Created by Robert M. Flight, January 27, 2009. rflight79@gmail.com

% create the new structure
newstruct = struct;

% get the fieldnames
names = fieldnames(oldstruct);

% decide how to do the filtering
[nrow,ncol] = size(filterlogic);
if ncol == 1
    filtboth = false;
else
    filtboth = true;
end %if

% how many fields
nname = length(names);

% do filtering for each field
for iname = 1:nname
    crud = getfield(oldstruct, names{iname});
    [m,n] = size(crud);

    if filtboth
        if (m == nrow) && (n == ncol)
            crud = crud(filterlogic);
        end %if
    else
        if m == nrow
            crud = crud(filterlogic,:);
        end %if
    end %if
    
    % set the field in the new structure
    newstruct = setfield(newstruct, names{iname}, crud);
end %for