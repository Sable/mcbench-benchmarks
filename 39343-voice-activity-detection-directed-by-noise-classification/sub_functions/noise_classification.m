function predict_label = noise_classification(sfr)



%% feature extraction for noise classification
[wpt,N] = pwpdsub(sfr);
t = 1;
for i=1:length(N)
    coef = abs(wpcoef(wpt,N(i)));
    
    fe(t) = mean(coef);
    t = t+1;
    fe(t) = std(coef);
    t = t+1;
    fe(t) = entropy(coef);
    t = t+1;
end
%%


load noisemodel

fe = fe*coeff; fe = fe(1:23);

[predict_label] = svmpredict(1, fe, model, '-b 0');