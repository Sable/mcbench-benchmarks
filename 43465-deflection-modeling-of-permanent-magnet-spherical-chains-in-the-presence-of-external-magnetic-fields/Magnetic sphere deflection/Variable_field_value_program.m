%This file calculates the position of each sphere with a variable applied
%magnetic field, so the deflection as a function of the applied magnetic
%field may be plotted.

%Kilian O'Donoghue
%31st July 2013

clc
close all

global n B_mag_ext theta_B_ext Ms

B_mag_ext=2.5e-3;
theta_B_ext=pi/2;
Ms=1.32/u0; %Remnant flux density of magnet divided by permeability

i=1;
for B_mag_ext=0:.005:.035; %specify the range of magnetic field values to apply to the system

vars_0=0*ones(1,2*n+1); %set initial guess to zero

options=optimset('Display','iter','TolFun',1e-10); %define solver options
[var_min,F,exitflag,output] = fsolve(@Sphere_energy_function,vars_0,options); %call function solver

%for this 3 sphere example, the values of the phi and gamma variables are
%stored at each magnetic field value
phi_store1(1,i)=var_min(1);
phi_store2(1,i)=var_min(2);
gamma_store(i)=var_min(length(var_min));
phi_store3(1,i)=var_min(2);

B_mag_used(i)=B_mag_ext; % stores the magnetic fields used
i=1+i;


end

%plot a selection of data
figure
plot(B_mag_used,phi_store1)
xlabel( 'Applied magnetic field [T]')
ylabel( 'Phi1 angle [rads]')
figure
plot(B_mag_used,phi_store2)
xlabel( 'Applied magnetic field [T]')
ylabel( 'Phi2 angle [rads]')
figure
plot(B_mag_used,gamma_store)
xlabel( 'Applied magnetic field [T]')
ylabel( 'Gamma angle [rads]')

