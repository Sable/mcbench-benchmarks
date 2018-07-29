function p3=linspace(p1,p2,n)
%PREAL/LINSPACE Oveloaded linspace function for class PREAL.

global useUnitsFlag

if ~(exist('n','var')), n=100; end
if ~(useUnitsFlag) % If physunits is disabled...
    p3=linspace(double(p1),double(p2),double(n)); % ... treat as double.
    return
end

p1=preal(p1);
p2=preal(p2);
tol=0.001;

if ~isscalar(p1)||~isscalar(p2)
    error('End points must be scalar.')
end

if any(abs(p1.units-p2.units)>tol)
    error('End points must be of same dimension.')
end

if isa(n,'preal')&&any(abs(n.units)>tol)
    error('Number of points must be dimensionless.')
end

u=get(p1,'units');
p0=preal(1,u);
p3=linspace(double(p1),double(p2),double(n))*p0;