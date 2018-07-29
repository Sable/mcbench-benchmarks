% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Inputs:
%   gD: 2D coordinates of data graph nodes
%   aD1,aD2: edges so that i-th edge joins aD1(i)-th and aD2(i)-th nodes
%   gM,aM1,aM2: model graph
%   Pe: probability of structural error
%   Nd: tolerance to outliers
%   Sini: input matrix of initial matching coefficients
%   mu_inc: annealing parameter of softassign (used to control speed)
%   center_rescale: boolean settinig whether it has to be performed center
%                   and rescaling on the point-sets
% 
% Outputs:
%   S: matrix of match coefficients (without extra row and column)
%   Sf: matrix of match coefficients (with extra row and column)
% 

function [S Sf] = gm_em_soft(gD,aD1,aD2,gM,aM1,aM2,Pe,Nd,Sini,mu_inc,center_rescale)

% Ini vars
lD = length(gD);
lM = length(gM);
S = Sini;

% Softassign control vars
mu = 0.8;
mu_final = 8;
% mu_inc = 1.075;
max_its_B = 4;
max_its_C = 5;%30;
thresh_B = 0.5;
thresh_C = 0.05;

if nargin < 11
    center_rescale = true;
end
if center_rescale
    [gM gD] = center_rescale_weighted(gM,gD,S);
end

% Algorithm
while mu < mu_final
    
    its_B = 0;
    Sant = rand(size(S));
    abs_B = abs(Sant - S);
    
    while its_B <= max_its_B && sum(abs_B(:)) > thresh_B

        % MAXIMIZATION ALIGN
        if center_rescale
            [gM gD] = center_rescale_weighted(gM,gD,S);
        end
        gM = align_weighted(gD,S,gM);  % rigid alignment
        sigma = sigma_weighted(gD,gM,S);  % estimate covariances

        % EXPECTATION (structure)
        lQ = c_calc_Q(aD1,aD2,aM1,aM2,S,log((1-Pe)/Pe)*ones(lD,lM));
        Post = norm_sinkhorn(exp(lQ),max_its_C,thresh_C); % posterior prob.
        
        % Position
        lP = zeros(lD,lM);
        for it_dim = 1:2
            lP = lP - ...
                ((gD(:,it_dim)*ones(1,lM) - ones(lD,1)*gM(:,it_dim)').^2) ...
                ./ sigma(it_dim,it_dim);
        end
        lP = lP ./ 2;
        
%         % Energy
%         e = sum(sum(exp(lQ + ((lP + Nd^2).*S)),2));

        % MAXIMIZATION
        lQ = c_calc_Q(aD1,aD2,aM1,aM2,Post,log((1-Pe)/Pe)*ones(lD,lM));
        % 
        F = lQ + ((lP + Nd^2));

        % MAXIMIZATION CORRESP
        Sant = S;
        S = exp(mu*F);
        [S Sf] = norm_sinkhorn_null(S,max_its_C,thresh_C);
        % 
        abs_B = abs(Sant - S);
        its_B = its_B + 1;
        

    end
    mu = mu * mu_inc;
%     disp(['mu = ' num2str(mu)]);
end




