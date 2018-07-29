function dd=tritrig(a,b,c,A,B,C)
if A==90 | B==90
    'error, right angle can only be C'
    
end
x=0;
if C==90
    if a~=0 & b~=0
        c=sqrt(a^2+b^2);
        A=asind(a/c);
        B=asind(b/c);
        x=1;
        
    end
    if a~=0 & c~=0 & x==0
        b=sqrt(c^2-a^2);
        A=asind(a/c);
        B=asind(b/c);
        x=1;
        
    end
    if b~=0 & c~=0 & x==0
        a=sqrt(c^2-b^2);
        A=asind(a/c);
        B=asind(b/c);
        x=1;
        
    end
    if A~=0 & x==0
        B=90-A;
        if a~=0
            b=a/tand(A);
            c=a/sind(a);
            x=1;
            
        end
        if b~=0 & x==0
            a=tand(A)*b;
            c=b/cosd(A);
            x=1;
            
        end
        if c~=0 & x==0
            a=sind(A)*c;
            b=cosd(A)*c;
            x=1;
            
        end
    end
    if B~=0 & x==0
        A=90-B;
        if a~=0
            b=a/tand(A);
            c=a/sind(a);
            x=1;
            
        end
        if b~=0 & x==0
            a=tand(A)*b;
            c=b/cosd(A);
            x=1;
            
        end
        if c~=0 & x==0
            a=sind(A)*c;
            b=cosd(A)*c;
            x=1;
            
        end
    end
end


if a~=0 & b~=0 & c~=0 & x==0
    A=acosd((b^2+c^2-a^2)/2/b/c);
    B=asind(sind(A)*b/a);
    C=180-A-B;
    x=1;
    
end
if a~=0 & b~=0 & C~=0 & x==0
    c=sqrt(a^2+b^2-2*a*b*cosd(C));
    A=asind(sind(B)*a/b);
    B=asind(sind(A)*b/a);
    x=1;
    
end
if a~=0 & c~=0 & B~=0 & x==0
    b=sqrt(a^2+c^2-2*a*c*cosd(B));
    A=asind(sind(B)*a/b);
    C=180-B-A;
    x=1;
    
end
if b~=0 & c~=0 & A~=0 & x==0
    a=sqrt(b^2+c^2-2*b*c*cosd(A));
    B=asind(sind(A)*b/a);
    C=180-A-B;
    x=1;
    
end
if A~=0 & B~=0 & x==0
    C=180-A-B;
    if a~=0 
        b=sind(B)*a/sind(A);
        c=sind(C)*a/sind(A);
        x=1;
        
    end
    if b~=0 & x==0
        a=sind(A)*b/sind(B);
        c=sind(C)*b/sind(B);
        x=1;
        
    end
    if c~=0 & x==0
        a=sind(A)*c/sind(C);
        b=sind(B)*c/sind(C);
        x=1;
        
    end
end
if A~=0 & C~=0 & x==0
    B=180-A-C;
    if a~=0
        b=sind(B)*a/sind(A);
        c=sind(C)*a/sind(A);
        x=1;
        
    end
    if b~=0 & x==0
        a=sind(A)*b/sind(B);
        c=sind(C)*b/sind(B);
        x=1;
        
    end
    if c~=0 & x==0
        a=sind(A)*c/sind(C);
        b=sind(B)*c/sind(C);
        x=1;
        
    end
end
if B~=0 & C~=0 & x==0
    A=180-B-C;
    if a~=0
        b=sind(B)*a/sind(A);
        c=sind(C)*a/sind(A);
        x=1;
        
    end
    if b~=0 & x==0
        a=sind(A)*b/sind(B);
        c=sind(C)*b/sind(B);
        x=1;
        
    end
    if c~=0 & x==0
        a=sind(A)*c/sind(C);
        b=sind(B)*c/sind(C);
        x=1;
        
    end
end
if x==0
    'not enough information was given'
else
a
b
c
A
B
C
end
%How to use tritrig:
%tritrig is in the form 'tritrig(a,b,c,A,B,C)' where a b c A B C are the
%angles and the lengths of a triangle. If your triangle has a right angle
%in it, it must be 'C' and the hypotenuse must be 'c'. The angles and
%lengths that you do not know must be typed as '0'
%Eg.
%tritrig(3,4,5,0,0,0)
%A = 
%    36.8699
%B=  
%    53.1301
%C=
%    90.0000