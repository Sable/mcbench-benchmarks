function mix=gmmmap(mix,data,r)
%Function for creating adapted Gaussian mixture model with a specified
%relavace factor. This code adapts only the mean of UBM.
% This code is written by Md. Sahidullah 
%                         Graduate Student, Dept. of E & ECE IIT Kharagpur
% For any sort of queries or suggestions please mail to 
%                                                    sahidullahmd@gmail.com
% Usage: mix_target=gmmmap(mix_ubm,data,r)
%        mix_target:: target GMM (Adapted)
%        mix_ubm   :: UBM in NetLab format
%        data      :: Data of target
%        r         :: relevance factor 
% If dimension of feature is d and Number of Gaussian is M then the
% followings are different parameters of mix.
% mix.type='gmm';
% mix.covar_type='diag';
% mix.nin=d;
% mix.ncentres=M;
% mix.priors=an 1xM vector of wieghts in each elements.
% mix.covars=a  Mxd matrix of diagonal covariance matrix in each row.
% mix.centres=a Mxd matrix of diagonal covariance matrix in each row.
% mix.nwts= 2*M*d+M i.e. Total number of numerical elements in the mix.
% For Detail of Netlab toolbox:
% http://www1.aston.ac.uk/eas/research/groups/ncrg/resources/netlab/
% We have adapted only mean keeping in mind its application for 
% state-of-the art speaker recognition system.
input_dim=mix.nin;                %No of input i.e. Feature Dimension
[post, act] = gmmpost(mix, data); %Computes class posterior probabilities
prob = act*(mix.priors)';
new_pr = sum(post, 1);
alpha=new_pr./(new_pr+r);
new_c = post' * data;
mix.centres = repmat(alpha',1,input_dim).*(new_c ./ (new_pr' * ones(1, mix.nin)))...
    +(1-repmat(alpha',1,input_dim)).*mix.centres;
%---------------------END OF CODE------------------------------------------