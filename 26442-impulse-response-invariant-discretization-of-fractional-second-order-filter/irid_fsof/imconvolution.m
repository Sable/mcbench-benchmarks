% real convolution
function y=imconvolution(reroot,imroot,gammac,tau,t)
y=(1/gamma(gammac)/gamma(gammac)).*(tau.^(gammac-1).*exp(reroot.*tau).*sin(imroot.*tau)).*((t-tau).^(gammac-1).*exp(reroot.*(t-tau)).*sin(imroot.*(t-tau)));