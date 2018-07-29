function y = normalize(xx,yy)
        length = sqrt(xx^2+yy^2);
        y = [xx,yy]/length;
        y = y';