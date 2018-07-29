function [AG,NSV,G] = islands(a)
%ISLANDS finds all islands of four-connected elements in a matrix.
% ISLANDS returns a matrix the same size as the input matrix, with all of 
% the four-connected elements assigned an arbitrary island number. A second
% return argument is an nx3 matrix.  Each row of this matrix has 
% information about a particular island:  the first column is the island    
% number which corresponds to the numbers in the first return argument, the     
% second column is the number of elements in the island, the third column   
% is the value of the elements in that island (the elements of the input
% matrix).  ISLANDS will also return a binary matrix with ones in the 
% positions of the elements of the largest four-connected island.  The 
% largest four-connected island is determined first by value; for example  
% if there are 2 islands each with 5 elements, one of which is made up of   
% 6's and the other of which is made up of 4's, the island with the 6's  
% will be returned.  In the case where there are 2 islands with the same    
% number of elements and the same value, an arbitrary choice will be 
% returned.  ISLANDS also works with character arrays, although the array
% is first converted to it's ascii numerical equivalent.
% 
% Examples:  
%           a = floor(rand(10,50)*3);
%           [allislands,numsizeval,biggestisland] = islands(a); 
%           % allislands(allislands~=nsv(1))=0 %shows the first island.
%           spy(biggestisland)
%        
%           a = floor(rand(1000)*9);
%           tic,AG = islands(a);toc
%
% Notes:
%        If it is desired to exclude a certain value from being
%        considered as part of an island, set that element to NaN.
%        For example:
%                      a = [0 2 3; 0 0 4; 5 6 4];
%                      AG = islands(a)  % Include zero island.
%                      a(a==0) = NaN;
%                      AG = islands(a)  % Exclude zero island.
%
%        Exact equality is tested in ISLANDS, so the usual floating-point
%        comparison warning applies!  It is up to the user to decide how to
%        deal with situations for which this may pose a problem.  As one
%        example, say the user is interested in a matrix which has random 
%        elements on [0,1].  Say one wishes to group elements into islands 
%        such that elements on [0,.25) can group together, elements on
%        [.25,.5) can group together, elements on [.5,.75), and elements on 
%        [.75,1] can group together.  The elements in the matrix must first 
%        be assigned to a specific value.  To illustrate this:
%
%                A = rand(5);  % Example data.
%                B = A;         % Preserve A.
%                B(B>=0.0 & B <.25) = 2;  % 2 is outside the range of B.
%                B(B>=.25 & B<.50) = 3;
%                B(B>=.50 & B<.75) = 4;
%                B(B>=.75 & B<=1.0) = 5; 
%                % Alternatively, one can use histc to make B.
%
%        Then ISLANDS can be called on matrix B.
%
%        As the number and size of islands increase, ISLANDS can slow down
%        dramatically.  To see this, replace the second example above with:
%        
%        a = floor(rand(1000)*2); % Larger islands than floor(rand(1000)*9)
%        [G,G,G] = islands(a);spy(G) % Interested in the largest island.
%        % This might be a good time to use the mex version!
%
%        Holy For-Loops, Batman!
%        Every effort was made to make the code compatible with the Matlab
%        JIT/Accelerator.  If this someone finds that there is an error
%        in this regard, please contact me and tell me where an improvement 
%        can be made.  Thanks.
% 
% Author:  Matt Fig
% Contact: popkenai@yahoo.com
% Date:  08/21/2008

if nargin~=1
    error('Error using ISLANDS:  One input argument is required.')
end

[row,col] = size(a);  % Get the size of the input matrix.

if row*col==1 || isempty(a)
    AG = [];  % All islands.
    G = [];  % The largest island.
    NSV = [];  % Number, Size, Value.
    return
end

AG = zeros(row,col);  % This matrix will hold all of the islands found.
V = zeros(1,ceil(numel(a)/2));  % Hold the value of each island.
L = V;  % Hold the number of elements in each island.
cntr = 1;  % Label the individual islands by the order they are found.
vct = zeros(1,col); %#ok Used in center of loops below.
% Notes on comments in the loops:  CRNT is the element of the matrix we are
% currently looking at.  RGHT is the element to the immediate right of 
% CRNT.  RUD is the element to the right and up from the CRNT.
% The RUD element is directly above RGHT.

for gg = 1:col-1  % Look along the first row.
    if a(1,gg)==a(1,gg+1)  % CRNT matches RGHT.
        if ~AG(1,gg)  % CRNT does not have an island number.
            AG(1,gg) = cntr;  % Assign an island number to CRNT.
            AG(1,gg+1) = cntr;  % Assign an island number to RGHT.
            V(cntr) = a(1,gg);  % Assign the value of the island.
            L(cntr) = 2;  % Add to the island count.
            cntr = cntr + 1;  % Increment the counter.
        else  % CRNT does have an island number.
            AG(1,gg+1) = AG(1,gg);  % Assign the island number to RGHT.
            L(AG(1,gg)) = L(AG(1,gg)) + 1;  % Add to the island count.
        end
    end
end

for hh = 1:row-1  % Look down the first column.
    if a(hh,1)==a(hh+1,1)  % CRNT matches 'RGHT'.
        if ~AG(hh,1)  % CRNT does not have an island number.
            AG(hh,1) = cntr;  % Assign an island number to CRNT.
            AG(hh+1,1) = cntr;  % Assign an island number to 'RGHT'.
            V(cntr) = a(hh,1);  % Assign the value of the island.
            L(cntr) = 2;  % Add to the island count.
            cntr = cntr + 1;
        else  % CRNT does have an island number.
            AG(hh+1,1) = AG(hh,1);  % Assign an island number to 'RGHT'.
            L(AG(hh,1)) = L(AG(hh,1)) + 1;  % Add to the island count.
        end
    end
end

% Now we can look at the rest of the matrix.
for ii = 2:row;  % Start on the second row.
    for jj = 1:col-1;  % Start on the first column.
        if a(ii,jj)==a(ii,jj+1)  % CRNT matches RGHT.
            if a(ii,jj)==a(ii-1,jj+1)  % CRNT matches RUD too.
                if ~AG(ii,jj) && ~AG(ii-1,jj+1)  % Both aren't yet grouped.
                    AG(ii,jj) = cntr;  % Give CRNT a new island number.
                    AG(ii-1,jj+1) = cntr;  % Give RUD the new island num.
                    AG(ii,jj+1) = cntr;  % Give RGHT the new island number.
                    V(cntr) = a(ii,jj); % Store the value of the island.
                    L(cntr) = 3;  % Number of members in the new island.
                    cntr = cntr + 1;  % Increment the counter.
                elseif ~AG(ii-1,jj+1)  % RUD not yet been grouped, CRNT is.
                    AG(ii-1,jj+1) = AG(ii,jj); % Give RUD CRNTs isl. num.
                    AG(ii,jj+1) = AG(ii,jj);  % And RGHT as well.
                    L(AG(ii,jj)) = L(AG(ii,jj)) + 2;  % Add to island size.
                elseif ~AG(ii,jj)  % CRNT not yet grouped, RUD is grouped.
                    AG(ii,jj) = AG(ii-1,jj+1); % Give CRNT RUDs isl. num.
                    AG(ii,jj+1) = AG(ii-1,jj+1);  % And RGHT as well.
                    L(AG(ii-1,jj+1)) = L(AG(ii-1,jj+1)) + 2;  % Add to cnt.
                else % Both CRNT and RUD have been grouped:  merge islands.
                    % First decide which island has the least members.
                    if L(AG(ii-1,jj+1))<L(AG(ii,jj))
                        idx = AG(ii-1,jj+1);  % Save RUDs island number.
                        IDX = AG(ii,jj); % Used below: new islands.
                    else
                        idx = AG(ii,jj);  % Save CRNTs island number.
                        IDX = AG(ii-1,jj+1); % Used below: new islands.
                    end
                    cnt = 1; % The counter.
                    if idx ~= IDX % They could already match!
                        % These next for loops are faster than using find,
                        % indexing the whole matrix.  We are searching for 
                        % the old island numbers to add to the updated isl.
                        for pp = ii+1:row % Must search first column too.
                            if AG(pp,1)==idx
                                AG(pp,1) = IDX;  % Assign island number.
                                cnt = cnt + 1;  % Increment member counter.
                            else
                                break; % Stop search if one mismatch found. 
                            end
                        end
                        for mm = ii:-1:1  % Start at current row, work up.
                            for kk = 1:col
                                if AG(mm,kk) == idx
                                    AG(mm,kk) = IDX; % Assign new isl. num.
                                    cnt = cnt + 1; % Increment count.
                                    if cnt > L(idx)
                                        break % Stop search for old islnds.
                                    end
                                end
                            end
                            if cnt > L(idx)
                                break % Stop search for old island numbers.
                            end
                        end
                    end
                    AG(ii,jj+1) = IDX;  % Give RGHT the island number.
                    L(IDX) = L(IDX) +  cnt;  % Add to count.
                    L(idx) = L(idx) - cnt + 1;  % subtract from old island.
                end
            elseif ~AG(ii,jj)  % RGHT matches CRNT, not RUD. Need new isl.
                AG(ii,jj) = cntr;  % Give CRNT a new island number.
                AG(ii,jj+1) = cntr;  % Give RGHT the new island number.
                V(cntr) = a(ii,jj);  % Store the new island number.
                L(cntr) = 2;  % The number of members in the new island.
                cntr = cntr + 1;  % Increment the counter.
            else % RGHT matches CRNT, not RUD.  No new island needed.
                AG(ii,jj+1) = AG(ii,jj);  % Give RGHT CRNTs island number.
                L(AG(ii,jj)) = L(AG(ii,jj)) + 1; % Add to island count.
            end
        elseif a(ii,jj+1)==a(ii-1,jj+1) % RUD & RGHT match, not CRNT.
            if ~AG(ii-1,jj+1) % RUD has not yet been grouped.
                AG(ii,jj+1) = cntr;  % Give RGHT new island number.
                AG(ii-1,jj+1) = cntr; % Give RUD new island number.
                V(cntr) = a(ii,jj+1); % Store the value of the island.
                L(cntr) = 2; % Add to island count.
                cntr = cntr + 1;
            else % RUD is already part of a island.
                AG(ii,jj+1) = AG(ii-1,jj+1); % Add RGHT to RUD's island.
                L(AG(ii-1,jj+1)) = L(AG(ii-1,jj+1)) + 1; % Add island cnt.
            end
        end
    end
end

clear a % Free up memory for the rest of the proccessing.

if nargout>1 % User wants at least the 2nd output arg.
    NSV = [(1:cntr-1)',L(1:cntr-1)',V(1:cntr-1)']; % 2nd output.
    NSV(NSV(:,2)==0,:)=[]; % Clear empty islands.
    if nargout==3 % User wants the 3rd output too.
        % User wants matrix of all the islands and also the
        % matrix that has the island numbers, member counts and values.
        idx = L==max(L); % Find the largest number of island members.
        [idx2,idx2] = max(V(idx)); %#ok     And corresponding values.
        grp = find(idx,idx2); % Make selection.
        G = AG;  % G will have only the largest island.
        G(G~=grp(end)) = 0;  % Final matrix, use end to arbitrarily pick if
        G(G==grp(end)) = 1;  % more than one island is found with same val.
    end
end
