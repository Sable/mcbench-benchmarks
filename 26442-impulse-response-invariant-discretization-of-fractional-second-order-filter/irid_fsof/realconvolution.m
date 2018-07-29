% real convolution
function y=realconvolution(reroot,imroot,gammac,tau,t)
y=(1/gamma(gammac)/gamma(gammac)).*(tau.^(gammac-1).*exp(reroot.*tau).*cos(imroot.*tau)).*((t-tau).^(gammac-1).*exp(reroot.*(t-tau)).*cos(imroot.*(t-tau)));