function C = partitions(M,K)
%PARTITIONS Find all partitions of a set.
% C = PARTITIONS(N), for scalar N, returns a cell array, wherein each cell 
% has a various number of other cells representing the partitions of the  
% set of numbers {1,2,3,...N}.  The length of C is the Bell number for N.
% C = PARTITIONS(N), for vector N, returns the partitions of the vector
% elements treated as members of a set.
% C = PARTITIONS(N), for cell N, returns the partitions of the cell
% elements treated as members of a set.
% PARTITIONS(N,K) returns only the partitions of which have K members.  
%
% K must be less than or equal to N for scalar N, or length(N).
%
%
% Examples:
%
%     C = partitions(4); % Find the partitions of set {1 2 3 4}
%     home  % Makes for nice display for small enough N.  Else use clc.
%     partdisp(C) % File accompanying PARTITIONS
%
%     C = partitions({'peanut','butter','yummy'});
%     home
%     partdisp(C)
%
%     C = partitions([5 7 8 50],3); % partitions of set {5 7 8 50}
%     home
%     partdisp(C,3)
%
%     C = partitions(['a','b','c','d']); % for longer chars, use {}, not []
%     home
%     partdisp(C)
%
% Class support for inputs N,K:
%      float: double, single, char (N only)
% 
% See also, nchoosek, perms, npermutek (On the FEX)
%
% Author: Matt Fig,   
% Contact: popkenai@yahoo.com
% Date: 5/17/2009

Kflg = false;  % No K passed in.
Cflg = false;  % A set not passed in.

if length(M)>1 
    N = length(M); % User passed {'here','there','everywhere'} for example.
    Cflg = true;
else
    if iscell(M)  % User passed {2} for example.
        error('Set arguments must have more than one element.')
    end
    
    N = M;
end

if nargin>1
    Kflg = true;  % Used in while loop below, K passed in.
    S = stirling(N,K);  % The number of partitions, Stirling number.
    C = cell(S,min(1,K)); % Main Cell.
    cnt = 1;  % Start the while loop counter.
else
    K = 0;  % Since user doesn't want only certain partitions.  
    S = ceil(sum((1:2*N).^N./cumprod(1:2*N))/exp(1)); % Bell number.
    C = cell(S,1); % Main Cell.
    
    if Cflg
        C{1} = {M};
    else
        C{1} = {1:N}; % First one is easy.
    end
    
    cnt = 2; % Start the while loop counter.
end

if K~=ceil(K) || numel(K)~=1  
    error('Second argument must be an integer of length 1.  See help.')
end

if N<0 || K>N || K<0
   error('Arguments must be greater than zero, and K cannot exceed N.') 
end

if N==0
    C = {{}}; % Easy case.
    return
end

if K==1
    if Cflg
        C{1} = {M};  % Easy case.
    else
        C{1} = {1:N};  % Easy case.
    end
    return
end

if Cflg
    NV = M;
else
    NV = 1:M; % Vector: base partition, RGF indexes into this guy.
end

NU = 1; % Number of unique indices in current partition.
stp1 = N; % Controls assigning of indices.
RGF = ones(1,N); % Holds the indexes.
BLD = cell(1,N); % Smaller cell array will be used in creating larger.

while cnt<=S
    idx1 = N; % Index into RGF.
    stp2 = RGF(idx1); % Works with stp1.

    while stp1(stp2)==1
        RGF(idx1) = 1;  % Assign value to RGF.
        idx1 = idx1 - 1; % Need to increment idx1 for translation below.
        stp2 = RGF(idx1); % And set this guy for stp1 assign below.
    end

    NU = NU + idx1 - N;  % Get provisional number of unique vals.
    stp1(1) = stp1(1) + N - idx1;

    if stp2==NU % Increment the number of unique elements.
        NU = NU +1;
        stp1(NU) = 0;
    end

    RGF(idx1) = stp2 + 1;  % Increment this position.
    stp1(stp2) = stp1(stp2) - 1;  % Translate indices of these two. 
    stp1(stp2+1) = stp1(stp2+1) + 1; % Re-assign stopper.

    if NU==(~Kflg * NU + Kflg * K)
    % We could use:  C{cnt} = accumarray(RGF',NV',[],@(x) {x});   (SLOW!!)
    % or the next lines to C{cnt} = TMP;
        TMP = BLD(1:NU); % Build subcell of correct size.
        TMP{1} = NV(RGF==1); % These first two are always here.... no loop.
        TMP{2} = NV(RGF==2);

        for ii = 3:NU % Build the rest of cell array, if any.
            TMP{ii} = NV(RGF==ii);
        end

        C{cnt} = TMP;  % Assign cell at jj. 
        cnt = cnt + 1;
    end
end



function S = stirling(N,K)
% Calculate the Stirling number of the second kind. Subfunc to partitions.

for ii = K:-1:0
    S(ii+1) = (-1)^ii * prod(1:K) / (prod(1:(K-ii)) *...
              (prod(1:ii)))*(K - ii)^N;  %#ok
end

S = 1/prod(1:K) * sum(S);