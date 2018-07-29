function example
% Two-state model of gene expression
%
% Reaction network:
%   0 -> mRNA
%   mRNA -> mRNA + protein
%   mRNA -> 0
%   protein -> 0

tspan = [0, 10000]; %seconds
x0 = [0, 0]; %mRNA, protein
stoich_matrix = [ 1  0  ; %transcription
                  0  1  ; %translation
                 -1  0  ; %mRNA degradation
                  0 -1 ]; %protein degradation

% Rate constants
p.kR = 0.1;%0.01;      
p.kP = 0.1;%1;                     
p.gR = 0.1;                        
p.gP = 0.002;

% Run simulation
%[t,x] = directMethod(stoich_matrix, @propensities_2state, tspan, x0, p);
[t,x] = firstReactionMethod(stoich_matrix, @propensities_2state, tspan, x0, p);

% Plot time course
figure(gcf);
stairs(t,x);
set(gca,'XLim',tspan);
xlabel('time (s)');
ylabel('molecules');
legend({'mRNA','protein'});

end

function a = propensities_2state(x, p)
mRNA    = x(1);
protein = x(2);

a = [p.kR; 
     p.kP*mRNA;
	 p.gR*mRNA;
     p.gP*protein];
end
