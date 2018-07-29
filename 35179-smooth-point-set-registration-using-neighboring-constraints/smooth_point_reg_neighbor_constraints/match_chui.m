% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Nonrigid extension to non-rigidly register samples from Chui's dataset.
% 
% Input:
%   gM,gD: coordinates of model and data graph nodes
% 
% Output:
%   vgM: transformed model point-set
% 

function vgM = match_chui(gM,gD)

lD = length(gD);
lM = length(gM);

% Init control parameters:
% ------------------------
T_init = 0.5;
T_finalfac = 500;
anneal_rate = 0.93;
lambda1_init = 1;
lambda2_init = 0.01;

T       = T_init;
T_final = T_init / T_finalfac;

vgM = gM;

% Adjacencies
K = 5;
[aD1,aD2] = adjKNN_eff(gD,K);

flag_stop = 0;
while (flag_stop ~= 1)

%     disp(['Temp: ',num2str(T)]);

    % Adjacencies
    K = 5;
    [aM1,aM2] = adjKNN_eff(vgM,K);
    
    Sini = ini_pos(gD,vgM);  % Initial match matrix
    Pe = 0.03;  % Probability of structural error
    mu_inc = 1.2;  % Softassign control 
    Nd = 1;  % tolerance to outliers
    [S Sf] = gm_em_soft(gD,aD1,aD2,vgM,aM1,aM2,Pe,Nd,Sini,mu_inc);
    Sd = clean_sinkhorn(Sf);  % clean with null assignments
    
    % TPS warping
    lambda1 = lambda1_init*lM*T;  % regularization parameters are set as
    lambda2 = lambda2_init*lM*T;  % in Chui and Rangarajan's TPS-RPM
    % Deform
    [iD,iM] = ind2sub(size(Sd),find(Sd(:)==1));
    [c_tps,d_tps]  = ctps_gen(gM(iM,:),gD(iD,:),lambda1,lambda2);
    vgM = ctps_warp_pts(gM,gM(iM,:),c_tps,d_tps); 
    
    T = T * anneal_rate;
    if T < T_final; flag_stop = 1; end;
    
end



