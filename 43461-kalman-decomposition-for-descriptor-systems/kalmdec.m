function [Ek,Ak,Bk,Ck,sizes]=kalmdec(E,A,B,C,flag)

%Program for finding the Kalman decomposition of descriptor systems using
%the geometric approach of (Banaszuk, M. et.al.  Kalman Decomposition for
%Implicit Linear Systems, IEEE transacations on Automatic Control, Vol 37,
%No. 10, Oct. 1992)

%The flag input can be 0 are 1 depending on the method of finding the
%Kalman decomposition subspaces (see explanation below)

%Ali Al-Matouq (Colorado School of Mines)


[n1,n]=size(E);
m=size(B,2);
p=size(C,1);

%Basis vectors for R^n and R^n1 (The space and the co-space)
S0=zeros(n,n);
Sn=eye(n);
Sn1=eye(n1);

%Basis vector for the Input and Output images
ImB=orth(B); kerC=null(C);

%Initializations of the Wong sequences
VB=Sn;RB=S0;
VC=Sn;RC=S0;
V0=Sn;R0=S0;


%Wong sequence for finding the invariant spaces
%(Convergence means dimension of basis remains constant after n iterations)
sizes2=zeros(6,1);r=1;j=0;k=0;
while r==1
    VB=preimage(A,orth([E*VB,ImB]));
    RB=preimage(E,orth([A*RB,ImB]));
    %Note: This is a correction to Banaszuk paper
    VC=intersect2(preimage(A,orth(E*VC)),kerC);
    RC=intersect2(preimage(E,orth(A*RC)),kerC);
    V0=preimage(A,orth(E*V0));
    R0=preimage(E,orth(A*R0));
    sizes=[size(VB,2),size(RB,2),size(VC,2),size(RC,2),size(V0,2),size(R0,2)]';
    if sizes==sizes2 & j==3;
        r=0;
    elseif sizes==sizes2
        j=j+1;
    elseif k==n
        error('Wong sequence did not converge!');
    else
        j=0;
    end
    sizes2=sizes;
    k=k+1;
end

%Reachability and Unoberservability supspaces (F. Lewis)
CB=intersect2(RB,VB);
C0=intersect2(R0,V0);
CC=intersect2(RC,VC);
OC=orth([VC,RC]);

%Finding the subspaces for Kalman decomposition

%1- Controllable and Unobservable Subspaces
X1=intersect2(CB,OC);
Z1=orth([E*X1,A*X1]);

%Method#1 for finding the subspaces X2,X3,X4 and Z1,Z2,Z3
if flag==1
    nX1=null(X1');
    %2- Controllable subspace
    X2=intersect2(CB,nX1);

    %3- Unobservable subspace
    X3=intersect2(OC,nX1);

    X123=[X1,X2,X3];
    %4- Observable Subspace
    X4=null(X123');

    Z1Z2=orth([E*CB,ImB]);
    Z1Z3=orth([E*OC,A*OC]);
    nZ1=null(Z1');
    Z2=intersect2(Z1Z2,nZ1);
    Z3=intersect2(Z1Z3,nZ1);
    Z123=[Z1,Z2,Z3];
    Z4=null(Z123');

%Method#2 (Projection method) for finding the subspaces X2,X3,X4 and Z1,Z2,Z3
elseif flag==0;

    PX1=X1*inv(X1'*X1)*X1';
    X2=orth((eye(n)-PX1)*CB);
    X3=orth((eye(n)-PX1)*OC);
    X123=[X1,X2,X3];
    X4=null(X123');


    Zr=orth([E*CB,ImB]);
    Zr2=orth([E*OC,A*OC]);

    PZ1=Z1*inv(Z1'*Z1)*Z1';
    Z2=orth((eye(n1)-PZ1)*Zr);
    Z3=orth((eye(n1)-PZ1)*Zr2);
    Z123=[Z1,Z2,Z3];
    Z4=null(Z123');

end

%Transformation matrices
P=[Z1,Z2,Z3,Z4];
Q=[X1,X2,X3,X4];


%Kalman decomposition

Ek=inv(P)*E*Q;
Ak=inv(P)*A*Q;
Bk=inv(P)*B;
Ck=C*Q;

%Rounded to the 3rd significant digit
Ek=round(1000*Ek)/1000;
Ak=round(1000*Ak)/1000;
Bk=round(1000*Bk)/1000;
Ck=round(1000*Ck)/1000;

x1=size(X1,2);x2=size(X2,2);x3=size(X3,2);x4=size(X4,2);
z1=size(Z1,2);z2=size(Z2,2);z3=size(Z3,2);z4=size(Z4,2);

%Rounding small values to zero
B1=round(1000*(Bk(1:z1,:)))/1000
B2=round(1000*(Bk(z1+1:z1+z2,:)))/1000
B3=round(1000*(Bk(z1+z2+1:z1+z2+z3,:)))/1000
B4=round(1000*(Bk(z1+z2+z3+1:z1+z2+z3+z4,:)))/1000

C1=round(1000*(Ck(:,1:x1)))/1000
C2=round(1000*(Ck(:,x1+1:x1+x2)))/1000
C3=round(1000*(Ck(:,x1+x2+1:x1+x2+x3)))/1000
C4=round(1000*(Ck(:,x1+x2+x3+1:x1+x2+x3+x4)))/1000







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function V=preimage(A,S)

%A function for calculating a basis of the preimage A^{-1}(Im(S))
%for some matrices A and S (Program by Thomos Berger)

[m1 ,n1]= size(A); [m2 ,n2]= size(S);

if m1==m2
    H=null([A,S]);
    if isempty(H)==0
        V=orth(H(1:n1 ,:));
    else
        V=zeros(n1,0);
    end

else
    error('Both matrices must have same number of rows');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S1capS2=intersect1(S1,S2)

S1=orth(S1);
S2=orth(S2);
dim1=min(size(S1));
dim2=min(size(S2));
S1capS2 = orth(S1*[eye(dim1) zeros(dim1,dim2)]*null([S1,S2]));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U,V,ANG]=intersect2(A,B)
%Function for finding the basis for the space that contains the
%intersect1ion of two subspaces (A,B) (Golub, Van Loan 1996)

[m1,p]=size(A);
[m2,q]=size(B);

if m1~=m2
    error('Both matrices must have same number of rows');
end

if p<q
    AA=B;
    BB=A;
    [m1,p]=size(AA);
    [m2,q]=size(BB);
else
    AA=A;
    BB=B;
end

[QA,RA]=qr(AA,0);
[QB,RB]=qr(BB,0);

C=QA'*QB;

[Y,ANG,Z]=svd(C,0);

U=QA*Y(:,1:q);
V=QB*Z;

s=0;

for i=1:size(ANG,1)
    if ANG(i,i)>0.99 && ANG(i,i)<1.01;
        s=s+1;
    end
end

if s~=0
    U=U(:,1:s);V=V(:,1:s);
else
    U=zeros(m1,0);
    V=zeros(m2,0);
end


