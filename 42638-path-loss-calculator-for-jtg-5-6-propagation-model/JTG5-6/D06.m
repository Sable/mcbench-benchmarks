function [ D ] = D06( f,h1,h2 )

    Df = 0.000389*f*h1*h2;
    Dh = 4.1*(sqrt(h1)+sqrt(h2));
    D = Df*Dh/(Df+Dh);
end

