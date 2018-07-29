function [ M ] = BK_MaxIS( int_matrix )
%BKMAXIMAL Find maximal stable set using Bron-Kerbosch algorithm
%   Given a graph's interference matrix int_matrix, calculates the 
%   maximal independent sets using the Bron-Kerbosch algorithm in a recursive
%   manner.
%   Every column of the returned matrix M corresponds to an independent 
%   set. If row i of column j is 1, then vertex i participates in the
%   maximal independent set indexed by column j.
%
%   Berk Birand (c) 2012
%   http://www.berkbirand.com

no_vertices = size(int_matrix,2);

% output for the maximal independent sets
M = [];

P = [];
S = [];
T = 1:no_vertices;

findIS( P, S, T);

    % Recursive function to branch on 
    function findIS(P, S, T)
        
        % Check if we are done
        if check_end(S,T)
            
            % Loop through the edges
            for i=1:size(T,2)
                % pick x as candidate
                x = T(i);
                P = [P x];
                S_new = remove_nbrs(S, x,0 );
                T_new = remove_nbrs(T, x, 1);
                
                % if S(j) and T(j) are empty, we got max'l  IS
                if (isempty(S_new) && isempty(T_new))
                    new_IS = convert_set_to_bin(P, no_vertices);
                    M = [M new_IS'];
                    
                    % go to step 5
                elseif ( ~isempty(S_new) && isempty(T_new))
                    % go to step 5
                    
                else
                    % recursive call
                    findIS(P, S_new, T_new);
                end

                
                % remove x from P
                x_ind = find(P == x);
                P(x_ind) = [];

                % add x to S
                S = [S x];
                

            end  % for i=1:size(T,2)
        end % if check_end(S,T)
                
    end % findIS


    % Removes the neighbors of x from inp, and returns it
    % Sinp: is the set where the neighorhood will be removed
    % x :index of node whose neighborhood will be removed
    % removeX : if 1, x is also removed, from Sinp
    function [ Sout ] = remove_nbrs( Sinp, x, removeX)
        
        if nargin ~= 3
            error('Need all three arguments');
        end

        int_line = int_matrix(x, :); % proper line in the interference matrix
        nbrs = find(int_line == 1);  % locate where int_line = 1
        
        % if we also need to remove the node itself
        if (removeX == 1)
            nbrs = [nbrs x];
        end
        
        mems = ismember(Sinp, nbrs);  % find locations where there is a match
        no_ind = find(mems ~= 1);     % find indices of locations where there is not match
        Sout = Sinp(no_ind);              % return those indices
    end % remove_nbrs


    % Converts an array of decimals to 0-1 array
    % [2 4] => [ 0 1 0 1 ]
    % The size of the output array is exactly len
    function [Sout] =  convert_set_to_bin(Sin, len)
        
        Sout = zeros(1,len);
        Sout(Sin) = 1;
        
    end %convert_set_to_bin

    % check whether we can end the execution
    function ret = check_end(S, T)
        ret = 1;
        for k=1:size(S,2)
            
            %TODO Fix this for not using g to get the neighborhood
            E_k = g_neighbors(int_matrix,S(k)); %neighborhood of k
            
            if ( isempty(intersect(E_k, T))  )
                ret = 0;
                break; %there exists such a node, so no need to continue
                
            end % if ( isempty(intersect(E_k, T))  )
            
        end % for k=1:size(S,2)

    end %ret


    % returns the neighbors of n in the matrix given by M
    function nbrs = g_neighbors(M,n)
        m_row = M(n,:);
        nbrs = find(m_row == 1);
    end

end %BKmaximal

