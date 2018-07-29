%% Autoregressive Conditional Mean, Variance and Kurtosis
% Allows the estimation of the Autoregressive Conditional Kurtosis Model
% presented in Brooks, C., Burke, S., P., and Persand, G., (2005), 
% "Autoregressive Conditional Kurtosis Model", Journal of Financial 
% Econometrics, 3(3),339-421.
%
%% *_Mean Models_* 
%
% $$ARMAX(AR, MA, X): r_t = a_0 + {\sum_{i=1}^n}{a_1}{r_{t-i}} + {\sum_{j=1}^k}{a_2}{\varepsilon}_{t-j} + {\sum_{l=1}^m}{a_3}{X_l} + {\varepsilon}_t$
%
%% *_Variance Models_*
%
% $$GARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}{\varepsilon}_{t-i}^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-q}^2 + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$GJR-GARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}{\varepsilon}_{t-i}^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^2 + {\sum_{i=1}^p}b_{3,i}{\varepsilon}_{t-i}^2*I_{t-i} + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$AGARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}({\varepsilon}_{t-i} + {\gamma_{t-p}}))^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j} + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$NAGARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}({\varepsilon}(t-i)/{\sqrt{{\sigma}_{t-i}^2}} + {\sum_{i=1}^p}{\gamma_{t-i}}^2 +  {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^2 + {\sum_{l=1}^m}{b_3}{Y_l}$
%
%% *_Kurtosis Models_*
% $$GARCH-K(P,Q): k_t = d_0 + {\sum_{i=1}^p}d_{1,i}{\varepsilon}_{t-i}^4/{\sigma}_{t-i}^2 +{\sum_{j=1}^q}d_{2,j}k_{t-q}$
%
%% *_Distribution_*
%
% $$f(x) = \frac{{\Gamma}\left(\frac{{\nu_t}+1}{2} \right)}{\sqrt{{\nu_t}{\pi}}{\Gamma} \left( \frac{{\nu_t}}{2} \right)}\left(1+\frac{\epsilon_t^2}{\nu_t} \right)^{-\frac{\nu_t+1}{2}}$
%
% where the degrees of freedom can be expressed as a function of conditional kurtosis
%
% $$\nu_t = \frac{4k_t - 6}{k_t - 3}$
%
% <..\readme\readme.html Return to Main>