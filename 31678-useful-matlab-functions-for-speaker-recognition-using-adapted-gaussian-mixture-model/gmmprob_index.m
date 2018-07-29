function index=gmmprob_index(mix,data,N)
% This code finds N-top Gaussians of UBM for a feature matrix.
% Written by Md. Sahidullah (Graduate Student, IIT Kharagpur)
% For any sort of queries or suggestions please mail to 
%                                                    sahidullahmd@gmail.com
%--------------------------------------------------------------------------
%Usage Input: 
%        : INDEX=gmmprob_index(mix,data,N)
%        : mix=Netlab GMM structure of UBM
%        : data=input data ( Txd matrix where d = mix.nin)
%        : N=No of Gaussian to be selected
%      Output:
%        : index: a TxN matrix of Gaussian indices
% Use this with Netlab toolbox
% http://www1.aston.ac.uk/eas/research/groups/ncrg/resources/netlab/
% If you have any query or suggestion please mail me sahidullahmd@gmail.com
b=mix.priors;
%-----------------Computation of Probability of all Gaussians--------------
a = gmmactiv(mix, data);
c=(a.*repmat(b,size(data,1),1))';
%----------------Sort Listing of Gaussians---------------------------------
[max_v max_p]=sort(c,'descend');
max_p=max_p';
%---------------Selction of Top-N modes------------------------------------
index=max_p(:,1:N);
%-----------------------End of Code----------------------------------------