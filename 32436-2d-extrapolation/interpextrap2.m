function Zi = interpextrap2(X,Y,Z,Xi,Yi)

if (Xi > X(1)) && (Xi < X(end)) && (Yi > Y(1)) && (Yi < Y(end))
    Zi = interp2(X,Y,Z,Xi,Yi,'cubic');   
    
elseif (Xi > X(end)) && (Yi > Y(end))
    Zsize1 = size(Z);
    for row = 1:Zsize1(1,1)
        x = X;
        y = Z(row,:);
        xi = Xi;
        temp1(row) = interp1(x,y,xi,'cubic','extrap');
    end
    X = cat(2,X,Xi);
    Z = cat(2,Z,temp1');    
    Zsize2 = size(Z);
    for col = 1:Zsize2(1,2)
        x = Y;
        y = Z(:,col);
        xi = Yi;
        temp2(col) = interp1(x,y,xi,'cubic','extrap');
    end
    Y = cat(2,Y,Yi);
    Z = cat(1,Z,temp2);    
    Zi = interp2(X,Y,Z,Xi,Yi);
        
elseif (Xi < X(1)) && (Yi < Y(1))
    Zsize1 = size(Z);
    for row = 1:Zsize1(1,1)
        x = X;
        y = Z(row,:);
        xi = Xi;
        temp1(row) = interp1(x,y,xi,'cubic','extrap');
    end
    X = cat(2,Xi,X);
    Z = cat(2,temp1',Z);    
    Zsize2 = size(Z);
    for col = 1:Zsize2(1,2)
        x = Y;
        y = Z(:,col);
        xi = Yi;
        temp2(col) = interp1(x,y,xi,'cubic','extrap');
    end
    Y = cat(2,Yi,Y);
    Z = cat(1,temp2,Z);
    Zi = interp2(X,Y,Z,Xi,Yi);
    
elseif (Xi > X(1)) && (Xi < X(end)) && (Yi > Y(end))
    Zsize2 = size(Z);
    for col = 1:Zsize2(1,2)
        x = Y;
        y = Z(:,col);
        xi = Yi;
        temp2(col) = interp1(x,y,xi,'cubic','extrap');
    end
    Y = cat(2,Y,Yi);
    Z = cat(1,Z,temp2);    
    Zi = interp2(X,Y,Z,Xi,Yi);
    
elseif (Xi > X(1)) && (Xi < X(end)) && (Yi < Y(1))
    Zsize2 = size(Z);
    for col = 1:Zsize2(1,2)
        x = Y;
        y = Z(:,col);
        xi = Yi;
        temp2(col) = interp1(x,y,xi,'cubic','extrap');
    end
    Y = cat(2,Yi,Y);
    Z = cat(1,temp2,Z);    
    Zi = interp2(X,Y,Z,Xi,Yi);
    
elseif (Xi > X(end)) && (Yi > Y(1)) && (Yi < Y(end))
    Zsize1 = size(Z);
    for row = 1:Zsize1(1,1)
        x = X;
        y = Z(row,:);
        xi = Xi;
        temp1(row) = interp1(x,y,xi,'cubic','extrap');
    end
    X = cat(2,X,Xi);
    Z = cat(2,Z,temp1');
    Zi = interp2(X,Y,Z,Xi,Yi);
    
elseif (Xi < X(1)) && (Yi > Y(1)) && (Yi < Y(end))
    Zsize1 = size(Z);
    for row = 1:Zsize1(1,1)
        x = X;
        y = Z(row,:);
        xi = Xi;
        temp1(row) = interp1(x,y,xi,'cubic','extrap');
    end
    X = cat(2,Xi,X);
    Z = cat(2,temp1',Z);
    Zi = interp2(X,Y,Z,Xi,Yi);
end