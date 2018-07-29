% Blood Glucose Model
%
% References
% S. M. Lynch and B. W. Bequette, Estimation based Model Predictive Control
%   of Blood Glucose in Type I Diabetes: A Simulation Study, Proc. 27th IEEE
%   Northeast Bioengineering Conference, IEEE, 2001.
%
% and
% 
% S. M. Lynch and B. W. Bequette, Model Predictive Control of Blood Glucose in 
%   type I Diabetics using Subcutaneous Glucose Measurements, Proc. ACC, Anchorage,
%   AK, 2002.

function xdot = blood_glucose(t,x)

global u A

% Input (1)
% Insulin infusion rate (mU/min)
U = 3;

% States (3)
% Plasma Glucose Conc. (mmol/L)
G = x(1,1);
% Plasma Insulin Conc. (mU/L) in remote compartment
X = x(2,1);
% Plasma Insulin Conc. (mU/L)
I = x(3,1);

% Disturbances (1):
% Meal glucose disturbance (mmol/L-min)
% Disturbance from the large meal
D = 3 * exp(-0.05 * t);

% Parameters
% Basal values of glucose and insulin conc.
G_basal = 4.5; % mmol/L
X_basal = 15; % mU/L
I_basal = 15; % mU/L
% For a type-I diabetic
P1 = 0.028735; % min-1
P2 = 0.028344; % min-1
P3 = 5.035e-5; % mU/L
V1 = 12; % L
n = 5/54; % min

Gdot = -P1 * (G - G_basal) - (X - X_basal) * G + D;
Xdot = -P2 * (X - X_basal) + P3 * (I - I_basal);
Idot = -n * I + U / V1;

% Vector to return
xdot = [Gdot; Xdot; Idot];