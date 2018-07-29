%% Implementation of Progressive Switching Median Filter
%% Base Paper : Zhou Wang and David Zhang, "Progressive Switching Median
%% Filter for the Removal of Impulse Noise from Highly Corrupted Images", 
%% IEEE Trans. on Cir. and Sys., vol. 46, no. 1, Jan. 1999.
%% Function Y = PSMF(x)
%% input    x = Image is corrupted by Salt & Pepper Noise
%%          
%%  Example: Y = PSMF(x);
%%      Posted date   : 16 - 10 - 2008
%%      Modified date : 
%%                  
%% Developed By : K.Kannan (kannan.keizer@gmail.com) 
%%                & Jeny Rajan (jenyrajan@gmail.com)
%%                  Medical Imaging Research Group (MIRG), NeST,
%%                  Trivandrum.
%% Progressive Switching Median Filter
function Y = PSMF(x)
x = double(x);
WF = 3; ND = 3;T = 40;a = 65;b = -50;
M = medfilt2(x,[3 3]);
N = abs(x - M);
N(N>T)=0;
N = N ~= 0;
N = double(N);
R = sum(N(:))/(size(x,1) * size(x,2));
if R <= 0.25
    WD = 3;
else
    WD = 5;
end
TD = a + (b * R);
z = IMPDET(x,ND,WD,TD);
Y = NF(x,z,WF);

%% Impulse Detection
function F1 = IMPDET(x,ND,WD,TD)
X = x;
M = medfilt2(X,[WD WD]);
D = abs(X - M);
F = zeros(size(x));
F(D>=TD)=1;
F1 = F;
X(F1==F)=X(F1==F);
X(F1~=F)=M(F1~=F);
for i = 1:ND-1
    M = medfilt2(X,[WD WD]);
    F1(abs(X - M)<TD)=F(abs(X - M)<TD);
    F1((X - M)>=TD)=1;
    X(F1==F)=X(F1==F);
    X(F1~=F)=M(F1~=F);
    F = F1;
end
return;

%% Noise Filtering
function Y = NF(x,f,WF)
g = f;
Y = x;
Y1 = Y;
g1 = g;
s = sum(g(:));
while s ~= 0
    M = medfilt2(Y,[WF WF]);
    Y1(g==1)=M(g==1);
    g1(Y~=Y1)=0;
    Y = Y1;
    g = g1;
    s1 = sum(g(:));
    if s1 ~= s
        s = s1;
    else
        s = 0;
    end
end
return;
