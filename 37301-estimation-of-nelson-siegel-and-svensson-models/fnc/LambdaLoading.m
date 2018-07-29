function y =LambdaLoading(lambda, tau)
    y = -1*((1-exp(-lambda.*tau))./(lambda.*tau) - exp(-lambda.*tau));      
end