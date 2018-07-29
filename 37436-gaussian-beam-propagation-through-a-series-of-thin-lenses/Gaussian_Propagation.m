function Gaussian_Propagation(lambda,beam_waist,wp,fpos,f,show_flag)
% propagates a Gaussian beam through a series of lenses.
% Input:
%   lambda         beam's wavelength
%   beam_waist     waist of the beam at the waist positions (wp)
%   wp             waist position
%   fpos           lenses positions vector [pos1, pos2, pos3 ...]
%   f              lenses focal-lengths vector [f1, f2, f3 ...]
%   show_flag      prints text on figure with waist positions and sizes
%
%   All units are metric.
%
% Example:
%           Gaussian_Propagation(8e-7,0.00075,-0.1,[0 0.1],[-0.5 0.2])
%
%   Comments \ improvements are welcomed
%   nate2718281828@gmail.com
%   Ver 1.1
%   Date: 12/1/2012.

%% defaults - x2 beam expander for HeNe laser
if (nargin < 6); show_flag=false; end
if (nargin < 5); f=[-0.125 0.25]; end
if (nargin < 4); fpos=[0 0.125]; end
if (nargin < 3);  wp=-0.25; end
if (nargin < 2); beam_waist=1e-2; end
if (nargin < 1); lambda=632.8e-9; end

%% calculate the waist_pos(i) and w(i) between all of the lenses
w(1)=beam_waist;              % initial beam waist
waist_pos(1)=wp;              % initial beam waist position

for i=1:length(f)       % loop over all of the lenses vector
    % calculate the new waist position relative to current lens position
    waist_distance_from_next_lens=fpos(i)-waist_pos(i);
    [new_w, new_rel_s] = Gaussian_focusing(lambda,w(i),waist_distance_from_next_lens,f(i));
    w(i+1)=new_w;
    % calculate the absolute position of the new waist
    waist_pos(i+1)=fpos(i)+new_rel_s;
end

fpos=[waist_pos(1) fpos];
%generate propagation axis z, w(z) vector and plot it:
z(1)=waist_pos(1);
Wz(1)=w(1);
for i=1:length(fpos)-1      % cycle through all lenses
    ztemp=linspace(fpos(i),fpos(i+1));      % just a 100 points propagation ztemp vector, can be modified to ztemp=linspace(fpos(i),fpos(i+1),num_of_points_desired);
    Wz=[Wz w(i)*sqrt(1+((ztemp-waist_pos(i))/(pi*w(i)^2/lambda)).^2)];   % gaussian beam propagation
    z=[z ztemp];
end

if fpos(end)+2*abs(f(end))>waist_pos(end)
    ztemp=linspace(fpos(end),fpos(end)+2*abs(f(end)));   % propagate 2*f of the last lens - Change if needed to see larger propagation distances
else
    ztemp=linspace(fpos(end),waist_pos(end)+2*abs(f(end)));   % propagate 2*f of the last beam waist - Change if needed to see larger propagation distances
end

Wz=[Wz w(end)*sqrt(1+((ztemp-waist_pos(end))/(pi*w(end)^2/lambda)).^2)];
z=[z ztemp];

%% beam plots:
figure(1)
plot(z,Wz,'r',z,-Wz,'r');        % plot the gaussian beam
hold on;
xlabel('z(m)'); ylabel('y(m)');

% lenses plot:
xline=kron(fpos(2:end),[1 1]');
yline=2*kron(max(abs(Wz))*ones(length(fpos)-1,1)',[0.95 -0.95]');
plot(xline,yline,'b:')
legend('beam waist (+)','beam waist (-)','thin lens');
ZL=waist_pos(end);

% text anotations:
text(fpos(2:end),1.05*yline(1,:),strcat('f= ',num2str(f')));    % prints the focal length of each lens
text(fpos(2:end),-1.05*yline(1,:),strcat('Z_f= ',num2str(fpos(2:end)')));    % prints the focal length of each lens

if show_flag
% plots the waist location and size at different heights
ymax=max(yline(:));
text(waist_pos,w-0.05*ymax,strcat('W_{',num2str((1:length(waist_pos))'),'}=',num2str(w','%0.3d')),'FontSize',8);
text(waist_pos,w+0.05*ymax,strcat('Z=',num2str(waist_pos','%0.4g')),'FontSize',8);
end


hold off
%waist_pos
%w
fprintf(1,strcat('waist position from last lens: ',num2str(waist_pos(end)-fpos(end)),'\n'))
fprintf(1,strcat('waist size: ',num2str(w(end)),'\n'))

function [w_new,s_new]=Gaussian_focusing(lambda,w_old,s_old,f)
% Gaussian beam focusing by a thin lens (Based on Self's paper, see [1])
% Inputs: lambda=wavelength;
%         w_old = waist before the lens;
%         s_old = distance of waist before lens (s>0 before lens)
%         f = focal length of lens (f>0 for converging lens)
% Output: w_new = new waist;
%         s_new = position of waist from lens
% [1] http://www.mellesgriot.com/products/optics/gb_2_3.htm
zR=pi*w_old^2/lambda;    % original rayleigh range
s_new = f.*(1+(s_old./f-1)./((s_old./f-1).^2+(zR./f).^2));  % new waist location (Eq. (9b))
w_new = w_old./sqrt((1-s_old./f).^2+(zR./f).^2);