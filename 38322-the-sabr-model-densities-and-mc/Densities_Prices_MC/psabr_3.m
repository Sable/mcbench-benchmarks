% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.

function y = psabr_3(a,b,r,n,f,k,t)
% sabr prices using an admissible region kl <= k <= +infty where sabr is used
% for 0 <= k <= kl    we use a put pricing function f(x) = K^mu exp(a x)


    mu = 1.5;
    s = @(x) psabr(a, b, r, n, f, x, t);
    index = find(s(k)>0,1,'first');

    if isempty(index)
        kl = .25 *f;
    else
        kl = max(.25 * f,k(index));% lower strike level (free parameter)
    end 
    
    ku = 2.5*f;
    
    V = psabr(a,b,r,n,f,kl,t);
    
    al = (log(V) - mu * log(kl))/kl;
    
    yl = k(k<kl).^mu .* exp(al*k(k<kl));                % lower tails
    
    ym = psabr(a,b,r,n,f,k((kl<=k) & (k<=ku)),t);       % the standard sabr part
    
%     V = psabr(a,b,r,n,f,ku,t);    
%     nu = -.005;%log(V)/log(ku)-1;
%     au = (nu *log(ku) - log(V))/ku;
%     yu = k(k>ku).^nu .* exp(-au * k(k>ku));
    
    yu = psabr(a,b,r,n,f,k(k>ku),t);
    
    y = [yl ym yu];
end