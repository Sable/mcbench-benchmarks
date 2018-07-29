function Show_Curvelets_boundaries(f,Bw,Bt,option)

%=======================================================================
% function Show_Curvelets_boundaries(f,Bw,Bt)
% 
% This function plots the angular sectors corresponding to the 
% detected scales and angles in the 2D spectrum.
%
% Inputs:
%   -f: input image
%   -Bw: list of Fourier boundaries (in [0,pi])
%   -Bt: list of angles (in radian)
%   -option: 1=EWTC-I;2=EWTC-II (must be the same as the one used in the
%            transform)
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=======================================================================
ff=log(1+fftshift(abs(fft2(f))));
figure;imshow(ff,[]);
hold on;

color='white';
wid = 1;

po=floor(size(f)/2);
[r,c]=size(f);

if option==1  %Option 1
    % We plot the scale annuli
    for n=1:length(Bw)
        a=Bw(n)*floor(size(f,2)/(2*pi));
        b=Bw(n)*floor(size(f,1)/(2*pi));
        drawEllipse(floor(size(f,2)/2)+1,floor(size(f,1)/2)+1,a,b,color);
    end
    % We plot the angles limits
    for n=1:length(Bt)
        if abs(Bt(n))<=pi/4
            hold on
            p0 = po.*(1 + Bw(1)*[cos(Bt(n)) sin(Bt(n))]/pi);
            p1 = [c floor((r+c*tan(Bt(n)))/2)+1];
            plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
            p0 = po.*(1 - Bw(1)*[cos(Bt(n)) sin(Bt(n))]/pi);
            p2 = [1 floor((r-c*tan(Bt(n)))/2)+1];
            plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);           
        else
            hold on
            p0 = po.*(1 - Bw(1)*[cos(Bt(n)) sin(Bt(n))]/pi);
            p1 = [floor((c+r*cot(Bt(n)))/2)+1 r];
            plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
            p0 = po.*(1 + Bw(1)*[cos(Bt(n)) sin(Bt(n))]/pi);
            p2 = [floor((c-r*cot(Bt(n)))/2)+1 1];
            plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);   
        end
    end
elseif option==2
    % We plot the scale annuli
    for n=1:length(Bw)
        a=Bw(n)*floor(size(f,2)/(2*pi));
        b=Bw(n)*floor(size(f,1)/(2*pi));
        drawEllipse(floor(size(f,2)/2)+1,floor(size(f,1)/2)+1,a,b,color);
    end
    % We plot the angles limits
    for s=1:length(Bw)-1
        for n=1:length(Bt{s})
            if abs(Bt{s}(n))<=pi/4
                hold on
                p0 = po + Bw(s)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))];
                p1 = po + Bw(s+1)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))];
                plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
                p0 = po - Bw(s)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                p2 = po - Bw(s+1)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);           
            else
                hold on
                p0 = po - Bw(s)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                p1 = po - Bw(s+1)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
                p0 = po + Bw(s)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                p2 = po + Bw(s+1)*floor(size(f,2)/(2*pi))*[cos(Bt{s}(n)) sin(Bt{s}(n))]+1;
                plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);   
            end
        end
    end
    for n=1:length(Bt{end})
        if abs(Bt{end}(n))<=pi/4
            hold on
            p0 = po + Bw(end)*floor(size(f,2)/(2*pi))*[cos(Bt{end}(n)) sin(Bt{end}(n))];
            p1 = [c floor((r+c*tan(Bt{end}(n)))/2)+1];
            plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
            p0 = po - Bw(end)*floor(size(f,2)/(2*pi))*[cos(Bt{end}(n)) sin(Bt{end}(n))];
            p2 = [1 floor((r-c*tan(Bt{end}(n)))/2)+1];
            plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);           
        else
            hold on
            p0 = po - Bw(end)*floor(size(f,2)/(2*pi))*[cos(Bt{end}(n)) sin(Bt{end}(n))];
            p1 = [floor((c+r*cot(Bt{end}(n)))/2)+1 r];
            plot([p1(1),p0(1)],[p1(2),p0(2)],'Color',color,'LineWidth',wid);   
            p0 = po + Bw(end)*floor(size(f,2)/(2*pi))*[cos(Bt{end}(n)) sin(Bt{end}(n))];
            p2 = [floor((c-r*cot(Bt{end}(n)))/2)+1 1];
            plot([p2(1),p0(1)],[p2(2),p0(2)],'Color',color,'LineWidth',wid);   
        end
    end
end