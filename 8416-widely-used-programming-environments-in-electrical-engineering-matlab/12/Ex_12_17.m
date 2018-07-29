        % Ciclu repetitiv pentru calcularea coeficientilor binomiali
for k=1:10
    binom(k,1:k+1)=mfun('binomial',k,0:k);
end
        % Afisarea rezultatului
disp('Coeficientii binomiali')
disp(binom)