function denoise_PRL_2010_main
%
% This is a demo program of the paper J. Tian, W. Yu, and L. Ma, "AntShrink: Ant
% colony optimization for image shrinkage," Pattern Recognition Letters,
% Vol. 31, Oct. 2010, pp. 1751-1758.
%
% Contact: eejtian@gmail.com
%
% Note that the PSNR values could be slightly different with that reported 
% in paper due to the random number generator used to generate noisy image.
%
% The input image should have a square size.
%
% Acknowledgement: This program needs Wavelet transform toolbox, which is 
% downloaded from http://www-stat.stanford.edu/~wavelab/.

clear all; close all; clc;

% Load the ground truth image
img_truth = double(imread('barbara_truth.bmp'));
[nRow, nColumn] = size(img_truth);    

% Use the ground truth image to generate the noisy image
noise_sig_truth = 10; % sigma_n used in the paper. This parameter is adjusted by the user.
noise_mu = 0;
img_noisy = img_truth + randn(size(img_truth)) .* noise_sig_truth + noise_mu;

% wavelet parameters
wbase = 'Daubechies';
mom = 8;
dwt_level = 5; %note that here, dwt_scale means the decomposition level of the DWT
[n,J] = func_quadlength(img_truth);
L = J-dwt_level;%here, L means the size of the coarsest level, 2^L      


win_size = 2;
img_denoised = zeros(size(img_noisy));        

% Since this is time consuming approach, divide the image into four parts, then 
% conduct denoising for each part
for ii=1:4            
    win_size=2;    

    switch ii
        case 1
            img_denoised(1:end/2,1:end/2) = func_ACOShrink(img_noisy(1:end/2,1:end/2), wbase, mom, dwt_level, win_size);                        
        case 2
            img_denoised(end/2+1:end,1:end/2) = func_ACOShrink(img_noisy(end/2+1:end,1:end/2), wbase, mom, dwt_level, win_size);                        
        case 3
            img_denoised(1:end/2,end/2+1:end) = func_ACOShrink(img_noisy(1:end/2,end/2+1:end), wbase, mom, dwt_level, win_size);                        
        case 4
            img_denoised(end/2+1:end,end/2+1:end) = func_ACOShrink(img_noisy(end/2+1:end,end/2+1:end), wbase, mom, dwt_level, win_size);                        
    end

end

% Calculate the PSNR performance
fprintf('PSNR=%.2fdB\n', func_psnr_gray(img_truth, img_denoised));

% Write the output image
imwrite(uint8(img_denoised), 'barbara_denoised.bmp','bmp');

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
% Main algorithm of proposed AntShrink algorithm
function x_out= func_ACOShrink(x_in, wbase, mom, dwt_level, win_size)

[nrow, ncol] = size(x_in);
L = log2(size(x_in,2))-dwt_level;

% Estimate the noise_sigma from the noisy signal
qmf = func_MakeONFilter(wbase,mom);
[temp, coef] = func_NormNoise_2d(x_in, qmf);
noise_sigma = 1/coef;

wx  = func_FWT2_PO(x_in, L, qmf);
[n,J] = func_dyadlength(wx);
ws = wx;

rr = (meshgrid(1:nrow))'; cc = meshgrid(1:ncol);

ant_search_range_row_min = rr;
ant_search_range_row_max = rr;
ant_search_range_col_min = cc;
ant_search_range_col_max = cc;

for j=(J-1):-1:L
    [t1,t2] = func_dyad2HH(j);
    ant_search_range_row_min(t1,t2) = min2(t1);
    ant_search_range_row_max(t1,t2) = max2(t1);
    ant_search_range_col_min(t1,t2) = min2(t2);
    ant_search_range_col_max(t1,t2) = max2(t2);    
    [t1,t2] = func_dyad2HL(j);
    ant_search_range_row_min(t1,t2) = min2(t1);
    ant_search_range_row_max(t1,t2) = max2(t1);
    ant_search_range_col_min(t1,t2) = min2(t2);
    ant_search_range_col_max(t1,t2) = max2(t2);
    [t1,t2] = func_dyad2LH(j);
    ant_search_range_row_min(t1,t2) = min2(t1);
    ant_search_range_row_max(t1,t2) = max2(t1);
    ant_search_range_col_min(t1,t2) = min2(t2);
    ant_search_range_col_max(t1,t2) = max2(t2);
end   

data_var = func_signal_variance_estimation(wx, noise_sigma, win_size,ant_search_range_row_min,ant_search_range_row_max,ant_search_range_col_min,ant_search_range_col_max,J,L);
   
for j=(J-1):-1:L
    [t1,t2] = func_dyad2HH(j);
    ws(t1,t2) = wx(t1,t2) .* data_var(t1,t2) ./ (data_var(t1,t2) + noise_sigma.^2);
    [t1,t2] = func_dyad2HL(j);
    ws(t1,t2) = wx(t1,t2) .* data_var(t1,t2) ./ (data_var(t1,t2) + noise_sigma.^2);
    [t1,t2] = func_dyad2LH(j);
    ws(t1,t2) = wx(t1,t2) .* data_var(t1,t2) ./ (data_var(t1,t2) + noise_sigma.^2);
end 

x_out  = func_IWT2_PO(ws, L, qmf);

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
% Estimate the signal variance value, which will be used for shrinkage
function result = func_signal_variance_estimation(wx, noise_sigma, win_size,ant_search_range_row_min,ant_search_range_row_max,ant_search_range_col_min,ant_search_range_col_max,J,L)

% System setup
ant_move_step_within_iteration = 5; % the numbe of iterations?
total_iteration_num = 5;
search_clique_mode = 8;  

wx = abs(wx);
[nrow, ncol] = size(wx);
wx_1D = func_2D_LexicoOrder(wx);

% initialization
h = zeros(size(wx));
h_1D = func_2D_LexicoOrder(h);
p = 1./(wx.*(wx~=0)+1.*(wx==0)).*(wx~=0)+(wx==0);
p_1D = func_2D_LexicoOrder(p);

%paramete setting
alpha = 1;      
beta = 2;       
rho = 0.1;      
w = 0.6;        
A = 5000;       
B = 10;         

%use one ant for each pixel position
ant_total_num = nrow*ncol;
ant_current_row = zeros(ant_total_num, 1); % record the location of ant
ant_current_col = zeros(ant_total_num, 1); % record the location of ant
ant_current_val = zeros(ant_total_num, 1); % record the location of ant
rr = (meshgrid(1:nrow))'; cc = meshgrid(1:ncol);
ant_current_row = rr(:);
ant_current_col = cc(:);
ant_current_val = wx_1D((ant_current_row-1).*ncol+ant_current_col);

ant_search_range_row_min = ant_search_range_row_min(:);
ant_search_range_row_min = padarray(ant_search_range_row_min, [0 search_clique_mode-1],'replicate','post');
ant_search_range_row_max = ant_search_range_row_max(:);
ant_search_range_row_max = padarray(ant_search_range_row_max, [0 search_clique_mode-1],'replicate','post');
ant_search_range_col_min = ant_search_range_col_min(:);
ant_search_range_col_min = padarray(ant_search_range_col_min, [0 search_clique_mode-1],'replicate','post');
ant_search_range_col_max = ant_search_range_col_max(:);
ant_search_range_col_max = padarray(ant_search_range_col_max, [0 search_clique_mode-1],'replicate','post');                

            
for nIteration = 1: total_iteration_num               

        ant_current_path_val_mean = zeros(ant_total_num,1);
        ant_current_path_val_mean = ant_current_val;            

        for nMoveStep = 1: ant_move_step_within_iteration-1                

            if search_clique_mode == 4
                ant_search_range_row = [ant_current_row-1, ant_current_row, ant_current_row+1, ant_current_row];
                ant_search_range_col = [ant_current_col, ant_current_col+1, ant_current_col, ant_current_col-1];                    
            elseif search_clique_mode == 8
                ant_search_range_row = [ant_current_row-1, ant_current_row-1, ant_current_row-1, ant_current_row, ant_current_row,ant_current_row+1, ant_current_row+1, ant_current_row+1];
                ant_search_range_col = [ant_current_col-1, ant_current_col, ant_current_col+1, ant_current_col-1, ant_current_col+1, ant_current_col-1, ant_current_col, ant_current_col+1];
            end

            ant_current_row_extend = padarray(ant_current_row, [0 search_clique_mode-1],'replicate','post');
            ant_current_col_extend = padarray(ant_current_col, [0 search_clique_mode-1],'replicate','post');
            ant_search_range_val = zeros(ant_total_num,search_clique_mode);

            %replace the positions our of the image's range           
            temp = (ant_search_range_row>=ant_search_range_row_min) & (ant_search_range_row<=ant_search_range_row_max) & (ant_search_range_col>=ant_search_range_col_min) & (ant_search_range_col<=ant_search_range_col_max);
            ant_search_range_row = temp.*ant_search_range_row + (~temp).*ant_current_row_extend;
            ant_search_range_col = temp.*ant_search_range_col + (~temp).*ant_current_col_extend;

            ant_search_range_transit_prob_h = zeros(size(ant_search_range_val));
            ant_search_range_transit_prob_p = zeros(size(ant_search_range_val));                                

            for ii=1:search_clique_mode
                ant_search_range_val(:,ii) = wx_1D((ant_search_range_row(:,ii)-1).*ncol+ant_search_range_col(:,ii));

                temp = ant_search_range_val(:,ii);
                temp = abs(temp - ant_current_path_val_mean);    
                temp = 1./(temp.*(temp~=0)+1.*(temp==0)) .* (temp~=0)+(temp==0);

                ant_search_range_transit_prob_h(:,ii) = temp;
                ant_search_range_transit_prob_p(:,ii) = p_1D((ant_search_range_row(:,ii)-1).*ncol+ant_search_range_col(:,ii));

            end
            temp = (ant_search_range_transit_prob_h.^alpha) .* (ant_search_range_transit_prob_p.^beta);

            temp_sum = sum(temp,2);
            temp_sum = padarray(temp_sum, [0 search_clique_mode-1],'replicate','post');

            ant_search_range_transit_prob = temp ./ temp_sum;

            % generate a random number to determine the next position.
            rand('state', sum(100*clock));
            temp = rand(ant_total_num,1);
            temp = padarray(temp, [0 search_clique_mode-1],'replicate','post');
            temp = cumsum(ant_search_range_transit_prob,2)>=temp;
            temp = padarray(temp, [0 1],'pre');
            temp = (diff(temp,1,2)==1);

            temp_row = (ant_search_range_row .* temp)';
            [ii, jj, vv] = find(temp_row);
            ant_next_row = vv;
            temp_col = (ant_search_range_col .* temp)';
            [ii, jj, vv] = find(temp_col);
            ant_next_col = vv;

            ant_current_row = ant_next_row;
            ant_current_col = ant_next_col;                
            ant_current_val = wx_1D((ant_current_row-1).*ncol+ant_current_col);
            ant_current_path_val_mean = (ant_current_path_val_mean.*nMoveStep + ant_current_val)/(nMoveStep+1);

            %update p;
            rr = ant_current_row;
            cc = ant_current_col;
            p_1D((rr-1).*ncol+cc,1) = w*p_1D((rr-1).*ncol+cc,1) + 1./(A+B.*ant_current_path_val_mean);
            p = func_LexicoOrder_2D(p_1D, nrow, ncol);

        end % end of nMoveStep

        p = (1-rho).*p;
        p_1D = func_2D_LexicoOrder(p);

end % end of nIteration

clear h h_1D temp
clear ant_current_row ant_current_col ant_current_val
clear ant_current_path_val_mean
clear ant_search_range_row search_range_path_col ant_search_range_val
clear ant_search_range_transit_prob_h ant_search_range_transit_prob_v ant_search_range_transit_prob
clear ant_search_range_row_min ant_search_range_row_max ant_search_range_col_min ant_search_range_col_max

result = wx.^2;

for j=(J-1):-1:L
    [t1,t2] = func_dyad2HH(j);
    result(t1,t2) = func_determine_class_fcm(wx(t1,t2), p(t1,t2), win_size, noise_sigma);
    [t1,t2] = func_dyad2HL(j);
    result(t1,t2) = func_determine_class_fcm(wx(t1,t2), p(t1,t2), win_size, noise_sigma);
    [t1,t2] = func_dyad2LH(j);
    result(t1,t2) = func_determine_class_fcm(wx(t1,t2), p(t1,t2), win_size, noise_sigma);
end  

% ******************************************************************************
% **************************Inner Function *************************************
% ******************************************************************************
% Bi-class classification algorithm using Fuzzy C-means
function result = func_determine_class_fcm(wx, p, win_size, noise_sigma)

p_1D = func_2D_LexicoOrder(p);
wx_1D = func_2D_LexicoOrder(wx);
[nrow, ncol] = size(wx);

nFeature = p_1D(:)./(max(max(p_1D)));
[center,U,obj_fcn] = fcm(nFeature, 2,[2.0 100 1e-5 0]);

idx = zeros(nrow:ncol,1);    
if sum(sum(wx_1D(U(1,:) >= U(2,:)))) >= sum(sum(wx_1D(U(1,:) < U(2,:))))
    idx = U(1,:) >= U(2,:);
else
    idx = U(1,:) < U(2,:);
end
idx = func_LexicoOrder_2D(idx, nrow, ncol);    

center_class = idx(:);
padnum = win_size;
A = padarray(wx, [padnum padnum], 'replicate', 'bot');
B = padarray(idx, [padnum padnum], 'replicate', 'bot');

A = im2col(A, [win_size*2+1 win_size*2+1],'sliding');
A = A.^2;
B = im2col(B, [win_size*2+1 win_size*2+1],'sliding');

C = padarray(center_class', [size(A,1)-1, 0], 'replicate', 'post');

result = sum(A,1) ./ (win_size*2+1)./(win_size*2+1);
result = reshape(result, [nrow, ncol]);
result = (result>=noise_sigma^2).*(result-noise_sigma^2);

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
% Convert data from 2D format to 1D format
function result = func_2D_LexicoOrder(x)
temp = x';
result = temp(:);

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
% Convert data from 1D format to 2D format
function result = func_LexicoOrder_2D(x, nRow, nColumn)
result = reshape(x, nColumn, nRow)';

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
function result=min2(f)
%calculate minimum of 2D matrix
result=min(min(f));

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
function result=max2(f)
%calculate maximum of 2D matrix
result=max(max(f));

%-------------------------------------------------------------------------
%------------------------------Inner Function ----------------------------
%-------------------------------------------------------------------------
% Calculate the PSNR performance to two images
function result = func_psnr_gray(f, g)

f = double(f);
g = double(g);
Q=255; MSE=0;
[M,N]=size(f);
h = f - g;
MSE = sum(sum(h.*h));
MSE=MSE/M/N;
result=10*log10(Q*Q/MSE);