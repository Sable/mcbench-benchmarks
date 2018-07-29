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



function pathS = MC_SABR_U(S0, T, sigma_0, alfa, beta, rho, NTime, NSim)

Delta = 1/NTime;                    % size of time steps
NSteps = T/Delta;                   % number time steps overall

pathS = zeros(NSim,NSteps+1);       % init output
pathS(:,1) = S0;                    % set inital spot price
    
S_Delta = repmat(S0,NSim,1);       % dummy variable

for i = 1:NSteps
    % matrix of uniform random numbers used during the sampling algorithm
    %matU = rand(NSim,3);
    
    % Discretization Scheme for a full SABR model
    % Step 1 of sec. 3.6
    %---------------------------------------------------
    % simulate the volatility process at time step Delta according to 
    % a log-normal random variable
    Z = sqrt(Delta)*randn(NSim,1);
    sigma_Delta = sigma_0.*exp(alfa*(Z-0.5*alfa*Delta)); % !! sigma_0 missing in paper !!
    
    % Step 2 of sec. 3.6
    %---------------------------------------------------
    % compute the asymptotic conditional mean and variance for the
    % integrated variance
    if alfa > 0
        m = sigma_0.^2*Delta.*(1 + alfa*(Z + alfa*((2*Z.^2-0.5*Delta)/3 + alfa*((Z.^3-Z*Delta)/3 + alfa*(2/3*Z.^4-1.5*Z.^2*Delta+2*Delta^2)/5))));
        v = sigma_0.^4*alfa^2*Delta^3/3;
    else
        m = sigma_0.^2 * Delta;
        v = 0;
    end
    % step 3 of sec. 3.6
    %---------------------------------------------------
    % compute the parameters of the moment-mathched log-normal distribution
    sigma2 = log(1+v./m.^2);
    mu = log(m) - 0.5*sigma2;
    % Step 4 of sec. 3.6
    %---------------------------------------------------
    %use the inverse transf technique to calculate the int var
    U1 = randn(NSim,1);
    A_Delta = exp(sqrt(sigma2).*U1 + mu);   
    %adjust the int var by the correlation parameter
    v_Delta = (1-rho^2)*A_Delta;
    % Step 5 of sc. 3.6
    %---------------------------------------------------
        
        if beta == 1            % special case: beta = 1
            dW = rho*Z + sqrt(1-rho^2)*sqrt(Delta)*randn(NSim,1); %correlated brownian random vector
            % the unbiased simulation algorithm fails since
            % S_Delta.^(1-beta)/(1-beta) is not invertible at beta = 1
            S_Delta = S_Delta.*(1 + sigma_0.*S_Delta.^(beta-1).*dW);
        else                
            % Direct Inversion Scheme for Conditional CEV Process, see page 13
            % Step 1
            %------------------------------------------------
            % parameters a and b of the cdf for conditional SABR process, see propostion 2.2
            if alfa >0 
                a = (S_Delta.^(1-beta)/(1-beta) + rho*(sigma_Delta-sigma_0)/alfa).^2./v_Delta;
            else
                a = (S_Delta.^(1-beta)/(1-beta)).^2./v_Delta;
            end
            b = 2 - (1-2*beta-rho^2*(1-beta))/(1-beta)/(1-rho^2);
            % Step 2
            %------------------------------------------------
            % draw a vector of uniform random numbers
            U = rand(NSim,1);
            % Step 3
            %------------------------------------------------
            % compute the absorption probability by equation 2.10
            % !! the matlab function "gammainc" already includes the
            % quotient gamma(1/(2(1-beta)) !!
            % !! swaped arguments in matlab !!
            P_absorb = 1 - gammainc(S_Delta.^(2*(1-beta))./(2*(1-beta)^2*v_Delta),1/(2*(1-beta)),'lower');
            %P_absorb = 1 - gammainc(a/2,b/2,'lower'); 
            
            % reference value
            %P_absorb_ref = 1 - chi2cdf(S_Delta.^(2*(1-beta))./((1-beta)^2*v_Delta),1/(1-beta));
            %P_absorb_ref = 1 - chi2cdf(a,b);

            % distinguish between the following cases
            %----------------------------------------
                % (a)
                I1 = S_Delta == 0;
                S_Delta(I1) = 0;
                % (b)
                I2 = S_Delta ~= 0 & U <= P_absorb;
                S_Delta(I2) = 0;                
                % (c)
                I3 = S_Delta ~= 0 & U > P_absorb;
            
            if sum(I3) > 0
                % Step 4
                %-----------------------------------------------
                % compute the parameters for the moment-matched quadratic
                % gaussian approximation, see result 3.1
                k = 2-b;%(1-2*beta-rho^2*(1-beta))/(1-beta)/(1-rho^2);
                lambda = a;%(S_Delta.^(1-beta)/(1-beta)+rho*(sigma_Delta-sigma_0)/alfa).^2./v_Delta;
                m = k+lambda;
                s2 = 2*(k+2*lambda);
                Psi = s2./m.^2;
                
                % Step 5
                %-----------------------------------------------
                % sets the threshold value Psi_thres in [1,2] as switching rule
%                 Psi_thres = 1.5;
                Psi_thres = 2;
                
                % Step 6
                %-----------------------------------------------
                % moment matched quadratic gaussian approximation
                I4 = ((Psi > 0 & Psi <= Psi_thres) & m >= 0) & I3 == true;
                if sum(I4) > 0
                    e2 = 2./Psi-1+sqrt(2./Psi).*sqrt(2./Psi-1);
                    d = m./(1+e2);
                    % update the asset price as quadratic gaussian
                    S_Delta(I4) = ((1-beta)^2*v_Delta(I4).*d(I4).*(sqrt(e2(I4))+randn(sum(I4),1)).^2).^(1/(2*(1-beta)));
                end

                % Step 7
                %---------------------------------------------------
                I5 = ((Psi > Psi_thres | (m < 0 & 0 < Psi & Psi <= Psi_thres)) & I3 == true); 
               
                if sum(I5) > 0
                    % use a Newton method to determine the root c* of the
                    % function : H(a,b,c) = 1-Chi^2(a,b,c)-U = 0
                    % c* is a random number from a squared Bessel
                    % distribution with absorbing boundary at zero                
                  
                    H = @(c,IVec)(1-ncx2cdf(a(IVec),b,c)-U(IVec));
                    
                    % transition density
                    % !! adjusted through c+ = abs(c), since c may become
                    % negative during the Newton recursion !!
                    %qbar = @(c,IVec) (0.5*abs(c).^(0.25*(b-2))./a(IVec) .* exp(-0.5*(a(IVec)+c)) .* besseli(abs(0.5*(b-2)),sqrt(a(IVec).*abs(c))));
                    %qbar = @(c,IVec) (0.5*(c./a(IVec)).^(0.25*(b-2)) .* exp(-0.5*(a(IVec)+c)) .* besseli(abs(0.5*(b-2)),sqrt(a(IVec).*c)));

                    nVec = (1:length(a))';
                    iVec = nVec(I5); 

                    tmp1 = H(zeros(size(iVec)),iVec) < 0 & H(10*a(iVec),iVec) > 0;
                    tmp2 = H(zeros(size(iVec)),iVec) > 0 | H(10*a(iVec),iVec) < 0;
                    
                    indVec = iVec(tmp1);
                    c_star = zeros(size(indVec));
                    % reference implementation (much slower)
                    for k = 1: length(indVec)
                       c_star(k) = fzero(@(c)(1-ncx2cdf(a(indVec(k)),b,c)-U(indVec(k))),[0 10*a(indVec(k))]);
                       %c_star(k) = Bisection(@(c)(1-ncx2cdf(a(indVec(k)),b,c)-U(indVec(k))),0 ,10*a(indVec(k)));
                    end
%                     S_Delta(indexVec) = (abs(c_star).*(1-beta)^2.*v_Delta(indexVec)).^(1/(2-2*beta));                    
                    % Step 8
                    %-------------------------------------------------------------------
                    %apply the inverse coordinate transform to recover the
                    %random numbers in asset price space
                    S_Delta(indVec) = (c_star.*(1-beta)^2.*v_Delta(indVec)).^(1/(2-2*beta));
                    S_Delta(iVec(tmp2)) = 0;
                    % for values of c* < 0 we set S_delta = 0
                    % S_Delta(indexVec(~IndOfInterest)) = 0.0;
                    % c_mean = mean(c_star);
                    % S_Delta(indexVec(~IndOfInterest)) = (c_mean.*(1-beta)^2.*v_Delta(indexVec(~IndOfInterest))).^(1/(2-2*beta));
                end
            end
        end

        % update initial volatility
        sigma_0 = sigma_Delta;
        pathS(:,i+1) = S_Delta;
end

end