% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Nonrigid extension to non-rigidly register samples from Chui's dataset
% specially designed for the outliers case
% 
% Input:
%   gM,gD: coordinates of model and data graph nodes
% 
% Output:
%   vgM: transformed model point-set
% 

function vgM = match_chui_outl(gM,gD)

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

flag_stop = 0;
iter = 1;
while (flag_stop ~= 1)

%     disp(['Temp: ',num2str(T)]);
    
    if iter == 1
        % Only at the first iteration we use an heuristic to label outlier
        % points (useful for the Chui's dataset).
        inl = label_outl_chui(vgM,gD);
    else
        inl = 1:lD;
    end
    gDc = gD(inl,:);
    gDc = gDc - repmat(mean(gDc),size(gDc,1),1);
    gMc = vgM - repmat(mean(vgM),size(vgM,1),1);
    
    % Adjacencies
    K = 2;
    [aD1,aD2] = adjZD_eff(gDc,K);
    [aM1,aM2] = adjZD_eff(gMc,K);

    Sini = ini_pos2(gDc,gMc);  % Initial match configuration
    mu_inc = 1.2;  % Softassign control 
    Pe = 0.03;  % Probability of structural error
    Nd = 1;  % Tolerance to outliers
    [S Sf] = gm_em_soft(gDc,aD1,aD2,gMc,aM1,aM2,Pe,Nd,Sini,mu_inc,false);
    Sd = clean_sinkhorn(Sf);  % clean with assignments to null
    [iiD,iM] = ind2sub(size(Sd),find(Sd(:)==1));
    iD = inl(iiD)';

    % TPS warping
    lambda1 = lambda1_init*lM*T;  % regularization parameters are set as
    lambda2 = lambda2_init*lM*T;  % in Chui and Rangarajan's TPS-RPM
    % Deform
    [c_tps,d_tps]  = ctps_gen(gM(iM,:),gD(iD,:),lambda1,lambda2);
    vgM = ctps_warp_pts(gM,gM(iM,:),c_tps,d_tps); 
    
    T = T * anneal_rate;
    iter = iter + 1;
    if T < T_final; flag_stop = 1; end;
    
end



