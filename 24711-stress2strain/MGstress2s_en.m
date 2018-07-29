function [DEps, i, a]=MGstress2s_en(Sig_start, Dsig, i, a, mate);

%Function [DEps, i, a]=MGstress2s_en(Sig_start, Dsig, i, a, mate);
%calculates total strain increments 'DEps' from stress increments 'DSig'
%using: current stress state 'Sig_start', back stresses 'a', 
%material properties included in structure 'mate', and current (active)
%yield surface 'i'. 
%
%Data structure:
%Dsig=[xx yy zz xy xz zx yx zy xz] - order of stress tensor components
%Sig_start=[xx yy zz xy xz zx yx zy xz]
%DEps=[xx yy zz xy xz zx yx zy xz] - oreder of strain tensor components
%i - number of current (active) yield (plasticity) surface 
%a(1:length(mate.R),9)=[xx yy zz xy xz zx yx zy xz] - back stress in
%deviatoric space
%mate.H(1:length(mate.R)) - modules of plasticity surfaces (deviatoric space)
%length(mate.R)- number of plasticity surfaces
%mate.R - radius of plasticity surfaces 
%mate - material data
%
%Numbers of equations according to:
%Garud Y. S., A new approach to the evaluation of fatigue under multiaxial loadings,
%Transactions of the ASME 103, 1981, pp. 118-125.
%
%
%   Copyright (c) 2007 by Aleksander Karolczuk.


if Dsig*Dsig'==0
    DEps(1:9)=0;
else
    error(nargchk(5,5,nargin))
    if size(Sig_start,2)~=9
        error('Improper matrix dimension Sig_start')
    end
    if size(Dsig,2)~=9
        error('Improper matrix dimension Sig_end')
    end

    if size(i,1)~=1 | size(i,2)~=1
        error('i must be scalar')
    end
    if size(a,1)~=length(mate.R) | size(a,2)~=9
        error('Improper matrix dimension a')
    end
    if size(mate.H,2)~=1 | size(mate.H,1)~=length(mate.R)-1
        error('Improper matrix dimension CC')
    end
    if size(mate.R,2)~=1
        error('Improper matrix dimension mate.R')
    end
    if i>length(mate.R)
        error('The number of plasticity surfaces: length(mate.R) is too small')
    end

    %---reassembly of material data-----------------------%
    E=mate.E;
    ni=mate.ni;
    G=E/(2*(1+ni));
    C=mate.H;
    R=mate.R;
    %-----------------------------------------------------%

    %--convert to deviatoric space ----------------------------------%
    Ddev_Sig=dev(Dsig);
    dev_Sig_start=dev(Sig_start);
    %----------------------------------------------------------------%

    %--initial normal vector n computation---------------------------%
    n=nn(dev_Sig_start, a, i);
    %----------------------------------------------------------------%

    %--checking the unloading condition----------------------------------------%
    [n ,i]=PlasticityCond(i, Ddev_Sig, n);

    %--initial value of points A(start) and C(end)-----------------------------%
    AB_strain_p=zeros(1,9);
    A_dew=dev_Sig_start;
    C_dew=A_dew+Ddev_Sig;
    %--------------------------------------------------------------------------%

    %--The loop while-end check if a new point C of stress lay outside of the active plasticity surface-------------------%
    %-- if yes then the point B of intersection and new parameters of a new active plasticity surface i=i+1 are computed
    %--point A becomes point B -----------------%
    while F(C_dew, a(i+1,:))>R(i+1)^2 			             %intersect of plas. i+1?
        A_dew=verify_A(A_dew, a(i+1,:), R(i+1));
        [B_dew]=intersection(A_dew, C_dew, a(i+1,:), R(i+1));%point B of intersection
        AB_dew=B_dew-A_dew;
        a=ShiftSurfaces(a, i, AB_dew, A_dew, R, 1);			 %shift of plas. surfaces
        AB_strain_p=AB_strain_p+Delta_Strain_p(AB_dew, i, n, C); %plastic strain increments

        A_dew=B_dew;                                  		  %point A becomes the new point B
        i=i+1;                                                %nowy indeks aktywnej pow. plastycznosci
        n=nn(A_dew, a, i);                                    %nowy wektor n do aktywnej pow. plastycznosci
    end
    %-------------------------------------------------------------------------------------------------------------------%

    %--final stage, point C is inside the i+1 plas. surface, (load uptp point C)--------%
    AC_dew=C_dew-A_dew;

    a=ShiftSurfaces(a, i, AC_dew, A_dew, R);
    AC_strain_p=Delta_Strain_p(AC_dew, i, n, C);

    DEps_p=AB_strain_p+AC_strain_p;
    DEps_e=hooklaw(Dsig, 'stress_strain', E, ni);

    DEps=DEps_e+DEps_p;
end
%-------------------------------------------------------------------------------------------------------------------%

%------------------------------------------------------------------%
%Plastic strain increments (flow rule)			 	   %
%------------------------------------------------------------------%
function D_strain_p=Delta_Strain_p(D_dew, i, n, C);

if i>0
   D_strain_p=(1/C(i))*(n*D_dew')*n;
else
   D_strain_p=zeros(1,9);
end

%--------------------------------------------------------------------%
%Function PlasticityCond check if the increment of deviatoric stress %
%results in loading or unlloading                                    %
%--------------------------------------------------------------------%
function [n ,i]=PlasticityCond(i, Delta, n);

if i>0
%    if (n*(Delta)')/norm(Delta)<0.03 & (n*(Delta)')/norm(Delta)>-0.03,%warunek stycznosci
%       warning('The increment of loading almost tangential')
%    end

   if n*(Delta)'<0
		i=0;
   	    n=[];
   end
else
    n=n;
    i=i;
end

%------------------------------------------------------------------%
%Yield function: Von Mises y=(3/2)*(s-a(i,:))*(s-a(i,:))'                                             %
%------------------------------------------------------------------%
function y=F(s, aa)

y=(3/2)*(s-aa)*(s-aa)';

%------------------------------------------------------------------------%
%Function ShiftSurfaces calculates new back stresses                     %
%where:                                                                  %
%	 Ds_pl - plastic strain increments                                 	 %
%	 a(i), a(i+1) - back stresess                                        %
%------------------------------------------------------------------------%
function a=ShiftSurfaces(a, i, AB_dew, A_dew, R, flag)

if i>0 & norm(AB_dew)~=0,
    if nargin==6
        k=1.0;   
        d=(1-R(i)/R(i+1))*(A_dew-a(i+1,:)+k*AB_dew)+(a(i+1,:)-a(i,:));
        p=1.0;
    else
        %coefficient k, eq. (24)
        w(1)=AB_dew*AB_dew'; w(2)=2*(A_dew-a(i+1,:))*(AB_dew'); w(3)=(A_dew-a(i+1,:))*(A_dew-a(i+1,:))'-(2/3)*R(i+1)^2;
        k=roots(w); k=max(k); k=k(1);
        %vector d,      eq. (23)
        d=(1-R(i)/R(i+1))*(A_dew-a(i+1,:)+k*AB_dew)+(a(i+1,:)-a(i,:));
        %coefficient p, eq. (25)
        w(1)=d*d'; w(2)=-2*((A_dew+AB_dew-a(i,:))*d'); w(3)=(A_dew+AB_dew-a(i,:))*(A_dew+AB_dew-a(i,:))'-(2/3)*R(i)^2;
        p=roots(w); 
        if isempty(p),
            p=0;
        else
            p=min(p); p=p(1);
        end
        if ~isreal(p),
            p=0
        end
    end
    %Shift Da of plasticity surfaces Ri,         eq. (22)
    Da=p*d;
    %New back stresses
    a(i,:)=a(i,:)+Da;
    for r=1:i-1
        B_dew=A_dew+AB_dew;           %ss i.e. s' or P'
        Da(r,:)=B_dew-(R(r)/R(i))*(B_dew-a(i,:))-a(r,:); %eq. (26)
        a(r,:)=a(r,:)+Da(r,:);
    end
else
    %a=a;
end

%-------------------------------------------------------------------%
%Vector normal to yield surfaces, n                            %
%-------------------------------------------------------------------%
function n=nn(A_dew, a, i);

if i>0
    n=(A_dew-a(1,:))/norm(A_dew-a(1,:));   %eq. (20)
else
   n=[];
end

%--------------------------------------------------------------------%
%Point of intersection between increment of stress and yield surface, B      %
%--------------------------------------------------------------------%
function [B_dew, k0]=intersection(DewLower, DewHigher, aa, RR);

w(1)=(DewHigher-DewLower)*(DewHigher-DewLower)'; w(2)=2*(DewLower-aa)*(DewHigher-DewLower)'; w(3)=(DewLower-aa)*(DewLower-aa)'-(2/3)*RR^2;
k0=roots(w); k0=max(k0); k0=k0(1);
B_dew=DewLower+k0*(DewHigher-DewLower);

%---------------------------------------------------------------------------%
%Verification of point A location,  
%---------------------------------------------------------------------------%
function A_dew=verify_A(A_dew, aa, RR);

delta=(1e-012)*(A_dew-aa);

if F(A_dew, aa)-RR^2>=0,
    %dif1=F(A_dew, aa)-RR^2;
    [A_dew]=intersection(aa, A_dew, aa, RR);
    A_dew=A_dew-delta;
    %dif2=F(A_dew, aa)-RR^2;
else
    %A_dew=A_dew;
end