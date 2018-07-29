function sos2csharp(H, filename)
%  sos2csharp(H, filename) saves C# code to make filter H in filename
%  sos2csharp(H) displays C# code to make filter H
%  sos2csharp displays C# code to make an example fourth order chebyshev filter
%
% converts a sos direct form II filter to c# code.
% Example: 
% H = design(fdesign.highpass('fst,fp,ast,ap',250, 300, 20, 3, 1000),'cheby1','MatchExactly', 'passband');
%  sos2csharp(H,'filter.cs')

if nargin == 0
    H = design(fdesign.highpass('fst,fp,ast,ap',250, 300, 20, 3, 1000),'cheby1','MatchExactly', 'passband');
end
if nargin == 1
    filename = 'filter.cs';
end

%%%%%%%%%%%%%%%%%%%% declare variables %%%%%%%%%%%%%%%%%%%%%%%%%
nStages = length(H.ScaleValues)-1;

%  declare and set constants
str = sprintf('namespace PutNamespaceHere\n{\n   public class IIRFilter\n   {\n      #region Fields\n');
str = sprintf('%s      double t, xi;\n',str);
for iStage=1:nStages
    str = sprintf('%s      double IC%g0 = 0, IC%g1 = 0;\n',str,iStage-1,iStage-1);
end
str = sprintf('%s      #endregion\n',str);

%%%%%%%%%%%%%%%%%%%% filter method %%%%%%%%%%%%%%%%%%%%%%%%%
str = sprintf('%s\n      #region Methods\n', str);
str = sprintf('%s      // requires output array y be already created by the calling function\n      public void Filter(double[] x, double[] y)\n      {\n',str);
str = sprintf('%s         int N = x.Length;\n',str);
str = sprintf('%s         for (int i=0; i<N; i++)\n         {\n',str);
str = sprintf('%s            xi = x[i];\n',str);
for iStage = 1:nStages  
    g = GetGain(H,iStage);
    a1 = GetA1(H,iStage);
    a2 = GetA2(H,iStage);
    b0 = GetB0(H,iStage);
    b1 = GetB1(H,iStage);
    b2 = GetB2(H,iStage);
    str = sprintf('%s            // Stage %g\n',str, iStage-1);   
    if g~=1 && a1~=0
        str = sprintf('%s            t = (%0.20g * xi) - (%0.20g * IC%g0) - (%0.20g * IC%g1);\n',str,g,a1,iStage-1,a2,iStage-1);
    elseif g==1 && a1~=0
        str = sprintf('%s            t = xi - (%0.20g * IC%g0) - (%0.20g * IC%g1);\n',str,a1,iStage-1,a2,iStage-1);
    elseif g~=1 && a1==0
        str = sprintf('%s            t = (%0.20g * xi) - (%0.20g * IC%g1);\n',str,g,a2,iStage-1);
    else % g==1 && a1==0
        str = sprintf('%s            t = xi - (%0.20g * IC%g1);\n',str,a2,iStage-1);
    end
    if b0==1 && b1==2 && b2 == 1
        str = sprintf('%s            xi = t + (IC%g0) + (IC%g0) + (IC%g1);\n',str,iStage-1,iStage-1,iStage-1);
    elseif b0==1 && b1==-2 && b2 == 1
        str = sprintf('%s            xi = t - (IC%g0) - (IC%g0) + (IC%g1);\n',str,iStage-1,iStage-1,iStage-1);
    elseif b0==1 && b1==1 && b2==1
        str = sprintf('%s            xi = t + (IC%g0) + (IC%g1);\n',str,iStage-1,iStage-1);
    else
        str = sprintf('%s            xi = (%0.20g * t) + (%0.20g * IC%g0) + (%0.20g * IC%g1);\n',str,b0,b1,iStage-1,b2,iStage-1);
    end
    str = sprintf('%s            IC%g1 = IC%g0;\n',str, iStage-1, iStage-1);
    str = sprintf('%s            IC%g0 = t;\n',str, iStage-1);
    if (iStage == nStages)
        g = GetGain(H,iStage+1);
        if g==1
            str = sprintf('%s            y[i] = xi;\n',str);
        else
        	str = sprintf('%s            y[i] = %0.20g * xi;\n',str, g);
        end
    end
end
str = sprintf('%s         }\n      }\n',str);
str = sprintf('%s      #endregion\n   }\n}\n',str);


if nargin < 2
    disp(str)
else
    fid = fopen(filename,'wt');
    fwrite(fid,str);
    fclose(fid);
    disp(['file ' filename ' written.'])
end



% %%%%%%%%%%%%%%%%%%%% process stage 1 %%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:length(x)
%     xi = x(i);
%     
%     % stage 0
%     t = xi*g0 - a01*IC00 - a02*IC01;
%     if b00==1 && b01==2 && b02==1
%         xi = t + IC00 + IC00 + IC01;
%     elseif b00==1 && b01==-2 && b02==1
%         xi = t - IC00 - IC00 + IC01;
%     else
%         xi = t*b00+ b01*IC00 + b02*IC01;
%     end
%     IC01 = IC00;
%     IC00 = t;
%     
%     % stage 1
%     t = xi*g1 - a11*IC10 - a12*IC11;
%     if b10==1 && b11==2 && b12==1
%         xi = t + IC10 + IC10 + IC11;
%     elseif b10==1 && b11==-2 && b12==1
%         xi = t - IC10 - IC10 + IC11;
%     else
%         xi = t*b10+ b11*IC10 + b12*IC11;
%     end
%     IC11 = IC10;
%     IC10 = t;
%     
%     y(i) = xi;
% end
% y = y*g2;
% 

function scale = GetGain(H,iStage)
scale = H.ScaleValues;
scale = scale(iStage);
if abs(scale-1)<1e-13
    scale = 1;
end

function a1 = GetA1(H,iStage)
s = H.sosMatrix;
a1 = s(iStage, 5);
if abs(a1)<1e-13
    a1 = 0;
end

function a2 = GetA2(H, iStage)
s = H.sosMatrix;
a2 = s(iStage, 6);

function b0 = GetB0(H,iStage)
s = H.sosMatrix;
b0 = s(iStage, 1);
if abs(b0-1)<1e-13
    b0 = 1;
end

function b1 = GetB1(H,iStage)
s = H.sosMatrix;
b1 = s(iStage, 2);
if abs(abs(b1)-2)<1e-13
    b1 = round(b1);
end

function b2 = GetB2(H,iStage)
s = H.sosMatrix;
b2 = s(iStage, 3);
if abs(b2-1)<1e-13
    b2 = 1;
end



