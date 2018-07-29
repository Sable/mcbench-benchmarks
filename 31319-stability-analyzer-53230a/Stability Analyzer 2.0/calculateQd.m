function Qd = calculateQd(tau,alpha,h)
%calculates Qd for noise simulation algorithm from paper DISCRETE SIMULATION OF POWER LAW NOISE
%equation: Qd = h / (2*(2pi)^alpha * tau^(alpha-1))

Qd = h / (2*(2*pi)^alpha * tau^(alpha-1)); %calculate Qd