function [dX]= WMR_TRAJTRACK(t,X,L1,L2)

global b d mc mw Ic Iw Im r%L1 L2%a %WMR paramters
global xe ye rx ry ell_an start_an w % Trajectory information
global Kp1 Kp2 Kd1 Kd2

% t
%% CURRENT STATE INFORMATION
x_C= X(1);
y_C= X(2);
phi= X(3);
% th_R= X(4); % Not required since wheels are shown as stationary
% th_L= X(5);
thd_R= X(6);
thd_L= X(7);

c= r/(2*b);
S= [  c*(b*cos(phi)-d*sin(phi)),   c*(b*cos(phi)+d*sin(phi));
    c*(b*sin(phi) + d*cos(phi)), c*(b*sin(phi) - d*cos(phi));
                              c,                          -c;
                              1,                           0;
                              0,                           1];

Nu= [thd_R,thd_L]'; % Minimal coordinates

Q_dot = S*Nu; % Extended coordinates
xd_C= Q_dot(1);
yd_C=Q_dot(2);
om= Q_dot(3); % Phi_dot=omega

Sd = [ c*om*(-b*sin(phi)-d*cos(phi)), c*om*(-b*sin(phi)+d*cos(phi));
      c*om*(b*cos(phi) - d*sin(phi)),c*om*(b*cos(phi) + d*sin(phi));
                                   0,                             0;
                                   0,                             0;
                                   0,                             0];

TR_C2O=[cos(phi), -sin(phi);
        sin(phi),  cos(phi)]; % Transformation matrix from WMR to Global Ref
%% ELLIPSE INFORMATION : DESIRED OUTPUTS

x_E=xe+rx*cos(w*t + start_an)*cos(ell_an) + ry*sin(w*t + start_an)*(-sin(ell_an)); % Initial X on ellipse
y_E=ye+rx*cos(w*t + start_an)*sin(ell_an) + ry*sin(w*t + start_an)*(cos(ell_an)); % Initial Y on ellipse

xd_E= w*( -rx*sin(w*t + start_an)*cos(ell_an) + ry*cos(w*t + start_an)*(-sin(ell_an)) ); % Initial X-vel on ellipse
yd_E= w*( -rx*sin(w*t + start_an)*sin(ell_an) + ry*cos(w*t + start_an)*(cos(ell_an)) ); % Initial Y-vel on ellipse

xdd_E= w*w*( -rx*cos(w*t + start_an)*cos(ell_an) - ry*sin(w*t + start_an)*(-sin(ell_an)) ); % Initial X-acc on ellipse
ydd_E= w*w*( -rx*cos(w*t + start_an)*sin(ell_an) - ry*sin(w*t + start_an)*(cos(ell_an)) ); % Initial Y-acc on ellipse

%% ERROR MODELING
X_L_O= TR_C2O*[L1;L2]+[x_C;y_C]; % Position of Look Ahead point in {O} frame= Xco + Xlc
x_L=X_L_O(1);
y_L=X_L_O(2);

Xd_C_O= [xd_C,yd_C]'; % Velocity of Look Ahead point in {O} frame
Xd_L_C= (om*[L1,L2]*[0,1;-1,0]*TR_C2O')';
Xd_L_O= Xd_C_O + Xd_L_C;
xd_L=Xd_L_O(1);
yd_L=Xd_L_O(2);

xdd_L = xdd_E - Kp1*(x_L - x_E) - Kd1*(xd_L - xd_E); % X-Acc of Look Ahead point
ydd_L = ydd_E - Kp2*(y_L - y_E) - Kd2*(yd_L - yd_E); % Y-Acc of Look Ahead point

%% INPUT MODELING
p11= c*((b-L2)*cos(phi) - (d+L1)*sin(phi));
p12= c*((b+L2)*cos(phi) + (d+L1)*sin(phi));
p21= c*((b-L2)*sin(phi) + (d+L1)*cos(phi));
p22= c*((b+L2)*sin(phi) - (d+L1)*cos(phi));
P=[p11,p12;
   p21,p22];

pd11= c*(Nu(1) - Nu(2))*c*(-(b-L2)*sin(phi) - (d+L1)*cos(phi));
pd12= c*(Nu(1) - Nu(2))*c*(-(b+L2)*sin(phi) + (d+L1)*cos(phi));
pd21= c*(Nu(1) - Nu(2))*c*( (b-L2)*cos(phi) - (d+L1)*sin(phi));
pd22= c*(Nu(1) - Nu(2))*c*( (b+L2)*cos(phi) + (d+L1)*sin(phi));
Pd= [pd11,pd12;
     pd21,pd22];

v=[xdd_L, ydd_L]'; 
u = inv(P)*(v - Pd*Nu);

%% Dynamic Modeling
m= mc+ 2*mw;
I = Ic + 2*mw*(d^2 + b^2) + 2*Im;

M = [m, 0, 2*mw*d*sin(phi), 0 , 0;
    0, m, -2*mw*d*cos(phi), 0, 0;
    2*mw*d*sin(phi), -2*mw*d*cos(phi), I, 0, 0;
    0, 0, 0, Iw, 0;
    0, 0, 0, 0, Iw];
    
V = [2*mw*d*(om^2)*cos(phi);
    2*mw*d*(om^2)*sin(phi);
    0;
    0;
    0];

E = [0, 0;
     0, 0;
     0, 0;
     1, 0;
     0, 1];

f2= inv(S'*M*S)*(-S'*M*Sd*Nu - S'*V);
Tau= pinv(inv(S'*M*S)*S'*E)*(u-f2);
dX = [S*Nu; f2] + [zeros(5,2); inv(S'*M*S)*S'*E]*Tau;