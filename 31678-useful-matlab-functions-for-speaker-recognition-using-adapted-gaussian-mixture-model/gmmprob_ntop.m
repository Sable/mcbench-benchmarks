function prob=gmmprob_ntop(mix,INDEX,data)
% This code computes probability of feature vector for particular Gaussians
% of GMM. The Gaussians are chosen according to the index provided.
% Written by Md. Sahidullah (Graduate Student, IIT Kharagpur)
% For any sort of queries or suggestions please mail to 
%                                                    sahidullahmd@gmail.com
% Usage:
% Input: mix  : Netlab structure of GMM
%        INDEX: Index of the Gaussians per frame (a TxN Matrix) (T: No of
%        frame, N: Number of Gaussians)
%        data: feature vector (a Txd matrix where d=dimension i.e. mix.nin
% Output:
%        prob: Probability (mean Log Likelihood of Test data)
% Use this code with Netlab toolbox
% http://www1.aston.ac.uk/eas/research/groups/ncrg/resources/netlab/
% If you have any query or suggestion please mail me sahidullahmd@gmail.com
%----------------Intializing the matrix------------------------------------
N = size(INDEX,2);
a = zeros(size(data, 1), N); 
%----------------Computation of Probability--------------------------------
normal = (2*pi)^(mix.nin/2);
s = prod(sqrt(mix.covars), 2);
for j = 1:N %for N Gaussians
    covs = s(INDEX(:,j));
    MCENTRES=mix.centres(INDEX(:,j), :);
    MCOVARS=mix.covars(INDEX(:,j), :);
    diffs = (data - MCENTRES).^2;
    a(:, j) = exp(-0.5*sum(diffs./MCOVARS, 2)) ./ (normal*covs);
end
prob=a .* (mix.priors(INDEX));
prob = mean(log(sum(prob,2)));
%------------------End of Code---------------------------------------------