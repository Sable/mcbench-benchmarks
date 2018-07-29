function b=meastatus(a);
% MEASTATUS
%               b=meastatus(a)
%
% When a CP measurement file has been loaded with cp42mea.m or cp42cut.m,
% then the measurement data is contained in a structured variable.
% MEASTATUS extracts the changes of the status contained in the measurement
% data. The content of the output variable b (structured variable like a,
% but a few fields are missing) contains a matrix in the field 'status'.
% This matrix has 4 rows: the 1st 2 rows contain the time and meas.-value,
% where the status has a change, row 3 contains the running index and the
% 4th row the new status.
%
% Example:
%   [z1,z2]=cp42mea;
%   S=meastatus(z2);
%   format bank; disp(S.status); format short

b=[];
if ~isfield(a,'Subchannel'),
    disp('may be, you try to work with a catman binary file ?!');
    disp('That is not possible with meastatus.m !');
    return;
end

b=rmfield(a,'data');    
b=rmfield(a,'status');
b=rmfield(a,'timeax');
nsg=length(a);                              % No. of signals containd in the structured variable
statusmarke=0;
for p=1:nsg,
        if isfield(a(p),'status'),
            stati=a(p).status;              % stati contains now signal status
            tx=a(p).timeax;                 % tx is the time axis (available for every channel)
            idxcnt=1:1:length(tx);          % Building up index axis
            dst=[1,diff(stati)];            % Where are changes of the status info ?
            kistatus=find(dst~=0);          %  => use find...
            if ~isempty(kistatus),          % There will always something to be found [, but who knows ?!]
                xmark=tx(kistatus);         % extract time of change
                ymark=a(p).data;            % extract meas.-value, where change occurs
                ymark=ymark(kistatus);
                idxmark=idxcnt(kistatus);   % extract index, where status changes
                statmark=stati(kistatus);
                statusmarke=1;
                W=[xmark(:).';ymark(:).';idxmark(:).';statmark(:).']; % Build together the status info matrix
                b(p).status=W;
            end
        end
end
    