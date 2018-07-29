%% this is an implementation of kalman filter.
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.

clear;
 %% 
 % z_t = A z_t-1 + w; N(0, sigma_w);
 % x_t = C x_t + v; N(0, sigma_v);
 % z_1 = mu_0 + u; N(0, sigma_0);
 
 %% generating fake data.
 s = RandStream('mt19937ar','Seed',4);
 RandStream.setGlobalStream(s);
 T = 40; 
 z = zeros(2, T);
 x = zeros(2, T);
 d_x = size(x, 1);
 d_z = size(z, 1);
 mu_0 = [4; 4];
 sigma_0 = [1, 0
            0, 1]; 
        
 sigma_w = [0.1,   0
              0, 0.3];  
 sigma_v = [0.05,    0
              0, 0.1];         
 A = [  1, 0.04
        0.02, 1];
  
 C = [  1, 0.1
        0.2, 1];
 
 z(:, 1) = mvnrnd(mu_0, sigma_0, 1)';
 x(:, 1) = C * z(:, 1) + mvnrnd([0, 0], sigma_v, 1)';
 for t = 2:T
     z(:, t) = A * z(:, t-1) + mvnrnd([0, 0], sigma_w, 1)';
     x(:, t) = C * z(:, t) + mvnrnd([0, 0], sigma_v, 1)';
 end

 
 
 %% kalman filter
 mu_est = cell(T, 1);
 mu_est_sm = cell(T, 1);
 sigma_v_est = cell(T, 1); 
 sigma_v_est_sm = cell(T, 1); 
 K_est = cell(T, 1);
 P_est = cell(T, 1);
 J_est = cell(T, 1);
 %% kalman filter
  K_est{1} = sigma_0 * C'/(C*sigma_0*C' + sigma_v);
  mu_est{1} = mu_0 +  K_est{1} * (x(:, 1) - C*mu_0);
  sigma_v_est{1} = (eye(d_x) - K_est{1}*C)*sigma_0;  
  
  for t = 2:T
      P_est{t-1} = A*sigma_v_est{t-1}*A' + sigma_w;
      K_est{t} = P_est{t-1} * C'/(C*P_est{t-1}*C' + sigma_v);      
      mu_est{t} = A * mu_est{t-1} +  K_est{t} * (x(:, t) - C* A * mu_est{t-1});
      sigma_v_est{t} = (eye(d_x) - K_est{t}*C)*P_est{t-1};
  end   
  
  %% kalman smoother
   mu_est_sm{T} = mu_est{T};
   sigma_v_est_sm{T} = sigma_v_est{T};
   for t = (T-1):-1:1
      J_est{t} = sigma_v_est{t}*A'/P_est{t};      
      mu_est_sm{t} = mu_est{t} +  J_est{t} * (mu_est_sm{t+1} - A * mu_est{t});
      sigma_v_est_sm{t} = sigma_v_est{t} +  J_est{t} * (sigma_v_est_sm{t+1} - P_est{t}) * J_est{t}';      
   end
 
  %%
  figure(1); clf;
  plot(z(1, :), z(2, :), '.'); hold on;
  plot(x(1, :), x(2, :), 'ro'); hold on;
  mu_tmp = cell2mat(mu_est');
  plot(mu_tmp(1, :), mu_tmp(2, :), 'kx'); hold on;
  mu_tmp_sm = cell2mat(mu_est_sm');
  plot(mu_tmp_sm(1, :), mu_tmp_sm(2, :), 'g*'); hold on;
  h = legend('Hidden state', 'observation', 'kalman filter', 'kalman smoother');
  set(h, 'box', 'off', 'location', 'best');
  fprintf('MAD:x_z = %f\n', mean(abs((x(:) - z(:)))));
  fprintf('MAD:kf_z = %f\n', mean(abs((mu_tmp(:) - z(:)))));
  fprintf('MAD:kf_sm_z = %f\n', mean(abs((mu_tmp_sm(:) - z(:)))));