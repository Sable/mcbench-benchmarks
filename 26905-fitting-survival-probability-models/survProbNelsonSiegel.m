function prob = survProbNelsonSiegel(t,b)
% survProbNelsonSiegel: Computes survival probability using a Nelson-Siegel
% type of model

prob = (1+b(1)*t).*exp(-(b(1)+b(2))*t);
