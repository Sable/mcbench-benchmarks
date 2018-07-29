function newnums=roundtowardvec(X,roundvec,type)
%function newnums=roundtowardvec(X,[roundvec],[type])
%
% This function rounds number(s) toward given values. If more than one
% number is given to round, it will return the matrix with each rounded
% value, otherwise it will return the single rounded value. It will ignore
% NaNs and return them back with NaNs.
%
% Inputs: X: the number(s) that you want rounded
%
%         roundvec:(opt) the values to round X to. If none given, it will
%           default to -inf:1:inf (and use the built in functions).
%
%         type:(opt) specifies which kind of rounding you want
%           the function to use.
%
%           Choices are: 'round' - round to nearest value
%                        'floor' - round toward -Inf
%                        'ceil'  - round toward Inf
%                        'fix'   - round toward 0
%                        'away'  - round away from 0 (ceil if positive and floor if negative)
%                     (see help files for more clarity)
%
%           If no type is given, the function will default to rounding to
%           the nearest value.
%
% Outputs: newnums: rounded values, in same shape as X input matrix

% For some reason, loops seem to be faster than vectorizing this code

if nargin==0
    help roundtowardvec; %if nothing given, tell what to give
    return
elseif isempty(X)
    newnums=[]; %if given empty, return empty without going through whole script
    return
end
if ~exist('type','var') || isempty(type)
    type='round';  %%round to nearest value if not specified
end
if ~exist('roundvec','var') || isempty(roundvec)
    if strcmpi(type,'round')
        newnums=round(X);
        %to nearest integer
    elseif strcmpi(type,'away')
        newnums=ceil(abs(X)).*sign(X);
        %nearest integer away from 0
    elseif strcmpi(type,'fix')
        newnums=fix(X);
        %nearest integer toward 0
    elseif strcmpi(type,'floor')
        newnums=floor(X);
        %nearest integer toward -inf
    elseif strcmpi(type,'ceil')
        newnums=ceil(X);
        %nearest integer toward inf
    else
        error(sprintf('Round type not recognized. Options are:\n''round'' - round to nearest value\n''floor'' - round toward -Inf\n''ceil''  - round toward Inf\n''fix''   - round toward 0\n''away''  - round away from 0')) %#ok<SPERR>
    end
else
    %%make newnums size of X
    newnums=X;
    if strcmpi(type,'round') %to nearest value
        roundvec=reshape(unique(roundvec),1,[]);
        for i=numel(X):-1:1
            if ~any(X(i)==roundvec)
                DIFFs=abs(roundvec-X(i));
                if X(i)>=0
                    [~,ind]=min(DIFFs(:,end:-1:1));
                    newnums(i)=roundvec(length(DIFFs)-ind+1);
                elseif X(i)<0
                    [~,ind]=min(DIFFs);
                    newnums(i)=roundvec(ind);
                end
            end
        end
    elseif strcmpi(type,'fix') %to nearest value toward 0
        roundvec=reshape(unique([roundvec 0]),1,[]);
        for i=numel(X):-1:1
            if ~any(X(i)==roundvec)
                if X(i)>0
                    if X(i)>min(roundvec)
                        newnums(i)=roundvec(find(X(i)>roundvec,1,'last'));
                    else
                        newnums(i)=0;
                    end
                elseif X(i)<0
                    if X(i)<max(roundvec)
                        newnums(i)=roundvec(find(X(i)<roundvec,1,'first'));
                    else
                        newnums(i)=0;
                    end
                end
            end
        end
    elseif strcmpi(type,'ceil') %nearest value toward inf
        roundvec=reshape(unique(roundvec),1,[]);
        for i=numel(X):-1:1
            if ~isnan(X(i)) && ~any(X(i)==roundvec)
                if X(i)<max(roundvec)
                    newnums(i)=roundvec(find(X(i)<roundvec,1,'first'));
                else
                    newnums(i)=inf;
                end
            end
        end
    elseif strcmpi(type,'floor') %nearest value toward -inf
        roundvec=reshape(unique(roundvec),1,[]);
        for i=numel(X):-1:1
            if ~isnan(X(i)) && ~any(X(i)==roundvec)
                if X(i)>min(roundvec)
                    newnums(i)=roundvec(find(X(i)>roundvec,1,'last'));
                else
                    newnums(i)=-inf;
                end
            end
        end
    elseif strcmpi(type,'away') %nearest value away from 0
        roundvec=reshape(unique(roundvec),1,[]);
        for i=numel(X):-1:1
            if ~any(X(i)==roundvec)
                if X(i)>0
                    if X(i)<max(roundvec)
                        newnums(i)=roundvec(find(X(i)<roundvec,1,'first'));
                    else
                        newnums(i)=inf;
                    end
                elseif X(i)<0
                    if X(i)>min(roundvec)
                        newnums(i)=roundvec(find(X(i)>roundvec,1,'last'));
                    else
                        newnums(i)=-inf;
                    end
                elseif X(i)==0
                    DIFFs=abs(roundvec-X(i));
                    [~,ind]=min(DIFFs(:,end:-1:1));
                    newnums(i)=roundvec(length(DIFFs)-ind+1);
                end
            end
        end
    else
        error(sprintf('Round type not recognized. Options are:\n''round'' - round to nearest value\n''floor'' - round toward -Inf\n''ceil''  - round toward Inf\n''fix''   - round toward 0\n''away''  - round away from 0')) %#ok<SPERR>
    end
end
end