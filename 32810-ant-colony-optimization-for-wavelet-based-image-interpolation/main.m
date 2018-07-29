function main
%
% This is a demo program of the paper J. Tian, L. Ma, and W. Yu, "Ant
% colony optimization for wavelet-based image interpolation using a 
% three-component exponential mixture model," Expert Systems with 
% Applications, Vol. 38, No. 10, Sept. 2011, pp. 12514-12520.
%
% Contact: eejtian@gmail.com
%
% Note that the PSNR values could be slightly different with that reported 
% in paper due to the random number generator.
%
% The input image should have a square size.
%
% Acknowledgement: This program needs Wavelet transform toolbox, which is 
% downloaded from http://www-stat.stanford.edu/~wavelab/.

clear all; close all; clc;

img_truth = im2double(imread('lena_truth.bmp'));

% Generate low-resolution image
psf_filter =  fspecial('average', 3); 
img_in = imfilter(img_truth, psf_filter, 'symmetric');    
wfilter_type = 'bior2.2';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wfilter_type);
Lo_D = Lo_D ./ sqrt(2);
Hi_D = Hi_D ./ sqrt(2);
Lo_R = Lo_R .* sqrt(2);
Hi_R = Hi_R .* sqrt(2);
[ca1,ch1,cv1,cd1] = dwt2(img_in, Lo_D, Hi_D, 'mode', 'per');    
img_low = ca1;

%--------------------------------------------------------------------------
%-------------- PASS 1: Generate mask using ACO for interpolation ---------
%--------------------------------------------------------------------------
[ca1,ch1,cv1,cd1] = dwt2(img_low, Lo_D, Hi_D, 'mode', 'per');    
[ca2,ch2,cv2,cd2] = dwt2(ca1, Lo_D, Hi_D, 'mode', 'per');                         

ch1_mask = func_aco_thresholding_estimate_mask(ch1);
cv1_mask = func_aco_thresholding_estimate_mask(cv1);
cd1_mask = func_aco_thresholding_estimate_mask(cd1);
ch2_mask = func_aco_thresholding_estimate_mask(ch2);
cv2_mask = func_aco_thresholding_estimate_mask(cv2);
cd2_mask = func_aco_thresholding_estimate_mask(cd2);

%--------------------------------------------------------------------------
%-------------- PASS 2: Image interpolation in wavelet domain -------------
%--------------------------------------------------------------------------
% Parameter setting
img_in = img_low;
nEnlargeFactor = 2;
win_size = 7;
nTotalIteration = 10;

[ca1,ch1,cv1,cd1] = dwt2(img_in, Lo_D, Hi_D, 'mode', 'per');    
[ca2,ch2,cv2,cd2] = dwt2(ca1, Lo_D, Hi_D, 'mode', 'per');       

[ch1_par1, ch1_par2, ch1_par3] = func_proposed_three_state_estimation_aco_seg(ch1, ch1_mask, win_size);
[ch2_par1, ch2_par2, ch2_par3] = func_proposed_three_state_estimation_aco_seg(ch2, ch2_mask, win_size);
[cd1_par1, cd1_par2, cd1_par3] = func_proposed_three_state_estimation_aco_seg(cd1, cd1_mask, win_size);
[cd2_par1, cd2_par2, cd2_par3] = func_proposed_three_state_estimation_aco_seg(cd2, cd2_mask, win_size);
[cv1_par1, cv1_par2, cv1_par3] = func_proposed_three_state_estimation_aco_seg(cv1, cv1_mask, win_size);
[cv2_par1, cv2_par2, cv2_par3] = func_proposed_three_state_estimation_aco_seg(cv2, cv2_mask, win_size);

% Variance estimation
ch0_par1 = func_proposed_par_propogation(ch1_par1,ch2_par1,nEnlargeFactor);
cv0_par1 = func_proposed_par_propogation(cv1_par1,cv2_par1,nEnlargeFactor);
cd0_par1 = func_proposed_par_propogation(cd1_par1,cd2_par1,nEnlargeFactor);

ch0_par2 = func_proposed_par_propogation(ch1_par2,ch2_par2,nEnlargeFactor);
cv0_par2 = func_proposed_par_propogation(cv1_par2,cv2_par2,nEnlargeFactor);
cd0_par2 = func_proposed_par_propogation(cd1_par2,cd2_par2,nEnlargeFactor);

ch0_par3 = func_proposed_par_propogation(ch1_par3,ch2_par3,nEnlargeFactor);
cv0_par3 = func_proposed_par_propogation(cv1_par3,cv2_par3,nEnlargeFactor);
cd0_par3 = func_proposed_par_propogation(cd1_par3,cd2_par3,nEnlargeFactor);

% Coefficient index extrapolation
ch0_mask = imresize(ch1_mask, size(ch1_mask)*nEnlargeFactor, 'nearest');
cv0_mask = imresize(cv1_mask, size(cv1_mask)*nEnlargeFactor, 'nearest');
cd0_mask = imresize(cd1_mask, size(cd1_mask)*nEnlargeFactor, 'nearest');

rand('state',sum(100*clock));
ch0_mask_change = rand(size(ch0_mask));
ch0_mask_change = (ch0_mask_change>=0.5);
ch0_mask = (ch0_mask==1).*(ch0_mask_change==1).*0 + (ch0_mask==1).*(ch0_mask_change==0).*1 ...
            + (ch0_mask==-1).*(ch0_mask_change==1).*0 + (ch0_mask==-1).*(ch0_mask_change==0).*-1 ...
            + (ch0_mask==0).*ch0_mask;

cv0_mask_change = rand(size(cv0_mask));
cv0_mask_change = (cv0_mask_change>=0.5);
cv0_mask = (cv0_mask==1).*(cv0_mask_change==1).*0 + (cv0_mask==1).*(cv0_mask_change==0).*1 ...
            + (cv0_mask==-1).*(cv0_mask_change==1).*0 + (cv0_mask==-1).*(cv0_mask_change==0).*-1 ...
            + (cv0_mask==0).*cv0_mask;

cd0_mask_change = rand(size(ch0_mask));
cd0_mask_change = (ch0_mask_change>=0.5);
cd0_mask = (cd0_mask==1).*(cd0_mask_change==1).*0 + (cd0_mask==1).*(cd0_mask_change==0).*1 ...
            + (cd0_mask==-1).*(cd0_mask_change==1).*0 + (cd0_mask==-1).*(cd0_mask_change==0).*-1 ...
            + (cd0_mask==0).*cd0_mask;

% Generate the highest subbands
result = zeros(size(img_in,1).*nEnlargeFactor, size(img_in,2).*nEnlargeFactor);  

for ii=1:nTotalIteration
    ch0 = func_proposed_gen_subband(ch0_par1, ch0_par2, ch0_par3, ch0_mask);
    cv0 = func_proposed_gen_subband(cv0_par1, cv0_par2, cv0_par3, cv0_mask);
    cd0 = func_proposed_gen_subband(cd0_par1, cd0_par2, cd0_par3, cd0_mask);
    temp = idwt2(img_in,ch0,cv0,cd0, Lo_R, Hi_R, 'mode', 'per');
    temp(temp<0) = 0;
    temp(temp>1) = 1;
    result = result + temp./nTotalIteration;
end

% Write the output image and perform PSNR evaluation
fprintf('The psnr is %.2f dB \n', func_psnr_gray(img_truth.*255, result.*255));
imwrite(uint8(result.*255), ['lena_rec.bmp'], 'bmp');

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function result = func_aco_thresholding_estimate_mask(wxin)

ant_search_range_row_min = ones(size(wxin));
ant_search_range_row_max = ones(size(wxin)).*size(wxin,1);
ant_search_range_col_min = ones(size(wxin));
ant_search_range_col_max = ones(size(wxin)).*size(wxin,2);

% System setup
ant_move_step_within_iteration = 15;
total_iteration_num = 10;
search_clique_mode = 8;  

wx = abs(wxin);
[nrow, ncol] = size(wx);
wx_1D = func_2D_LexicoOrder(wx);

% initialization
h = zeros(size(wx));
h_1D = func_2D_LexicoOrder(h);
p = 1./(wx.*(wx~=0)+1.*(wx==0)).*(wx~=0)+(wx==0);
p_1D = func_2D_LexicoOrder(p);

alpha = 1;      
beta = 2;       
rho = 0.1;      
w = 0.6;        
A = 5000;       
B = 10;         

%use one ant for each pixel position
ant_total_num = nrow*ncol;
ant_current_row = zeros(ant_total_num, 1); 
ant_current_col = zeros(ant_total_num, 1); 
ant_current_val = zeros(ant_total_num, 1); 
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

result = func_determine_class_fcm(wxin, p);

% ******************************************************************************
% **************************Inner Function *************************************
% ******************************************************************************

function idx = func_determine_class_fcm(wxin, p)
wx = abs(wxin);
p_1D = func_2D_LexicoOrder(p);
wx_1D = func_2D_LexicoOrder(wx);
[nrow, ncol] = size(wx);

nFeature(:,1) = p_1D(:)./(max2(p_1D));
nFeature(:,2) = wx_1D(:)./(max2(wx_1D));
[center,U,obj_fcn] = fcm(nFeature, 2,[2.0 100 1e-5 0]);

idx = zeros(nrow:ncol,1);    
if sum(sum(U(1,:) >= U(2,:))) >= sum(sum(U(1,:) < U(2,:)))
    idx = (U(1,:) < U(2,:));
else
    idx = (U(1,:) >= U(2,:));
end
idx = func_LexicoOrder_2D(idx, nrow, ncol);  
idx = double(idx);
idx((idx==1)&(wxin<0)) = -1;
idx((idx==1)&(wxin>=0)) = 1;
idx(idx==0) = 0;

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function result = func_LexicoOrder_2D(x, nRow, nColumn)
result = reshape(x, nColumn, nRow)';

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function result = func_2D_LexicoOrder(x)
[nRow, nColumn] = size(x);
temp = x';
result = temp(:);

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function result = func_psnr_gray(f, g)
f = double(f);
g = double(g);
Q=255;MSE=0;
[M,N]=size(f);
h = f - g;
MSE = sum(sum(h.*h));
MSE=MSE/M/N;
result=10*log10(Q*Q/MSE);

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function [result1, result2, result3] = func_proposed_three_state_estimation_aco_seg(I, I_mask, win_size)

thre = graythresh(abs(I));
[nrow, ncol] = size(I);
padnum = (win_size-1)/2;
A = padarray(I, [padnum padnum], 'replicate', 'bot');
B = padarray(I_mask, [padnum padnum], 'replicate', 'bot');
A = im2col(A, [win_size win_size],'sliding');
B = im2col(B, [win_size win_size],'sliding');

result1 = (sum(A.*(B==1),1).*(sum((B==1),1)~=0) + 0.*(sum((B==1),1)==0)) ./ (sum((B==1),1) + (sum((B==1),1)==0).*1);
result1 = reshape(result1, size(I));
result2 = (sum(A.*(B==-1),1).*(sum((B==-1),1)~=0) + 0.*(sum((B==-1),1)==0)) ./ (sum((B==-1),1) + (sum((B==-1),1)==0).*1);
result2 = reshape(result2, size(I));
result3 = (sum(A.*A.*(B==0),1).*(sum((B==0),1)~=0) + 0.*(sum((B==0),1)==0)) ./ (sum((B==0),1) + (sum((B==0),1)==0).*1);
result3 = reshape(result3, size(I));

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function ch0_var = func_proposed_par_propogation(ch1_var,ch2_var,nEnlargeFactor)

temp1 = imresize(ch1_var, size(ch1_var)*nEnlargeFactor, 'nearest').^2;
temp2 = imresize(ch2_var, size(ch2_var)*2*nEnlargeFactor, 'nearest');
ch0_var = ((temp2~=0).*temp1+(temp2==0).*0)./ ((temp2~=0).*temp2 + (temp2==0).*1);

% *************************************************************************
% **************************Inner Function ********************************
% *************************************************************************
function result = func_proposed_gen_subband(I_par1, I_par2, I_par3, I_mask)

rand('state',sum(100*clock));
result1 = exprnd(I_par1);
result2 = exprnd(I_par2);
result3 = randn(size(I_par3)).*sqrt(I_par3);
result1(isnan(result1))=0;
result2(isnan(result2))=0;
result3(isnan(result3))=0;
result = (I_mask==1).*result1 + (I_mask==-1).*result2 + (I_mask==0).*result3;
