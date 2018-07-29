%% Autoregressive Conditional Mean & Variance
% Allows the estimation of the family of ARMAX-GARCH of any order of
% AR, MA, ARCH and GARCH terms with the Gaussian, Student-t, 
% Generalized Error, Modified Cauchy, Hansen's Skew-t, Logistic, Laplace,
% Rayleigh, Centered Cauchy, Extreme Value Distribution Type 1, Generalized 
% Exponential and Gram and Charlier expansion series with constant higher moments.
%
%% *_ARMAX Models_* 
%
% $$ARMAX(AR, MA, X): r_t = a_0 + {\sum_{i=1}^n}{a_1}{r_{t-i}} + {\sum_{j=1}^k}{a_2}{\varepsilon}_{t-j} + {\sum_{l=1}^m}{a_3}{X_l} + {\varepsilon}_t$
%
%% *_GARCH Models_*
%
% $$GARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}{\varepsilon}_{t-i}^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-q}^2 + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$GJR-GARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}{\varepsilon}_{t-i}^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^2 + {\sum_{i=1}^p}b_{3,i}{\varepsilon}_{t-i}^2*I_{t-i} + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$EGARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}(|{\varepsilon}_{t-i}|/{\sqrt{{\sigma}_{t-i}^2}}-{\sqrt{2/pi}}) +{\sum_{j=1}^q}b_{2,j}{\log{{\sigma}_{t-j}^2}} +  {\sum_{i=1}^p}b_{3,i}{\varepsilon}_{t-i}/{\sqrt{{\sigma}_{t-i}}} + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$NARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}|{\varepsilon}_{t-i}|^d + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^2 + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$NGARCH(P,Q,Y): {\sigma}_t^d = b_0 + {\sum_{i=1}^p}b_{1,i}|{\varepsilon}_{t-i}|^d + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^d + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$AGARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}({\varepsilon}_{t-i} + {\gamma_{t-p}}))^2 + {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j} + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$APGARCH(P,Q,Y): {\sigma}_t^d = b_0 + {\sum_{i=1}^p}b_{1,i}|{\varepsilon}_{t-i}-{\gamma_{t-i}}{\varepsilon}_{t-1}|^d +  {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^d + {\sum_{l=1}^m}{b_3}{Y_l}$
% $$NAGARCH(P,Q,Y): {\sigma}_t^2 = b_0 + {\sum_{i=1}^p}b_{1,i}({\varepsilon}(t-i)/{\sqrt{{\sigma}_{t-i}^2}} + {\sum_{i=1}^p}{\gamma_{t-i}}^2 +  {\sum_{j=1}^q}b_{2,j}{\sigma}_{t-j}^2 + {\sum_{l=1}^m}{b_3}{Y_l}$
%
%% *_Distributions_*
%
% $$Gaussian: f(x) = {\frac{1}{\sqrt{{2}{\pi}{\sigma}_t^2}}}e^{\frac{-{\epsilon}_t^2}{2{\sigma}_t^2}}$
% 
% $$Student's \ t: f(x) = \frac{{\Gamma}\left(\frac{{\nu}+1}{2} \right)}{\sqrt{{\nu}{\pi}}{\Gamma} \left( \frac{{\nu}}{2} \right)}\left(1+\frac{\epsilon_t^2}{\nu} \right)^{-\frac{\nu+1}{2}}$
%
% $$Generalized \ Error : f(x) = \frac{{\nu}e^{\left(-\frac{1}{2}\left|\frac{\epsilon_t}{\beta\sigma_t}\right|^{\nu}\right)}}{2^{\frac{\nu+1}{\nu}}\Gamma\left(\frac{1}{\nu}\right)\beta\sigma_t}, \ \beta = \left[\frac{\Gamma\left(\frac{1}{\nu}\right)}{2^{\frac{2}{\nu}}\Gamma\left(\frac{3}{\nu}\right)}\right]^{0.5}$
%
% $$Hansen's \ Skew-t :$
%
% $$Gram-Charlier \ Expansion: f(x) ={\frac{1}{\sqrt{{2}{\pi}{\sigma}_t^2}}}e^{\frac{-{\epsilon}_t^2}{2{\sigma}_t^2}}\frac{\psi\left({\eta}_t\right)^2}{\Gamma_t}$
%
% $$Modified \ Cauchy: f(x) = \frac{1}{\pi\sigma_t\left(1+\frac{\epsilon_t^2}{\sigma_t^2} \right)}$
%
% $$Centered \ Cauchy: f(x) = \frac{1}{\pi\gamma\left(1+\frac{\epsilon_t^2}{\gamma^2} \right)}$
%
% $$Logistic: f(x) = \frac{e^{-\frac{\epsilon_t}{\sigma_t}}}{\sigma_t\left(1+e^{-\frac{\epsilon_t}{\sigma_t}} \right)^2}$
%
% $$Laplace: f(x) = \frac{1}{2\sigma_t}e^{\frac{|\epsilon_t|}{\sigma_t}}$
%
% $$Rayleigh: f(x) = \frac{\epsilon_t}{\sigma_t^2}e^{-\frac{\epsilon_t^2}{2\sigma_t^2}}$
% 
% $$Extreme \ Value \ Distribution \ Type \ 1: f(x) = {\frac{1}{\sqrt{{\sigma}_t^2}}}e^{\frac{-{\epsilon}_t^2}{2{\sigma}_t^2}}e^{e^{\frac{-{\epsilon}_t^2}{2{\sigma}_t^2}}}$
%
% $$Generalized \ Exponential: f(x) = \frac{1}{\sigma_t}e^{-\frac{\epsilon_t}{\sigma_t}}$
%
% <..\readme\readme.html Return to Main>