% compare_results(X1,X2,try_noises,EXPERIMENT_NUM,F_names)
% Compares the F s computed by different approaches in case of different additive noises
% and different number of points used in the computation of F. 
% The criterion for comparison is the Residual.
% input:
%               X1              3xN     (optional) homogeneous coordinates of matched points in view 1
%               X2              3xN     (optional) homogeneous coordinates of matched points in view 2
%               try_noises      1x1     (optional) if enabled, adds additive noise to the coordinates
%               EXPERIMENT_NUM  1x1     (optional) the number of experiments to perform and average the criterion on
%               F_names         {n}     (optional) cell array of names of the functions to try compute F
%                                       with. Functions will be called using [F] = <name>(x1,x2);
% Notes: 
%- if no data is provided, synthetic data will be used. synthetic data generation does NOT avoid degenerate configuration 
%   and does not guarantee well spread points(although it is tried here to avoid such situations). 
%- the results in the book were computed without any outliers(perhaps with quantization error imposed by "pixel" matching).
%- this code compares the results of algorithms in presence of noise and outliers. The corresponding coordinates are quantized to pixel entities,
%   however, in practice, using techniques like line fitting, it is possible to get sub-pixel accuracy. In that case, one can use the flag 
%   QUANTIZATION_ENABLED and set it to 0.
% 
% Author: Omid Aghazadeh, KTH(Royal Institute of Technology), 2010/05/09
function compare_results(X1,X2,try_noises,EXPERIMENT_NUM,F_names)
global TOL_X TOL_FUN MAX_FUN_EVAL MAX_ITER;
if nargin<5, 
%     F_names ={'normalized_8_point','algebraic_l1','algebraic_l2','geometric_gold_l1','geometric_gold_l2','geometric_sampson_l1'}; 
    F_names = {'normalized_8_point','algebraic_l1','algebraic_l1_not_nomralized','geometric_gold_l1','geometric_sampson_l1','geometric_gold_l1_not_normalized'}; 
end
if nargin<4, EXPERIMENT_NUM = 50; end
if nargin<3, try_noises = 1; end
if nargin<2
    if exist('synthetic_model.mat','file')
        load ('synthetic_model.mat');
    else
        range_pic = [640;480];
        N = 50;
        thresh_ang = 0.25;
        thresh_en = 0.33;
        while 1
            [X1,X2,P1,P2] = make_synthetic_data(N,[10;10;10],range_pic); 
            cam_ang = P1(:)'*P2(:) / norm(P1(:)) /norm(P2(:));
            [u1,s1,v1]  = svd(X1(1:2,:));
            [u2,s2,v2]  = svd(X2(1:2,:));
            s1e = diag(s1) / N^2;
            s2e = diag(s2) / N^2;
            if sum(s1e<thresh_en) || sum(s2e<thresh_en)|| cam_ang < thresh_ang, continue, end % trying to avoid degenerate configuration
            save('synthetic_model.mat','X1','X2');
            break;
        end
        
    end
end
QUANTIZATION_ENABLED = 1;
clc; close all;
N_alg = length(F_names);
if ~try_noises
    NOISE_ENERGY = 0;
    NOISE_TYPE = 0;
else
    MIN_ENERGY_NOISE = 1; % noise energy definition
    MAX_ENERGY_NOISE = 3;
    NOISE_ENERGY_COUNT = 2;
    NOISE_ENERGY = linspace(MIN_ENERGY_NOISE,MAX_ENERGY_NOISE,NOISE_ENERGY_COUNT);
    PROB_SPURIOUS = 1e-1; SPURIOUS_MULTIPLIER = 10; % spurious noise ratio corresponds to the ration of outliers in the estimates
    NOISE_TYPE = 1:3; % 0: no noise, 1: gaussian, 2: uniform, 3: spurious
end
N_noise_energy = length(NOISE_ENERGY);
N_noise_type= length(NOISE_TYPE);
TOL_X = 1e-4; TOL_FUN = 1e-4; MAX_FUN_EVAL = 1e4; MAX_ITER = 1e3; % parameters of the iterative minimization (LM) method
TRY_UB = 25; %size(X1,2)
% TRY_UB = round(2/3*size(X1,2));
RESIDUALS = zeros(N_noise_type,TRY_UB-7,N_alg,N_noise_energy,EXPERIMENT_NUM); RUN_TIMES = RESIDUALS;
Noise_Names = {'no noise','zm gaussian','uniform', 'spurious'}; 
Colors = {'r-','go-','g.-','bo-','b.-','bx-'};
% Colors = {'r-','g.-','b.-','b--'};
F_names_disp = F_names; 
for i =1:N_alg, F_names_disp{i}(F_names{i} == '_') = '-'; end;
for noise_type_i = 1:N_noise_type;
	noise_type = NOISE_TYPE(noise_type_i);
    for noise_energy_i = 1:N_noise_energy
        noise_energy = NOISE_ENERGY(noise_energy_i);
        for N = 8: TRY_UB
            for experiment = 1 : EXPERIMENT_NUM
                ixr = randperm(size(X1,2));
                x1 = X1(:,ixr(1:N));
                x2 = X2(:,ixr(1:N));

                x2n = x2; x1n=x1;
                switch noise_type
                    case 0 % no noise
                    case 1 % gaussian, zero mean!
                        x1n(1:2,:) = x1n(1:2,:) + randn(2,N)*noise_energy ;
                        x2n(1:2,:) = x2n(1:2,:) + randn(2,N)*noise_energy ;
                    case 2 % uniform, noise_param ~ energy
                        x1n(1:2,:) = x1n(1:2,:) + (rand(2,N)-0.5)*2*noise_energy;
                        x2n(1:2,:) = x2n(1:2,:) + (rand(2,N)-0.5)*2*noise_energy;
                    case 3 % spurious, noise_param ~ probability
                        r = rand(1,N);
                        ixnoise = find(r<PROB_SPURIOUS);
                        x1n(1:2,ixnoise) = x1n(1:2,ixnoise)+ (rand(2,length(ixnoise))-0.5)*2*noise_energy*SPURIOUS_MULTIPLIER;
                        x2n(1:2,ixnoise) = x2n(1:2,ixnoise)+ (rand(2,length(ixnoise))-0.5)*2*noise_energy*SPURIOUS_MULTIPLIER;
                end

                for algi = 1: N_alg
                    tic;
                    if QUANTIZATION_ENABLED
                        eval(sprintf('F=%s(round(x1n),round(x2n));',F_names{algi})); % compute the F using noisy points
                    else
                        eval(sprintf('F=%s((x1n),(x2n));',F_names{algi})); % compute the F using noisy points
                    end
                    
                    t = toc;

                    residual = get_residual(X1,X2,F); % testing F on the noiseless data, all points
                    RESIDUALS(noise_type_i,N-7,algi,noise_energy_i,experiment) = residual;
                    RUN_TIMES(noise_type_i,N-7,algi,noise_energy_i,experiment) = t;
                end
            end
        end
        
        figure; set(gcf,'Name',['Residuals/Noise Model ' Noise_Names{noise_type+1} ', noise energy=' num2str(noise_energy) ]); hold on;
        for i =1:N_alg
            plot(8:TRY_UB,log(mean(RESIDUALS(noise_type_i,:,i,noise_energy_i,:),5)),Colors{i});  % averaging over the experiments and plotting the data
        end
        title(sprintf('log Residual vs Number of Points, noise model: %s, noise energy: %f, Quantization enabled: %d',Noise_Names{noise_type+1},noise_energy,QUANTIZATION_ENABLED)); legend(F_names_disp); 

%         figure; set(gcf,'Name',['Run Time/Noise Model ' Noise_Names{noise_type+1} ', noise energy=' num2str(noise_energy) ]); hold on;
%         for i =1:N_alg
%             plot(8:TRY_UB,log(mean(RUN_TIMES(noise_type_i,:,i,noise_energy_i,:),5)),Colors{i});  % averaging over the experiments and plotting the data
%         end
%         title(sprintf('log runtime vs Number of Points, noise model: %s, noise energy: %f',Noise_Names{noise_type+1},noise_energy)); legend(F_names_disp); 
        drawnow;
    end
    
    
end
end

function res = get_residual(x1,x2,F)
d_x2_Fx1 = get_D_point_line(x2,F*x1); d_x1_Fx2 = get_D_point_line(x1,F'*x2);
res = mean(d_x2_Fx1.^2 + d_x1_Fx2.^2);
end

% function d = get_D_point_line(X1,Lp2)
% computes the distance of points X1 (homogeneous coordinates) to the lines
% Lp2. 
function d = get_D_point_line(X1,Lp2)
if sum(X1(3,:)~=1), error('the points are assumed to be normalized (last dimension = 1)'); end
d = abs(sum(X1 .* Lp2,1))./sqrt(sum(Lp2(1:2,:).^2));
end

function F= algebraic_l1(x1,x2), F = det_F_algebraic(x1,x2,1); end % sample functions to show the usage of algorithms
function F= algebraic_l2(x1,x2), F = det_F_algebraic(x1,x2,2); end
function F= algebraic_l1_not_nomralized(x1,x2), F = det_F_algebraic(x1,x2,1,0); end
function F= geometric_sampson_l1(x1,x2), F = det_F_gold(x1,x2,1,1); end
function F= geometric_gold_l1(x1,x2), F = det_F_gold(x1,x2,1); end
function F= geometric_gold_l1_not_normalized(x1,x2), F = det_F_gold(x1,x2,1,0,0); end
function F= geometric_gold_l2(x1,x2), F = det_F_gold(x1,x2,2); end
function F= normalized_8_point(x1,x2), F = det_F_normalized_8point(x1,x2); end
