%% Add Impulse Noise to images
%% Impulse Noises 0 - Salt & Pepper noise
%                 1 - Random Valued impulse noise.
%% impulse noises are classified into two major types 
% (i)  salt and pepper noise (equal height impulses) impulse values are
%       represented as 0 and 255
% (ii) random-valued impulse noise (unequal height impulses) impulse values
%      are between 0 and 255. 

%% Function img = impulsenoise(img,ND)
%% input    
%           img = Given an Image (Noise free image)
%           ND  = Noise density (ND varies B/W 0 and 1) [0 to 1]
%           NT  = Noise Type([0] is default)
%                 0 - Salt & Pepper noise
%                 1 - Random-Valued Impulse noise
%% Output:
%           img = impulse noise added image

%% Example: 
%%          img = impulsenoise(img,0.4,0);

%%      Posted date   : 18 - 11 - 2008
%       Modified date : 02 - 12 - 2008
                  
%% Developed By 
%                   K.Kannan (kannan.keizer@gmail.com) 
%                   & Jeny Rajan (jenyrajan@gmail.com)
%                   Medical Imaging Research Group (MIRG), NeST,
%                   Trivandrum.
%% 
function img = impulsenoise(varargin)
if length(varargin) == 1
    img = varargin{1};
    ND = 0.2;
    NT = 0;
elseif length(varargin) > 1 && length(varargin) < 3
    img = varargin{1};
    ND = varargin{2};
    NT = 0;
elseif length(varargin) == 3
    img = varargin{1};
    ND = varargin{2};
    NT = varargin{3};
else
    disp('not enough input parameter');
    img = 0;
    return;
end    
Narr = rand(size(img));
if isempty(NT) || NT == 0
    img(Narr<ND/2) = 0;
    img((Narr>=ND/2)&(Narr<ND)) = 255;
elseif NT == 1
    N = Narr;
    N(N>=ND)=0;
    N1 = N;
    N1 = N1(N1>0);
    Imn=min(N1(:));
    Imx=max(N1(:));
    N=(((N-Imn).*(255-0))./(Imx-Imn));
    img(Narr<ND) = N(Narr<ND);
else
    disp('Invalid selection');
end