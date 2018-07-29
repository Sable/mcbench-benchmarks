function temp_obj_eval = my_compute_precision_recall_fmeasure(u, u0_GT, u0_SKL_GT)
% 121227: Reza FARRAHI MOGHADDAM and Hossein ZIAEI NAFCHI
% 090519: Reza FARRAHI MOGHADDAM
% used in objective_evaluation_core.m

%
[xm ym] = size(u);
% figure, imshow(u)

%
if (numel(u0_GT) == 0)
    u0_GT = NaN * ones([xm ym]);
end

%
if (nargin == 2)
    % u0_SKL_GT = NaN * ones([xm ym]);
	u0_SKL_GT = ~bwmorph(~u0_GT, 'thin', 'inf');
end

    
% TP pixels
temp_tp = [u == 0] & [u0_GT == 0];

% FP pixels
temp_fp = [u == 0] & [u0_GT ~= 0];

% FN pixels
temp_fn = [u ~= 0] & [u0_GT == 0];

% TN pixels 
temp_tn = [u ~= 0] & [u0_GT ~= 0];

% SKL TP / FN pixels
temp_skl_tp = [u == 0] & [u0_SKL_GT == 0];
temp_skl_fp = [u == 0] & [u0_SKL_GT ~= 0];
temp_skl_fn = [u ~= 0] & [u0_SKL_GT == 0];
temp_skl_tn = [u ~= 0] & [u0_SKL_GT ~= 0];

% counts
count_tp = sum(sum(temp_tp));
count_fp = sum(sum(temp_fp));
count_fn = sum(sum(temp_fn));
count_tn = sum(sum(temp_tn));
count_skl_tp = sum(sum(temp_skl_tp));
count_skl_fp = sum(sum(temp_skl_fp));
count_skl_fn = sum(sum(temp_skl_fn));
count_skl_tn = sum(sum(temp_skl_tn));

% precision
temp_p = count_tp / (count_fp + count_tp);

% recall
temp_r = count_tp / (count_fn + count_tp);
if (temp_r == 0)
    temp_r = NaN;
end

% p-recall
temp_pseudo_p = count_skl_tp / (count_skl_fp + count_skl_tp);
temp_pseudo_r = count_skl_tp / (count_skl_fn + count_skl_tp);
if (temp_pseudo_r == 0)
    temp_pseudo_r = NaN;
end

% f-measure
temp_f = 100 * 2 * (temp_p * temp_r) / (temp_p + temp_r);

% p-f-measure
temp_pseudo_f = 100 * 2 * (temp_p * temp_pseudo_r) / (temp_p + temp_pseudo_r);

% sensetivity
temp_sens = count_tp / (count_tp + count_fn);
if (temp_sens == 0)
    temp_sens = NaN;
end

% specificity
temp_spec = count_tn / (count_tn + count_fp);
if (temp_spec == 0)
    temp_spec = NaN;
end

% BCR: Balanced Classification Rate 
temp_BCR = 0.5 * (temp_sens + temp_spec);

% AUC: Area Under the Curve
temp_AUC = 0.5 * (temp_sens + temp_spec);

% BER: Balanced Error Rate
temp_BER = 100 * (1 - temp_BCR);

% S-F-measure: harmonic mean of sensetivity and specificity
temp_s_f_measure = 100 * 2 * (temp_sens * temp_spec) / (temp_sens + temp_spec);

% Accuracy: mean of sensetivity and specificity
temp_accu = (count_tp + count_tn) / (count_tp + count_tn + count_fp + count_fn);

% gAccuracy: Geometric mean of sensetivity and specificity
temp_g_accu = sqrt(temp_sens * temp_spec);

% NRM (Negative Rate Metric) (*10^-2)
NR_FN = count_fn / (count_fn + count_tp);
NR_FP = count_fp / (count_fp + count_tn);
temp_NRM = (NR_FN + NR_FP) / 2;

% PSNR
err=sum(sum(temp_fp | temp_fn)) / (xm * ym);
temp_PSNR = 10 * log10( 1 / err);

% DRD: Distance Reciprocal Distortion Metric
blkSize=8; % even number
MaskSize=5; % odd number
u0_GT1 = false(xm + 2, ym + 2);
u0_GT1(2 : xm + 1, 2 : ym + 1) = u0_GT;
intim = cumsum(cumsum(u0_GT1, 1), 2);
NUBN = 0; blkSizeSQR = blkSize ^ 2;
for i= 2 : blkSize : (xm - blkSize + 1)
    for j = 2 : blkSize : (ym - blkSize + 1)
        blkSum=intim(i + blkSize - 1, j + blkSize - 1) - intim(i - 1, j + blkSize - 1) - intim(i + blkSize - 1, j - 1) + intim(i - 1, j - 1);
        if blkSum == 0 || blkSum == blkSizeSQR
        else
            NUBN = NUBN + 1;
        end
    end
end

wm = zeros(MaskSize, MaskSize);
ic = (MaskSize + 1) / 2; jc = ic; % center coordinate
for i = 1 : MaskSize
    for j = 1 : MaskSize
        wm(i, j) = 1 / (sqrt((i - ic) .^ 2 + (j - jc) .^ 2));
    end
end
wm(ic, jc) = 0;
wnm = wm ./ (sum(wm(:))); % Normalized weight matrix

u0_GT_Resized = zeros(xm + ic + 1, ym + jc + 1);
u0_GT_Resized(ic : xm + ic - 1, jc : ym + jc - 1) = u0_GT;
u_Resized = zeros(xm + ic + 1, ym + jc + 1);
u_Resized(ic : xm + ic - 1, jc : ym + jc - 1) = u;
temp_fp_Resized = [u_Resized == 0] & [u0_GT_Resized ~= 0];
temp_fn_Resized = [u_Resized ~= 0] & [u0_GT_Resized == 0];
Diff = temp_fp_Resized | temp_fn_Resized;
[xm2 ym2] = size(Diff);
SumDRDk = 0;
for i = ic : xm2 - ic + 1
    for j = jc : ym2 - jc + 1
        if Diff(i, j) == 1
            Local_Diff = my_xor_infile(u0_GT_Resized(i - ic + 1 : i + ic -1 , j - ic + 1 : j + ic - 1), u_Resized(i, j));
            DRDk = sum(sum(Local_Diff.* wnm));
            SumDRDk = SumDRDk + DRDk;
        end
    end
end
temp_DRD = SumDRDk / NUBN;

% MPM: Misclassification penalty metric
Contour = bwmorph(~u0_GT, 'remove');
Dist = bwdist(Contour, 'Chessboard');
D = sum(Dist(:));
MP_FN = sum(Dist(temp_fn)) / D;
MP_FP = sum(Dist(temp_fp)) / D;
temp_MPM = (MP_FN + MP_FP) / 2;

% output
%
temp_obj_eval.Precision = temp_p;
temp_obj_eval.Recall = temp_r;
temp_obj_eval.Fmeasure = temp_f;
temp_obj_eval.P_Precision = temp_pseudo_p;
temp_obj_eval.P_Recall = temp_pseudo_r;
temp_obj_eval.P_Fmeasure = temp_pseudo_f;
temp_obj_eval.Sensitivity = temp_sens;
temp_obj_eval.Specificity = temp_spec;
temp_obj_eval.BCR = temp_BCR;
temp_obj_eval.AUC = temp_AUC;
temp_obj_eval.BER = temp_BER;
temp_obj_eval.SFmeasure = temp_s_f_measure;
temp_obj_eval.Accuracy = temp_accu;
temp_obj_eval.GAccuracy = temp_g_accu;
temp_obj_eval.NRM = temp_NRM;
temp_obj_eval.PSNR = temp_PSNR;
temp_obj_eval.DRD = temp_DRD;
temp_obj_eval.MPM = temp_MPM;

end

function temp_xor_infile = my_xor_infile(u_infile, u0_GT_infile)
% Reza

temp_fp_infile = [u_infile == 0] & [u0_GT_infile ~= 0];
temp_fn_infile = [u_infile ~= 0] & [u0_GT_infile == 0];
temp_xor_infile = temp_fp_infile | temp_fn_infile; 

end