function seats=apport(votes,num,method,minseats)
%APPORT Political Apportionment
%   SEATS = APPORT(VOTES,NUM,METHOD) takes the array of VOTES for each
%   member and allocates seats according to METHOD until NUM seats have
%   been allocated.
%
%   APPORT(...,MINSEATS) pre-allocates MINSEATS to each member first,
%   guaranteeing that each member has at least MINSEATS number of SEATS.
%   MINSEATS can either be a vector, with length equal to the number of
%   members, or a scalar which is the same for all members. (Default is 0)
%
%   If either NUM or METHOD is multivalued it will enumerate all
%   combinations within those parameters. An error will be given if both
%   are multivalued.
%
%   Below is a list of available methods. METHOD can either be written out
%   in full ('Greatest Divisor') or in abbreviated form ('GD'). Also listed
%   are common names for the same method.
%
%   Methods available:
%   ------------------
%   Greatest Divisor   : d'Hondt; Jefferson; Highest Average
%   Smallest Divisor   : Adams
%   Equal Proportions  : Huntington; Hill; Geometric Mean
%   Harmonic Mean      : Dean
%   Major Fractions    : Sainte-Lague; Webster; Arithmetic Mean; Odd Numbers
%   Largest Remainders : Vinton; Hamilton; Hare
%
%   Abbreviated form:
%   -----------------
%   ALL : All six unique methods
%   A   : Adams
%   AM  : Arithmetic Mean
%   D   : Dean
%   DH  : d'Hont
%   EP  : Equal Proportions
%   GD  : Greatest Divisor
%   GM  : Geometric Mean
%   HH  : Huntington OR Hill (equivalent)
%   HA  : Highest Average
%   HAM : Hamilton OR Hare (equivalent)
%   HM  : Harmonic Mean
%   J   : Jefferson
%   LR  : Largest Remainders
%   MF  : Major Fractions
%   ON  : Odd Numbers
%   SD  : Smallest Divisor
%   SL  : Sainte-Lague
%   V   : Vinton
%   W   : Webster
%
%
%   EXAMPLE 1
%   Allocate 80 seats among four parties with votes of [100 80 30 20], with
%   minimum of 3 seats each. Compare all methods.
%      apport([100 80 30 20],80,'All',3)
%
%   EXAMPLE 2
%   Compare method of Greatest Divisor with the method of Smallest Divisor
%   of allocating 15 seats among four parties with votes of [104 62; 34 55]
%       apport([104 62; 34 55],15,{'GD','SD'})
%
%   EXAMPLE 3
%   'Alabama Paradox'
%   "increasing the total number of items would decrease one of the shares"
%      apport([2 6 6],10:13,'Hamilton')
%   Notice first party decreased representation from 2 to 1, even with
%   an increase in total number of shares
%
%   EXAMPLE 4
%   'New states paradox'
%   "it is possible for an existing state to get more representatives than
%   if the new state were not added"
%      apport([27 39 68  ],23,'Largest Remainders')
%      apport([27 39 68 6],23,'Largest Remainders')
%   Notice first state increased representation from 4 to 5, at the
%   expense of one of the other two original states
%

%   Mike Sheppard
%   Last Modified: 1-Feb-2012


%%ERROR CHECKING
if nargin<3
    error('APPORT:TooFewInputs','Too few inputs');
end
if nargin==3
    minseats=0;
end
sz=size(votes); votes=votes(:); minseats=minseats(:);
if isscalar(minseats)
    minseats=minseats.*ones(size(votes)); %make into vector
end
if numel(minseats)~=numel(votes)
    error('APPORT:Number','MINSEATS must be either a scalar or vector of length equal to VOTES');
end
if any(minseats<0)||any(rem(minseats,1))||(any(~isfinite(minseats)))
    error('APPORT:Number','MINSEATS must be a non-negative integers');
end
if (num<0)|(rem(num,1))|(any(~isfinite(num)))
    error('APPORT:Number','NUM must be a positive integer');
end
if (~isnumeric(votes))||(any(~isfinite(votes)))||(any(isnan(votes)))||(~isvector(votes))
    error('APPORT:Votes','VOTES must be a finite numeric value, either scalar or vector');
end
if sum(minseats)>num
    error('APPORT:Number','ERROR: Total minimum allocated seats exceed total seats allowed');
end
method=lower(method);
if ~any(ismember(method,{'all','greatest divisor','dhondt','jefferson',...
        'highest average','smallest divisor','adams','equal proportions',...
        'huntington','hill','geometric mean','harmonic mean','dean',...
        'major fractions','sainte-lague','webster','arithmetic mean',...
        'odd numbers','largest remainders','vinton','hamilton','hare',...
        'a','am','d','dh','ep','gd','gm','hh','ha','ham','hm','j','lr',...
        'mf','on','sd','sl','v','w'}))
    error('APPORT:Method','Method must one of the items in the list under ''help apport''');
end
if iscell(method)&&any(strcmp(method,'all'))
    error('APPORT:Method','METHOD of ALL must be given as a string with no other methods listed');
end
if ischar(method)&&strcmp(method,'all')
    methodv=lower({'Greatest Divisor','Smallest Divisor',...
        'Equal Proportions','Harmonic Mean','Major Fractions',...
        'Largest Remainders'});
elseif ~iscell(method)
    methodv={method}; %Singular method
else
    methodv=method; %Already a cell
end
if all([numel(methodv) numel(num)]>1)
    error('APPORT:Method','NUM and METHOD cannot both be multivalued');
end



nummethods=numel(methodv);
numnum=numel(num);
methodsingular=(nummethods==1);
maxcount=max([nummethods numnum]);


%Save original values
isvec=isvector(ones(sz));

for k=1:maxcount
    if methodsingular
        %methods is singular, loop through num
        seats=apport_helper(votes,num(k),methodv{1},minseats);
    else
        %num is singular, loop through method
        seats=apport_helper(votes,num(1),methodv{k},minseats);
    end
    seats=reshape(seats,sz);
    
    if maxcount==1
        output=seats; %singular input
    else
        %Multiple inputs
        if ~isvec
            %Multi-dimensional array
            temp(1:ndims(seats))={':'};
            output(temp{:},k)=seats;
        else
            %Vector
            if sz(1)==1
                output(k,:)=seats;
            else
                output(:,k)=seats;
            end
        end
    end
    
    
end




%Rename for output
seats=output;

end


function seats=apport_helper(votes,num,method,minseats)
%Subtract minseats from original number
num=num-sum(minseats);

if ismember(method,{'largest remainders','vinton','hamilton','hare','lr','v','ham'})
    %Method of Largest Remainders is handled as specific case
    st_quota=votes./(sum(votes)./num);                                %Standard Quota
    [frac_lost,indx]=sort(rem(st_quota-floor(st_quota),1),'descend'); %Sort by remainders
    seats=floor(st_quota);                                            %Allocate the integer values
    num_missing=num-sum(seats);                                       %Determine number of seats left to allocate
    seats(indx(1:num_missing))=seats(indx(1:num_missing))+1;          %Increase by one seat those with largest remainders
    seats=seats(:);                                                   %Consistent output, column vector
else            %One of the other methods
    
    %   Algorithm:
    %   Party A with vote total P(A) is entitled to its m'th seat before
    %   party B with vote total P(B) is entitled to its n'th seat
    %   if and only if P(A)/f(m-1) > P(B)/f(n-1) where f(x) is the function
    %   f(x) = x (Smallest Divisor)
    %   f(x) = harmonic mean of x and x + 1 (Harmonic Mean)
    %   f(x) = geometric mean of x and x + 1 (Equal Proportions)
    %   f(x) = arithmetic mean of x and x + 1 (Major Fractions)
    %   f(x) = x + 1 (Greatest Divisor)
    
    x=[1:num];  %Seat number
    %Note: fd=f(x-0)
    switch lower(method)
        case {'smallest divisor','adams','sd','a'}
            fd=(x);
        case {'harmonic mean','dean','hm','d'}
            fd=harmmean([(x);(x)+1]);
        case {'equal proportions','huntington','hill','geometric mean','ep','hh','gm'}
            fd=geomean([(x);(x)+1]);
        case {'major fractions','sainte-lague','webster', 'arithmetic mean',...
                'odd numbers','mf','sl','w','am','on'}
            fd=mean([(x);(x)+1]);
        case {'greatest divisor','dhondt','jefferson','highest average',...
                'gd','dh','j','ha'}
            fd=(x)+1;
        otherwise
            error('APPORT:Method','Method must one of the items in the list under ''help''');
    end
    
    
    %Allocate seats according to priority values
    pv=kron(votes(:),1./fd);               %priority value matrix
    [I,J] = ind2sub(size(pv),1:numel(pv)); %I party index of votes
    [Y,indx] = sort(pv(:),'descend');      %indx is linear index
    %Take the top 'num' of priority values and determine the
    %appropriate party index for each, and group to determine total number of
    %seats for each party
    list=I(indx(1:num));
    seats=accumarray(list',ones(size(list)));
    
    %Special case to catch:
    %zero seats at end do not show up, add if necessary
    if length(seats)<length(votes)
        seats=[seats; zeros(length(votes)-length(seats),1)];
    end
    
    
end

%Add back minimum number of seats and reshape to original shape
seats=seats+minseats;
end
