function [ fn,hn ] = compute_expansion( X,upf,R )
% COMPUTE_EXPANSION calculates the Fourier series expansion terms, on which
% the Abel inversion algorithm [1] is based.
%
% Details: The unknown distribution f(r) is expanded as
%           f(r) = sum_{n=lof}^{upf} (A_n * f_n(r))                    (1)
% where the lower frequency is set to 1 and the upper frequency upf is
% important for noise-filtering. f_n(r) is a set of cos-functions:
%           f_n(r) = 1 - (-1)^n*cos(n*pi*r/R)  and f_0(r) = 1          (2)
% For the Abel inversion, the integrals h_n have to be calculated
%           h_n(x) = int_x^R f_n(r) * r / sqrt(r^2-x^2) dr             (3)
%
%   [1] G. Pretzler, Z. Naturforsch. 46a, 639 (1991)
%
%                                         written by C. Killer, Sept. 2013


% allocate matrices for f_n and h_n - rows are x-values, 
% columns are the number of expansion elements (n+1 since we start with n=0)
fn=zeros(length(X),upf+1);
hn=zeros(length(X),upf+1);  


% special case: first column for n=0, where f_0(r)=1;
fn(:,1)=1;
for c=1:length(X); 
    x=X(c);
    
    % evaluation of (3)
    fun=@(r) r./sqrt(r.^2-x.^2);
    hn(c,1) = integral(fun,x,R); 
end


% all the other columns
for n=1:upf
    for c=1:length(X)
        x=X(c);
        
        % evaluation of (2)
        fn(c,n+1) = (1 - (-1)^n*cos(n*pi*x/R));
        
        % evaluation of (3)
        fun=@(r) (1 - (-1)^n*cos(n*pi*r/R)).*r./sqrt(r.^2-x.^2);
        hn(c,n+1) = integral(fun,x,R);       
    end
end

% remove the next comment to plot the integrals
% figure; plot(hn); title('cos-expansion integrals h_n(x)')
