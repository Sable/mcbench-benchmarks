function z=fun00(x)
z=0;
for i=1:length(x)
    z=z+x(i)*sin(abs(x(i)));
end

