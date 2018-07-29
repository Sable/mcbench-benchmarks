function [ won bet happy tt ] = auction( w, iter, e, verbose )
% Subroutine AUCTION is a implemetation of the auction Algorithm 
% presented in Turing's Invisible Hand. Although well discribed the 
% pseudo-algorithm presented there contained an error which was corrected 
% by line 62-65 replacing 
%           if ((w(ii,j) - p(j)) >= 0)
%
% [ won bet happiness ] = auction( w, iter, e, verbose )
% Inputs:
%   w (g x b) 
%     the rows is the bidders
%     the cols is the goods
%     the values are every bidder i's percieved value of good j 
%   iter 
%     iterations iterations to do
%   e
%     e is the epsilon - the minumum bet increase (default e = 1/(ngoods+1)
%     ) 
%
% Copyright (C) 2012 - Pieter V. Reyneke, South Africa
%
% Open Source licence, use whereever you like but at own risk, keep this
% complete copyright notice in the code and please send me updates and 
% report errors to pieter.reyneke@gmail.com. Will give recognition, if
% requested, after any valid comment leading to an update was recieved. 
%
% Author: PV Reyneke

if (nargin<1)
    w = rand(3)*10;
end

if (nargin<2)
    iter = Inf;
end

if (nargin<4)
    verbose = 1;
end

p   = zeros(1,size(w,2));     % reset all goods' current bets (top - tracks)
won = zeros(1,size(w,2));     % reset cuurent winners for each good
q   = 1:size(w,1);            % create queue for bidders (left - obs)

if (nargin<3)
    e = 1/(length(p)+1);
end

if (verbose)
    display('The percieved value of goods (top) by each bidder (left):');
    display([num2str(w, '%3.0f') ]);
end

i = find(q>0,1);              % take first non-committed bidder
ii = q(i);
tdead = 0;
tic
while (~isempty(ii) && (iter > 0))
    q(q==ii) = 0;             % out of queue
    [v, j] = max(w(ii,:) - p); % search for good w greatest value 
                              % above current bid for bidder i
    if ( ((w(ii,j) - (p(j) + e)) >= 0) && ...   
         ...                  % if our current bidder i values good j 
         ...                  % more than previous bidder plus epsilon 
         (won(j) ~= ii) )     % and the bot is not on himself already
        if (won(j)>0)
            k = find(q==0,1); % find first open bidder space
            q(k:(end-1)) = q((k+1):end); 
                              % shift left and put 
            q(end) = won(j);  % previous highest bidder back in the queue
        end
        won(j) = ii;          % assign current bidder i to good j
        p(j) = p(j) + e;      % and save the new bet
    end
    
    if (verbose)
        tsss = toc;
        display(['Bets(in epsilons)  : ' num2str(p/e, '%3.0f') ]);
        display(['Bidder             : ' num2str(won, '%3.0f') ]);
        display(['Left todo          : ' num2str(q, '%3.0f') ]);
        display(['-----------------------------------------' ]);
        tdead = toc - tsss;
    end
    i = find(q>0,1);          % take next non-committed bidder
    ii = q(i);
    iter = iter-1;
end
bet = p;
tt = toc;

% measuring each bidder's happiness (the invariant of above loop)
happy = won;
iown = find(won > 0);
for (ii = won(iown))
    iii = won(ii);
    if (~isempty(iii))
        jjj = find(iii==won,1);
        if (~isempty(jjj))
            happy(iii) = (sum(e + w(iii,jjj) - p < w(iii,:) - p) == 0);
        end
    end
end
iown = find(won > 0);
for (ii = won(iown))
    iii = won(ii);
    happy(iii) = happy(iii) | (sum(w(iii,:) - p > 0));
end

j = 1;
cost = 0;
for (i=won)
    cost = cost + w(i,j);
    j = j+1;
end


if (verbose)
    display(['Assignment Cost    : ' num2str(cost, '%5.3f') ]);
    display(['Happiness          : ' num2str(happy, '%3.0f') ]);
    display(['Calc took          : ' num2str((tt - tdead) * 1000, '%5.3f') ' ms' ]);
end