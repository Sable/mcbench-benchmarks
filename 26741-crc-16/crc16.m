function [resto] = crc16(h)
    %El polinomio Gx es un Estandar X^16+X^15+X^2+1
    gx = [1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1];
    %Igualamos PX
    px = h;
    %Calculamos P(x)x^r
    pxr=[px zeros(1,length(gx)-1)];
    %Realizamos la division del vector y obtenemos el cociente (c) y el
    %resitudo (r), entre pxr y gx
    [c r]=deconv(pxr,gx);
    %En ocaciones esta division nos resulta en valores negativo (-1), y
    %verificamos que sea 1 o 0
    r=mod(abs(r),2);
    %Obtenemso el crc-16
    resto=r(length(px)+1:end);
end
