% fopolynomial.m    integration
function y = integration2(x,a,b,gamma,t)
         sqrtDelta = sqrt(abs(a^2-4*b));
         s1=(-a-sqrtDelta)/2;
         s2=(-a+sqrtDelta)/2;
         y = exp((s1-s2).*x).*(x.^(gamma-1)).*((t-x).^(gamma-1));