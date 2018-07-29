function [ stg_Ld, stg_Rd, att ] = filter_damping_design( stg_L, stg_C, fs, Zmax)
% function [ stg_Ld, stg_Rd, att ] = filter_damping_design( stg_L, stg_C, fs, Zmax)
% Design the optimal damping for a passive filter in power electronics applications.
% Written by Dr. Yoash Levron
%
% This function designs the optimal L-R damping network for a multistage passive filter.
% It compues the optimal damping network, that achieves the best
% attenuation at a desired switching frequency fs, and has an output impedance
% smaller than a specified threshold Zmax, over all frequencies.
% the number of stages may be 1,2 or 3.
% The damping inductors, if placed at all, are chosen to be equal, 
% so practical filters can be built using the same inductor, reducing cost.
% The attached photo shows the topology and component names.
%
% Input:
% stg_L - [H] specifies the primary inductors at each stage.
%                    This is a vector with 1, 2 or 3 components.
% stg_C - [F] specifies the primary capacitors at each stage.
%                     It is the same length as stg_L.
% fs - [Hz] desired switching frequency to attenuate.
% Zmax - [ohm] desired maximal output impedance (over all frequencies).
%
% Output:
% stg_Ld - [H] the resulting damping inductors.
% stg_Rd - [ohm] the resulting damping resistors.
% att - [dB] the resulting optimal attenuation at frequency fs

% numeric parameters
NLd = 10; % number of damping inductors to compare
NRd = 20;  % number of damping resistors to compare
min_resistor_factor = 0.2;
max_resistor_factor = 20;

% default outputs
stg_Ld = NaN;
stg_Rd = NaN;
att = NaN;
Zmax_out = NaN;

% check inputs:
if (length(stg_L) == length(stg_C))
    NS = length(stg_L);  % number of stages
else
    disp('filter_damping_design - error : unequal number of inductors and capacitors');
    beep; return
end
if (NS >3)
    disp('filter_damping_design - error : Three stages maximum');
    beep; return
end

Ltot = sum(stg_L);
Ctot = sum(stg_C);
Rnom = (Ltot/Ctot)^0.5;
Ldvec = linspace((max(stg_L)/NLd),max(stg_L),NLd);
Rdvec = logspace( log10(min_resistor_factor*Rnom), ...
    log10(max_resistor_factor*Rnom),  (NRd-1));
Rdvec(NRd) = 10e6;  % add an infinite resistor

ws = 2*pi*fs;

%%%% design for a first order filter %%%%
if (NS ==1)
    L1 =  stg_L(1);
    C1 =  stg_C(1);
    Ldvec = [0 Ldvec];   NLd=NLd+1;  % add a zero to the possible inductor values
    MAT = zeros(NLd,NRd);  % matrix of results
    for ii1 = 1:NLd  % index for damping inductor
        xx = (ii1-1) / NLd;
        done = floor(1000*xx)/10;
        disp(sprintf('%3.1f%% done',done));
        
        for ii2 = 1:NRd % index for 1st damping resistor
            % determine components
            Ld1 = Ldvec(ii1);
            Rd1 = Rdvec(ii2);
            
            % compute coefficients
            a1 = (L1 + Ld1)/Rd1;
            d1 = L1;
            d2 = (L1*Ld1)/Rd1;
            b1 = (L1 + Ld1)/Rd1;
            b2 =  C1*L1;
            b3 = (C1*L1*Ld1)/Rd1;
            
            % compute the resonance frequencies - vector Wr
            Wr = [(1/b2) (b1/b3)].^0.5;
            ind = find(~isinf(Wr));
            Wr = Wr(ind);
            
            % compute the impedace at resonance
            s = i*Wr;
            Zout = (d1*s + d2*s.^2) ./ (1 + b1*s + b2*s.^2 + b3*s.^3);
            ind = find(abs(Zout) > Zmax);
            output_impedance_too_big = ~isempty(ind);
            
            % compute the attenuation
            s = i*ws;
            H = (1 + a1*s) / (1 + b1*s + b2*s^2 + b3*s^3);
            H_dB = 20*log10(abs(H));
            
            MAT(ii1,ii2) = H_dB + 1e10*output_impedance_too_big;
        end
    end
    %%% find the best filter
    [att, ind] = min(MAT(:));
    if (att > 1e9)
        disp('filter_damping_design - error : Design failed. Output impedance too high');
        beep; return;
    end
    [ii1,ii2] = ind2sub(size(MAT),ind);  % indexes of optimal filter
    Ld1 = Ldvec(ii1);
    Rd1 = Rdvec(ii2);
    stg_Ld = [Ld1];
    stg_Rd = [Rd1];
end


%%%% design for a second order filter %%%%
if (NS ==2)
    disp('This may take a few minutes. please wait ...');
    L1 =  stg_L(1);  L2 = stg_L(2);
    C1 =  stg_C(1);  C2 = stg_C(2);
    MAT = zeros(NLd,NRd,NRd,2,2);  % matrix of results
    for ii1 = 1:NLd  % index for damping inductor
        for ii2 = 1:NRd % index for 1st damping resistor
            xx = ((ii1-1)*NRd+(ii2-1)) / (NLd*NRd);
            done = floor(1000*xx)/10;
            disp(sprintf('%3.1f%% done',done));
            
            for ii3 = 1:NRd % index for 2st damping resistor
                for ii5 = 1:2  % index for the existance of 1st damping inductor
                    for ii6 = 1:2  % index for the existance of 2st damping inductor
                        % determine components
                        Ld1 = Ldvec(ii1) * (ii5-1);
                        Ld2 = Ldvec(ii1) * (ii6-1);
                        Rd1 = Rdvec(ii2);
                        Rd2 = Rdvec(ii3);
                        
                        % compute coefficients
                        a1 = (L1 + Ld1)/Rd1 + (L2 + Ld2)/Rd2;
                        a2 = ((L1 + Ld1)*(L2 + Ld2))/(Rd1*Rd2);
                        d1 = L1 + L2;
                        d2 = (L1*L2 + L1*Ld1 + L2*Ld1)/Rd1 + (L1*L2 + L1*Ld2 + L2*Ld2)/Rd2;
                        d3 = (L1*L2*Ld1 + L1*L2*Ld2 + L1*Ld1*Ld2 + L2*Ld1*Ld2)/(Rd1*Rd2) + C1*L1*L2;
                        d4 = (C1*L1*L2*(Ld1*Rd2 + Ld2*Rd1))/(Rd1*Rd2);
                        d5 = (C1*L1*L2*Ld1*Ld2)/(Rd1*Rd2);
                        b1 = (L1 + Ld1)/Rd1 + (L2 + Ld2)/Rd2;
                        b2 = C1*L1 + C2*L1 + C2*L2 + ((L1 + Ld1)*(L2 + Ld2))/(Rd1*Rd2);
                        b3 = (C2*L1*L2 + C1*L1*Ld1 + C2*L1*Ld1 + C2*L2*Ld1)/Rd1 + ...
                            (C1*L1*L2 + C2*L1*L2 + C1*L1*Ld2 + C2*L1*Ld2 + C2*L2*Ld2)/Rd2;
                        b4 = (C1*L1*L2*Ld1 + C2*L1*L2*Ld1 + C2*L1*L2*Ld2 + C1*L1*Ld1*Ld2 ...
                            + C2*L1*Ld1*Ld2 + C2*L2*Ld1*Ld2)/(Rd1*Rd2) + C1*C2*L1*L2;
                        b5 = (C1*C2*L1*L2*(Ld1*Rd2 + Ld2*Rd1))/(Rd1*Rd2);
                        b6 = (C1*C2*L1*L2*Ld1*Ld2)/(Rd1*Rd2);
                        
                        % compute the resonance frequencies - vector Wr
                        P1 = [-b6, +b4, -b2, +1];
                        P2 = [+b5, -b3, +b1];
                        WrA = (roots(P1)).^0.5;
                        WrB = (roots(P2)).^0.5;
                        ind1 = find(real(WrA) > 1e6*imag(WrA) );
                        ind2 = find(real(WrB) > 1e6*imag(WrB));
                        Wr = [real(WrA(ind1)).' real(WrB(ind2)).'];
                        
                        % compute the impedace at resonance
                        s = i*Wr;
                        Zout = (d1*s + d2*s.^2 + d3*s.^3 + d4*s.^4 + d5*s.^5) ./ ...
                            (1 + b1*s + b2*s.^2 + b3*s.^3 + b4*s.^4 + b5*s.^5 + b6*s.^6);
                        ind = find(abs(Zout) > Zmax);
                        output_impedance_too_big = ~isempty(ind);
                        
                        % compute the attenuation
                        s = i*ws;
                        H = (1 + a1*s + a2*s^2) / ...
                            (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6);
                        H_dB = 20*log10(abs(H));
                        
                        MAT(ii1,ii2,ii3,ii5,ii6) = H_dB + 1e10*output_impedance_too_big;
                    end
                end
            end
        end
    end
    %%% find the best filter
    [att, ind] = min(MAT(:));
    if (att > 1e9)
        disp('filter_damping_design - error : Design failed. Output impedance too high');
        beep; return;
    end
    [ii1,ii2,ii3,ii5,ii6] = ind2sub(size(MAT),ind);  % indexes of optimal filter
    Ld1 = Ldvec(ii1) * (ii5-1);       Ld2 = Ldvec(ii1) * (ii6-1);
    Rd1 = Rdvec(ii2);       Rd2 = Rdvec(ii3);
    stg_Ld = [Ld1 Ld2];
    stg_Rd = [Rd1 Rd2];
end


%%%% design for a third order filter %%%%
if (NS == 3)
    disp('This may take a few minutes. please wait ...');
    L1 =  stg_L(1);  L2 = stg_L(2);  L3 = stg_L(3);
    C1 =  stg_C(1);  C2 = stg_C(2);  C3 = stg_C(3);
    MAT = zeros(NLd,NRd,NRd,NRd,2,2,2);  % matrix of results
    for ii1 = 1:NLd  % index for damping inductor
        for ii2 = 1:NRd % index for 1st damping resistor
            xx = ((ii1-1)*NRd+(ii2-1)) / (NLd*NRd);
            done = floor(1000*xx)/10;
            disp(sprintf('%3.1f%% done',done));
            
            for ii3 = 1:NRd % index for 2st damping resistor
                for ii4 = 1:NRd % index for 3rd damping resistor
                    for ii5 = 1:2  % index for the existance of 1st damping inductor
                        for ii6 = 1:2  % index for the existance of 2st damping inductor
                            for ii7 = 1:2  % index for the existance of 3rd damping inductor
                                % determine components
                                Ld1 = Ldvec(ii1) * (ii5-1);
                                Ld2 = Ldvec(ii1) * (ii6-1);
                                Ld3 = Ldvec(ii1) * (ii7-1);
                                Rd1 = Rdvec(ii2);
                                Rd2 = Rdvec(ii3);
                                Rd3 = Rdvec(ii4);
                                
                                % compute coefficients
                                a1 = (L1 + Ld1)/Rd1 + (L2 + Ld2)/Rd2 + (L3 + Ld3)/Rd3;
                                a2 = ((L1 + Ld1)/(Rd1*Rd3) + (L2 + Ld2)/(Rd2*Rd3))*(L3 + Ld3) +...
                                    ((L1 + Ld1)*(L2 + Ld2))/(Rd1*Rd2);
                                a3 = ((L1 + Ld1)*(L2 + Ld2)*(L3 + Ld3))/(Rd1*Rd2*Rd3);
                                d1 = L1 + L2 + L3;
                                d2 = (L1*L2*Rd1 + L1*L2*Rd2 + L1*L3*Rd2 + L2*L3*Rd1 + ...
                                    L1*Ld1*Rd2 + L1*Ld2*Rd1 + L2*Ld1*Rd2 + L2*Ld2*Rd1 + ...
                                    L3*Ld1*Rd2 + L3*Ld2*Rd1)/(Rd1*Rd2) +...
                                    (L1*L3*Rd1*Rd2 + L2*L3*Rd1*Rd2 + L1*Ld3*Rd1*Rd2 + ...
                                    L2*Ld3*Rd1*Rd2 + L3*Ld3*Rd1*Rd2)/(Rd1*Rd2*Rd3);
                                d3 =  (L1*L2*L3 + L1*L2*Ld1 + L1*L2*Ld2 + L1*L3*Ld2 + ...
                                    L2*L3*Ld1 + L1*Ld1*Ld2 + L2*Ld1*Ld2 + L3*Ld1*Ld2 + ...
                                    C1*L1*L2*Rd1*Rd2 + C1*L1*L3*Rd1*Rd2 + C2*L1*L3*Rd1*Rd2 + ...
                                    C2*L2*L3*Rd1*Rd2)/(Rd1*Rd2) + (L1*L2*L3*Rd1 + L1*L2*L3*Rd2 + ...
                                    L1*L2*Ld3*Rd1 + L1*L3*Ld1*Rd2 + L1*L3*Ld2*Rd1 + L1*L2*Ld3*Rd2 +...
                                    L2*L3*Ld1*Rd2 + L2*L3*Ld2*Rd1 + L1*L3*Ld3*Rd2 + L2*L3*Ld3*Rd1 +...
                                    L1*Ld1*Ld3*Rd2 + L1*Ld2*Ld3*Rd1 + L2*Ld1*Ld3*Rd2 + L2*Ld2*Ld3*Rd1 +...
                                    L3*Ld1*Ld3*Rd2 + L3*Ld2*Ld3*Rd1)/(Rd1*Rd2*Rd3);
                                d4 = (C1*L1*L2*L3*Rd1 + C2*L1*L2*L3*Rd1 + C2*L1*L2*L3*Rd2 + ...
                                    C1*L1*L2*Ld1*Rd2 + C1*L1*L2*Ld2*Rd1 + C1*L1*L3*Ld1*Rd2 + ...
                                    C1*L1*L3*Ld2*Rd1 + C2*L1*L3*Ld1*Rd2 + C2*L1*L3*Ld2*Rd1 + ...
                                    C2*L2*L3*Ld1*Rd2 + C2*L2*L3*Ld2*Rd1)/(Rd1*Rd2) +...
                                    (L1*L2*L3*Ld1 + L1*L2*L3*Ld2 + L1*L2*L3*Ld3 + L1*L2*Ld1*Ld3 +...
                                    L1*L3*Ld1*Ld2 + L1*L2*Ld2*Ld3 + L2*L3*Ld1*Ld2 + L1*L3*Ld2*Ld3 +...
                                    L2*L3*Ld1*Ld3 + L1*Ld1*Ld2*Ld3 + L2*Ld1*Ld2*Ld3 + L3*Ld1*Ld2*Ld3 +...
                                    C1*L1*L2*L3*Rd1*Rd2 + C1*L1*L2*Ld3*Rd1*Rd2 + C1*L1*L3*Ld3*Rd1*Rd2 +...
                                    C2*L1*L3*Ld3*Rd1*Rd2 + C2*L2*L3*Ld3*Rd1*Rd2)/(Rd1*Rd2*Rd3);
                                d5 =  (C1*L1*L2*L3*Ld1 + C2*L1*L2*L3*Ld1 + ...
                                    C2*L1*L2*L3*Ld2 + C1*L1*L2*Ld1*Ld2 + C1*L1*L3*Ld1*Ld2 +...
                                    C2*L1*L3*Ld1*Ld2 + C2*L2*L3*Ld1*Ld2 + ...
                                    C1*C2*L1*L2*L3*Rd1*Rd2)/(Rd1*Rd2) + (C1*L1*L2*L3*Ld1*Rd2 +...
                                    C1*L1*L2*L3*Ld2*Rd1 + C1*L1*L2*L3*Ld3*Rd1 + C2*L1*L2*L3*Ld3*Rd1 +...
                                    C2*L1*L2*L3*Ld3*Rd2 + C1*L1*L2*Ld1*Ld3*Rd2 + C1*L1*L2*Ld2*Ld3*Rd1 +...
                                    C1*L1*L3*Ld1*Ld3*Rd2 + C1*L1*L3*Ld2*Ld3*Rd1 + C2*L1*L3*Ld1*Ld3*Rd2 +...
                                    C2*L1*L3*Ld2*Ld3*Rd1 + C2*L2*L3*Ld1*Ld3*Rd2 + ...
                                    C2*L2*L3*Ld2*Ld3*Rd1)/(Rd1*Rd2*Rd3);
                                d6 = (C1*L1*L2*L3*Ld1*Ld2 + C1*L1*L2*L3*Ld1*Ld3 + ...
                                    C2*L1*L2*L3*Ld1*Ld3 + C2*L1*L2*L3*Ld2*Ld3 + C1*L1*L2*Ld1*Ld2*Ld3 +...
                                    C1*L1*L3*Ld1*Ld2*Ld3 + C2*L1*L3*Ld1*Ld2*Ld3 + C2*L2*L3*Ld1*Ld2*Ld3 +...
                                    C1*C2*L1*L2*L3*Ld3*Rd1*Rd2)/(Rd1*Rd2*Rd3) +...
                                    (C1*C2*L1*L2*L3*(Ld1*Rd2 + Ld2*Rd1))/(Rd1*Rd2);
                                d7 =  (C1*C2*L1*L2*L3*(Ld1*Ld2*Rd3 + Ld1*Ld3*Rd2 +...
                                    Ld2*Ld3*Rd1))/(Rd1*Rd2*Rd3);
                                d8 = (C1*C2*L1*L2*L3*Ld1*Ld2*Ld3)/(Rd1*Rd2*Rd3);
                                b1 = (L1 + Ld1)/Rd1 + (L2*Rd3 + L3*Rd2 + Ld2*Rd3 + Ld3*Rd2)/(Rd2*Rd3);
                                b2 = (L2*L3 + L2*Ld3 + L3*Ld2 + Ld2*Ld3 + C1*L1*Rd2*Rd3 + C2*L1*Rd2*Rd3 +...
                                    C2*L2*Rd2*Rd3 + C3*L1*Rd2*Rd3 + C3*L2*Rd2*Rd3 + ...
                                    C3*L3*Rd2*Rd3)/(Rd2*Rd3) + ((L1 + Ld1)*(L2*Rd3 +...
                                    L3*Rd2 + Ld2*Rd3 + Ld3*Rd2))/(Rd1*Rd2*Rd3);
                                b3 =  (C1*L1*L2*Rd3 + C1*L1*L3*Rd2 + C2*L1*L2*Rd3 + C2*L1*L3*Rd2 +...
                                    C2*L2*L3*Rd2 + C3*L1*L2*Rd3 + C3*L1*L3*Rd2 + C3*L2*L3*Rd2 +...
                                    C3*L2*L3*Rd3 + C1*L1*Ld2*Rd3 + C1*L1*Ld3*Rd2 + C2*L1*Ld2*Rd3 +...
                                    C2*L1*Ld3*Rd2 + C2*L2*Ld2*Rd3 + C2*L2*Ld3*Rd2 + C3*L1*Ld2*Rd3 +...
                                    C3*L1*Ld3*Rd2 + C3*L2*Ld2*Rd3 + C3*L2*Ld3*Rd2 + C3*L3*Ld2*Rd3 +...
                                    C3*L3*Ld3*Rd2)/(Rd2*Rd3) + (L1*L2*L3 + L1*L2*Ld3 + L1*L3*Ld2 +...
                                    L2*L3*Ld1 + L1*Ld2*Ld3 + L2*Ld1*Ld3 + L3*Ld1*Ld2 + Ld1*Ld2*Ld3 +...
                                    C2*L1*L2*Rd2*Rd3 + C3*L1*L2*Rd2*Rd3 + C3*L1*L3*Rd2*Rd3 +...
                                    C1*L1*Ld1*Rd2*Rd3 + C2*L1*Ld1*Rd2*Rd3 + C2*L2*Ld1*Rd2*Rd3 +...
                                    C3*L1*Ld1*Rd2*Rd3 + C3*L2*Ld1*Rd2*Rd3 +...
                                    C3*L3*Ld1*Rd2*Rd3)/(Rd1*Rd2*Rd3);
                                b4 = (C1*L1*L2*L3 + C2*L1*L2*L3 + C3*L1*L2*L3 + C1*L1*L2*Ld3 +...
                                    C1*L1*L3*Ld2 + C2*L1*L2*Ld3 + C2*L1*L3*Ld2 + C2*L2*L3*Ld2 +...
                                    C3*L1*L2*Ld3 + C3*L1*L3*Ld2 + C3*L2*L3*Ld2 + C3*L2*L3*Ld3 +...
                                    C1*L1*Ld2*Ld3 + C2*L1*Ld2*Ld3 + C2*L2*Ld2*Ld3 + C3*L1*Ld2*Ld3 +...
                                    C3*L2*Ld2*Ld3 + C3*L3*Ld2*Ld3 + C1*C2*L1*L2*Rd2*Rd3 +...
                                    C1*C3*L1*L2*Rd2*Rd3 + C1*C3*L1*L3*Rd2*Rd3 + C2*C3*L1*L3*Rd2*Rd3 +...
                                    C2*C3*L2*L3*Rd2*Rd3)/(Rd2*Rd3) + (C2*L1*L2*L3*Rd2 + C3*L1*L2*L3*Rd2 +...
                                    C3*L1*L2*L3*Rd3 + C1*L1*L2*Ld1*Rd3 + C1*L1*L3*Ld1*Rd2 +...
                                    C2*L1*L2*Ld1*Rd3 + C2*L1*L3*Ld1*Rd2 + C2*L1*L2*Ld2*Rd3 + ...
                                    C2*L1*L2*Ld3*Rd2 + C2*L2*L3*Ld1*Rd2 + C3*L1*L2*Ld1*Rd3 +...
                                    C3*L1*L3*Ld1*Rd2 + C3*L1*L2*Ld2*Rd3 + C3*L1*L2*Ld3*Rd2 + ...
                                    C3*L2*L3*Ld1*Rd2 + C3*L1*L3*Ld2*Rd3 + C3*L1*L3*Ld3*Rd2 + ...
                                    C3*L2*L3*Ld1*Rd3 + C1*L1*Ld1*Ld2*Rd3 + C1*L1*Ld1*Ld3*Rd2 + ...
                                    C2*L1*Ld1*Ld2*Rd3 + C2*L1*Ld1*Ld3*Rd2 + C2*L2*Ld1*Ld2*Rd3 + ...
                                    C2*L2*Ld1*Ld3*Rd2 + C3*L1*Ld1*Ld2*Rd3 + C3*L1*Ld1*Ld3*Rd2 + ...
                                    C3*L2*Ld1*Ld2*Rd3 + C3*L2*Ld1*Ld3*Rd2 + C3*L3*Ld1*Ld2*Rd3 + ...
                                    C3*L3*Ld1*Ld3*Rd2)/(Rd1*Rd2*Rd3);
                                b5 = (C1*C2*L1*L2*L3*Rd2 + C1*C3*L1*L2*L3*Rd2 + C1*C3*L1*L2*L3*Rd3 + ...
                                    C2*C3*L1*L2*L3*Rd3 + C1*C2*L1*L2*Ld2*Rd3 + C1*C2*L1*L2*Ld3*Rd2 + ...
                                    C1*C3*L1*L2*Ld2*Rd3 + C1*C3*L1*L2*Ld3*Rd2 + C1*C3*L1*L3*Ld2*Rd3 + ...
                                    C1*C3*L1*L3*Ld3*Rd2 + C2*C3*L1*L3*Ld2*Rd3 + C2*C3*L1*L3*Ld3*Rd2 + ...
                                    C2*C3*L2*L3*Ld2*Rd3 + C2*C3*L2*L3*Ld3*Rd2)/(Rd2*Rd3) + ...
                                    (C1*L1*L2*L3*Ld1 + C2*L1*L2*L3*Ld1 + C2*L1*L2*L3*Ld2 + C3*L1*L2*L3*Ld1 +...
                                    C3*L1*L2*L3*Ld2 + C3*L1*L2*L3*Ld3 + C1*L1*L2*Ld1*Ld3 + C1*L1*L3*Ld1*Ld2 +...
                                    C2*L1*L2*Ld1*Ld3 + C2*L1*L3*Ld1*Ld2 + C2*L1*L2*Ld2*Ld3 + ...
                                    C2*L2*L3*Ld1*Ld2 + C3*L1*L2*Ld1*Ld3 + C3*L1*L3*Ld1*Ld2 + ...
                                    C3*L1*L2*Ld2*Ld3 + C3*L2*L3*Ld1*Ld2 + C3*L1*L3*Ld2*Ld3 + ...
                                    C3*L2*L3*Ld1*Ld3 + C1*L1*Ld1*Ld2*Ld3 + C2*L1*Ld1*Ld2*Ld3 + ...
                                    C2*L2*Ld1*Ld2*Ld3 + C3*L1*Ld1*Ld2*Ld3 + C3*L2*Ld1*Ld2*Ld3 + ...
                                    C3*L3*Ld1*Ld2*Ld3 + C2*C3*L1*L2*L3*Rd2*Rd3 + C1*C2*L1*L2*Ld1*Rd2*Rd3 +...
                                    C1*C3*L1*L2*Ld1*Rd2*Rd3 + C1*C3*L1*L3*Ld1*Rd2*Rd3 + ...
                                    C2*C3*L1*L3*Ld1*Rd2*Rd3 + C2*C3*L2*L3*Ld1*Rd2*Rd3)/(Rd1*Rd2*Rd3);
                                b6 = (C1*C2*L1*L2*L3*Ld2 + C1*C3*L1*L2*L3*Ld2 + C1*C3*L1*L2*L3*Ld3 + ...
                                    C2*C3*L1*L2*L3*Ld3 + C1*C2*L1*L2*Ld2*Ld3 + C1*C3*L1*L2*Ld2*Ld3 + ...
                                    C1*C3*L1*L3*Ld2*Ld3 + C2*C3*L1*L3*Ld2*Ld3 + C2*C3*L2*L3*Ld2*Ld3 + ...
                                    C1*C2*C3*L1*L2*L3*Rd2*Rd3)/(Rd2*Rd3) + (C1*C2*L1*L2*L3*Ld1*Rd2 + ...
                                    C1*C3*L1*L2*L3*Ld1*Rd2 + C1*C3*L1*L2*L3*Ld1*Rd3 + C2*C3*L1*L2*L3*Ld1*Rd3 +...
                                    C2*C3*L1*L2*L3*Ld2*Rd3 + C2*C3*L1*L2*L3*Ld3*Rd2 + C1*C2*L1*L2*Ld1*Ld2*Rd3 +...
                                    C1*C2*L1*L2*Ld1*Ld3*Rd2 + C1*C3*L1*L2*Ld1*Ld2*Rd3 + ...
                                    C1*C3*L1*L2*Ld1*Ld3*Rd2 + C1*C3*L1*L3*Ld1*Ld2*Rd3 + ...
                                    C1*C3*L1*L3*Ld1*Ld3*Rd2 + C2*C3*L1*L3*Ld1*Ld2*Rd3 + ...
                                    C2*C3*L1*L3*Ld1*Ld3*Rd2 + C2*C3*L2*L3*Ld1*Ld2*Rd3 + ...
                                    C2*C3*L2*L3*Ld1*Ld3*Rd2)/(Rd1*Rd2*Rd3);
                                b7 =  (C1*C2*L1*L2*L3*Ld1*Ld2 + C1*C3*L1*L2*L3*Ld1*Ld2 + ...
                                    C1*C3*L1*L2*L3*Ld1*Ld3 + C2*C3*L1*L2*L3*Ld1*Ld3 + ...
                                    C2*C3*L1*L2*L3*Ld2*Ld3 + C1*C2*L1*L2*Ld1*Ld2*Ld3 + ...
                                    C1*C3*L1*L2*Ld1*Ld2*Ld3 + C1*C3*L1*L3*Ld1*Ld2*Ld3 + ...
                                    C2*C3*L1*L3*Ld1*Ld2*Ld3 + C2*C3*L2*L3*Ld1*Ld2*Ld3 + ...
                                    C1*C2*C3*L1*L2*L3*Ld3*Rd1*Rd2)/(Rd1*Rd2*Rd3) + ...
                                    (C1*C2*C3*L1*L2*L3*(Ld1*Rd2 + Ld2*Rd1))/(Rd1*Rd2);
                                b8 = (C1*C2*C3*L1*L2*L3*(Ld1*Ld2*Rd3 + Ld1*Ld3*Rd2 + ...
                                    Ld2*Ld3*Rd1))/(Rd1*Rd2*Rd3);
                                b9 = (C1*C2*C3*L1*L2*L3*Ld1*Ld2*Ld3)/(Rd1*Rd2*Rd3);
                                
                                % compute the resonance frequencies - vector Wr
                                P1 = [+b8, -b6, +b4, -b2, +1];
                                P2 = [+b9, -b7, +b5, -b3, +b1];
                                WrA = (roots(P1)).^0.5;
                                WrB = (roots(P2)).^0.5;
                                ind1 = find(real(WrA) > 1e6*imag(WrA) );
                                ind2 = find(real(WrB) > 1e6*imag(WrB));
                                Wr = [real(WrA(ind1)).' real(WrB(ind2)).'];
                                
                                % compute the impedace at resonance
                                s = i*Wr;
                                Zout = (d1*s + d2*s.^2 + d3*s.^3 + d4*s.^4 + d5*s.^5 + d6*s.^6 + d7*s.^7 + d8*s.^8) ./ ...
                                    (1 + b1*s + b2*s.^2 + b3*s.^3 + b4*s.^4 + b5*s.^5 + b6*s.^6 + b7*s.^7 + b8*s.^8 + b9*s.^9);
                                ind = find(abs(Zout) > Zmax);
                                output_impedance_too_big = ~isempty(ind);
                                
                                % compute the attenuation
                                s = i*ws;
                                H = (1 + a1*s + a2*s^2 + a3*s^3) / ...
                                    (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6 + b7*s^7 + b8*s^8 + b9*s^9);
                                H_dB = 20*log10(abs(H));
                                
                                MAT(ii1,ii2,ii3,ii4,ii5,ii6,ii7) = H_dB + 1e10*output_impedance_too_big;
                            end
                        end
                    end
                end
            end
        end
    end
    %%% find the best filter
    [att, ind] = min(MAT(:));
    if (att > 1e9)
        disp('filter_damping_design - error : Design failed. Output impedance too high');
        beep; return;
    end
    [ii1,ii2,ii3,ii4,ii5,ii6,ii7] = ind2sub(size(MAT),ind);  % indexes of optimal filter
    Ld1 = Ldvec(ii1) * (ii5-1);       Ld2 = Ldvec(ii1) * (ii6-1);       Ld3 = Ldvec(ii1) * (ii7-1);
    Rd1 = Rdvec(ii2);       Rd2 = Rdvec(ii3);       Rd3 = Rdvec(ii4);
    stg_Ld = [Ld1 Ld2 Ld3];
    stg_Rd = [Rd1 Rd2 Rd3];
end

% mark infinite damping resistors
ind = find(stg_Rd > 9e6);
stg_Rd(ind) = inf;
stg_Ld(ind)  = 0;
end

%%% Transfer functions of the filters
% %%% 1 stage %%%
% H = (1 + a1*s) / (1 + b1*s + b2*s^2 + b3*s^3);
% Zout = (d1*s + d2*s^2) / (1 + b1*s + b2*s^2 + b3*s^3);

% %%% 2 stages %%%
% H = (1 + a1*s + a2*s^2) / ...
%     (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6);
% Zout = (d1*s + d2*s^2 + d3*s^3 + d4*s^4 + d5*s^5) / ...
%     (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6);

% %%% 3 stages %%%
% H = (1 + a1*s + a2*s^2 + a3*s^3) / ...
%     (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6 + b7*s^7 + b8*s^8 + b9*s^9);
% Zout = (d1*s + d2*s^2 + d3*s^3 + d4*s^4 + d5*s^5 + d6*s^6 + d7*s^7 + d8*s^8) / ...
%     (1 + b1*s + b2*s^2 + b3*s^3 + b4*s^4 + b5*s^5 + b6*s^6 + b7*s^7 + b8*s^8 + b9*s^9);
