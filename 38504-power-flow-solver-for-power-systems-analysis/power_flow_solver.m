function [Ebus, Ibus, Imat, iter] = power_flow_solver(Ymat, Pbus, Qbus, E1)
% function [Ebus, Ibus, Imat, iter] = power_flow_solver(Ymat, Pbus, Qbus, E1)
%
% Written by Dr. Yoash Levron, October 2012.
% I work at the Technion University (Haifa, Israel).
% my E-mail:  yoashlevron@gmail.com
% You can contact me regarding questions.
% Use of this function is free of charge, however
% references will be appreciated in case it supports
% computations in published research material.
%
% Power-flow solver are extensively used in power
% system analysis. This function provides a basic
% power-flow solver, based on the Gauss-Seidel method.
% The function may solve a power network of arbitrary size
% and complexity. The solution is fast and robust.
% Convergence is guaranteed if the network does have a solution.
% However, this function is limited to the analysis of 
% P-Q buses only (representing either generators or loads).
% P-V buses cannot be modeled. In addition, voltage and current
% limits are ignored. Therefore, this function may be used
% in the analysis of small power networks, or as an instructive
% tool for students, but is probably impractical in real-world
% power networks.
%
% The network is composed of power lines (admittances) and busses.
% busses are indexed 1..N. A power source and/or a shunt admittance
% may be connected to each bus. The direction of power is always defined
% towards the network. Generators are defined with positive
% real power, and loads with negative real power. 
% All buses are considered P-Q buses, with one exception: Bus 1 is always
% the 'slack' bus, represented as voltage source having a preset phase
% (this phase serves as a reference for all other phases). The usual choice
% is E1 = 1.0*exp(j*0), that is, a slack bus with unity voltage and zero phase.
%
% FUNCTION INPUTS:
%
% Ymat - an N*N matrix, defining the admittances of the network.
% (admittance = 1/impedance). All values are complex (representing
% magnitude and angle). Y(i,i) - is the shunt admittance
% of bus i to ground. Y(i,j) - is the admittance connecting 
% bus i to bus j (given i~=j). If no line connects i and j,
% the associated admittance is zero.
% Mark 1: do not get confused: Y=Inf is a 'short'. Y=0 is an open circuit.
% Infinite admittance result in multiple solutions and are forbidden.
% Mark 2: Ymat must be symmetric.
% Mark 3: this is NOT the Y matrix shown in textbooks,
% but a simple definition of the network's admittances.
% minus signs and summations must not be used. Those are
% added automatically in the code. Just enter the simple
% admittances of the network.
%
% Pbus - Active power vector. Pbus(i) is the active
% power injected to bus i. power is positive for generators and
% negative for loads. If no source exists, define Pbus(i)=0. 
% to prevent possible confusion, a power source is not allowed
% on bus 1 (the slack bus).
%
% Qbus - Reactive power vector. Same definitions as Pbus.
%
% E1 - The voltage of the 'slack bus' (bus 1). A usual
% selection is E1=1.0 . This is a scalar.
%
% FUNCTION OUTPUTS:
%
% Ebus - The resulting vector of bus voltages. Complex
% voltage values (magnitude & phase). 
%
% Ibus - The resulting currents' vector (complex values).
% Ibus(i) is the current supplied to the network by the
% source at bus i. For example:  Ibus(1) is the current
% supplied by the slack bus. The injected power can
% be computed by Ebus(i)*conj(Ibus(i)).
% If no power source is present at bus i, Ibus(i) should
% result in 0. Ibus(i) includes the current supplied to
% shunt admittances at bus i. Thus, the shunt admittance
% increases this value.
%
% Imat - an N*N matrix of line currents. Imat(i,j)is the
% current flowing from bus i to bus j. Imat(i,i) is the 
% current in the shunt admittance, not including the current
% supplied by the source at that node. The sum of the i'th
% raw of Imat should equal Ibus(i)
%
% iter - number of iterations done until convergence


%%%%%% parameters %%%%%%%
eps_err = 1e-9;
max_iter = 100000;

Ebus = NaN;
Ibus = NaN;
Imat = NaN;
iter = 0;

%%%%%% check inputs %%%%%%%%%%
N = size(Ymat,1);

if (N == 0)
    disp('Error - no data');
    beep; return;
end
if (size(Ymat,2)~=N)
    disp('Error - Ymat is not square');
    beep; return;
end
if (~isequal(Ymat,Ymat.'))
    disp('Error - Ymat is not symmetric');
    beep;  return;
end
if (length(Pbus) ~= N)
    disp('Error - inputs mismatch');
    beep;  return;    
end
if (length(Qbus) ~= N)
    disp('Error - inputs mismatch');
    beep;  return;    
end
if (length(E1) ~= 1)
    disp('Error - inputs mismatch');
    beep;  return;    
end
if (Pbus(1) ~= 0)
    disp('Error - ');
    disp('To avoid confusing results do not place a power');
    disp('source in parallel to the voltage source on bus 1.');
    disp('set Pbus(1)=Qbus(1)=0.');
    beep;  return;
end
if (Qbus(1) ~= 0)
    disp('Error - ');
    disp('To avoid confusing results do not place a power');
    disp('source in parallel to the voltage source on bus 1.');
    disp('set Pbus(1)=Qbus(1)=0.');
    beep;  return;
end
ii = find(isinf(abs(Ymat)));
if (~isempty(ii))
    disp('Error - admittance is Infinite (electric short)');
    beep;  return;
end
if (abs(E1) < eps(1e3))
    disp('Error - E1 magnitude too small');
    beep;  return;
end
if (size(Pbus,1) == 1)
    Pbus = Pbus.';  % column vector
end
if (size(Qbus,1) == 1)
    Qbus = Qbus.';  % column vector
end


%%%%%%%%%% Prepare matrixes for computation %%%%%%%
Y = - Ymat;
Ydiag = sum(Ymat,2);

LL = max(abs(Ydiag));
if (LL<eps(100))
    % if all admittances are extermely small
    disp('Error - self admittance is too low (floating bus)');
    beep;  return;
end
ii = find(abs(Ydiag)/LL < 10*eps_err);
if (~isempty(ii))
    disp('Error - self admittance is too low (floating bus)');
    beep;  return;
end

Y(1:(N+1):end) = Ydiag;
S = Pbus + j*Qbus;
E = E1*ones(N-1,1); % initial voltage guess on buses 2..N
A = Ydiag(2:end);
B = 1./A;
S2 = S(2:end);
Y2 = Y(2:end,1:end);

%%%%%%%%%% compute voltages %%%%%%%
err = inf;
count = 0;
still_good = 1;
if (N == 1)
    E = [];
else
    % iterate to find voltages:
    while ((err > eps_err) & (count<max_iter) & still_good)
        % check positive voltage magnitudes:
        ii = find(abs(E)<eps(1e3));
        if (~isempty(ii))
            still_good = 0;
            break;
        end
        
        Enew = B.*( conj(S2./E) - Y2*[E1 ; E] + A.*E );
        % compute new error
        err = max(abs(Enew - E)) ./ abs(E1);
        % substitute new voltage vector
        E = Enew;
        count = count + 1;
    end
end
iter = count;
if ((count == max_iter) | (still_good == 0))
    disp('Error - failed to converge.');
    disp('The primary reason for disconvergence');
    disp('is a network with no valid solutions. This usually');
    disp('occurs due too low line admittances (weak lines). Increase');
    disp('the line admittances {Y(i,j), i~=j}, and try again.');
    disp('Nevertheless, avoid the use of Infinite admittances.');
    beep;  return;
end

%%%%%%%%%% sum up the results %%%%%%%
Ebus = [E1 ; E];
Ibus = Y*Ebus;

Imat = zeros(N);
for ii=1:N
    for jj=1:N
        if (ii~=jj)
            Imat(ii,jj) = Ymat(ii,jj)*(Ebus(ii)-Ebus(jj));
        else
            Imat(ii,ii) = Ymat(ii,ii)*Ebus(ii);
        end
    end
end

end