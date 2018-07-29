%%% MultiSignal Wavelet Packet Decomposition %%%
% S: the original signals array to apply WP on
% h = the wavelet family
% J: decomposition levels
%%
% % (Kindly cite either of the following papers if you use this code)
% References:
% [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, “Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control”, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 – 357.
% [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, “Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm”, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.
% 
% Multiscale Wavelet Packet feature extraction code 
% By Dr. Rami Khushaba
% Research Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% Email: Rami.Khushaba@uts.edu.au
% URL: www.rami-khushaba.com (Matlab Code Section)
% Last modified 06/10/2011
%%

function D = mswpd(dirDec,S,h,J)
N = size(S,1);
if J > floor(log2(N))
  error('Too many levels.');
% elseif rem(N,2^(J-1))
%   error('Signal length must be a multiple of 2^%i.',J-1);
end
D{1,1} = S;
% For each level in the decomposition
% (starting with the second level).
for j = 1:J
  %width = N/2^(j-1);     % Width of elements on j'th level.
  index = 1;
  % For each pair of elements on the j'th level.
  for k = 1:2^(j-1)
   %Interval = [1+(k-1)*width:k*width];
   T = D{j,k};
   dec = mdwtdec(dirDec,T,1,h);
   D{j+1,index} = dec.ca; index = index+1;
   D{j+1,index} = dec.cd{1};index = index+1;
  end
end