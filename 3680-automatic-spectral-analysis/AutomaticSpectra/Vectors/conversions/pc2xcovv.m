function [xcov, xcovlr] = pc2xcovv(pc,R0,a,b,ncov)

%function [xcov, xcovlr] = pc2xcovv((pc,R0,a,b,ncov)
% Transforms partial correlations pc into a x-covariance function
% betweenbetween the scalar signals
% a[n] = a*x[n] and
% b[n] = b*x[n].
%
% ncov is the number of covariances.
% xcov yields the xcov between shifts zero and ncov;
% xcovlr yields the xcov between -ncov and +ncov.

% S.de Waele, March 2003.

cov = pc2covv(pc,R0,ncov);

%Efficient calculation of xcov[r] = a*cov[r]*b'

%for positive shifts r
covT = permute(cov,[2 1 3]);
bcovT= timesv(b,covT); %        bcovT[r] = b*cov[r]'
covbT= permute(bcovT,[2 1 3]); % covbT= cov*b'
xcov = mat2sig(timesv(a,covbT));

%and for negative shifts r
covl = transposeLTI(cov);
covlT = permute(covl,[2 1 3]);
bcovlT= timesv(b,covlT); %        bcovlT[r] = b*covl[r]'
covlbT= permute(bcovlT,[2 1 3]); % covlbT= covl*b'
xcovl = mat2sig(timesv(a,covlbT));

xcovlr = [xcovl(1:end-1); xcov];
