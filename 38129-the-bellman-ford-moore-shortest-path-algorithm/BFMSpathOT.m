% ==================================================================== 
  function [p,D,iter] = BFMSpathOT(G,r)
% --------------------------------------------------------------------
% Basic form of the Bellman-Ford-Moore Shortest Path algorithm
% Assumes G(N,A) is in sparse adjacency matrix form, with |N| = n, 
% |A| = m = nnz(G). It constructs a shortest path tree with root r which 
% is represented by an vector of parent 'pointers' p, along with a vector
% of shortest path lengths D.
% Complexity: O(mn)
% Derek O'Connor, 19 Jan, 11 Sep 2012.  derekroconnor@eircom.net
% -------------------------------------------------------------------- 
% Unlike the original BFM algorithm, this does an optimality test on the
% SP Tree p which may greatly reduce the number of iters to convergence.
% USE: 
% n=10^6; G=sprand(n,n,5/n); r=1; format long g;
% tic; [p,D,iter] = BFMSpathOT(G,r);toc, disp([(1:10)' p(1:10) D(1:10)]);
% WARNING: 
% This algorithm performs well on random graphs but may perform 
% badly on real problems.
% --------------------------------------------------------------------


[m,n,p,D,tail,head,W] = Initialize(G);
p(r)=0; D(r)=0;                  % Set the root of the SP tree (p,D)
for iter = 1:n-1                   % Converges in <= n-1 iters if no 
    optimal = true;                % negative cycles exist in G
    for arc = 1:m                  % O(m) optimality test. 
        u = tail(arc); 
        v = head(arc);
        duv = W(arc);
        if D(v) > D(u) + duv;      %
           D(v) = D(u) + duv;      % Sp Tree not optimal: Update (p,D) 
           p(v) = u;               %
           optimal = false;
        end
    end % for arc
    if optimal
        return                     % SP Tree p is optimal;
    end
end % for iter

%---------------END BFMSpathOT--------------------------------------
