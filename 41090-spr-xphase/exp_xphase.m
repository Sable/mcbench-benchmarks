% Primary execution function for multilayer reflectance transfer matrix thin film optics.
% Send it Epsilon, phiRange, wRange, and d:
% Epsilon: (Complex) Dielectric functions of each layer
% phiRange: Angle range, in degrees
% wRange: Frequency range, in 1/cm
% d: Layer thicknesses (First layer ignored, assumed bulk)

function R_mat=exp_xphase(Epsilon,phiRange,wRange,d)

RpEng=zeros(size(phiRange,2),length(wRange));
RsEng=zeros(size(phiRange,2),length(wRange));
R_mat=zeros(size(phiRange,2),length(wRange));

function tp=transf_p(epsilon_j,epsilon_k,epsilon_1,phi)
% calculates transfer matrix for p-polarized light going from phase j to
% phase k using only the indexes of refraction
n_j=sqrt(epsilon_j-epsilon_1*sind(phi)^2);
n_k=sqrt(epsilon_k-epsilon_1*sind(phi)^2);
a=.5*(1+n_k*epsilon_j/(n_j*epsilon_k)); 
b=.5*(1-n_k*epsilon_j/(n_j*epsilon_k));
tp=[a b;b a];
end

function ts=transf_s(epsilon_j,epsilon_k,epsilon_1,phi)
% calculates transfer matrix for s-polarized light going from from phase j
% to phase k using only the indexes of refraction
n_j=sqrt(epsilon_j-epsilon_1*sind(phi)^2);
n_k=sqrt(epsilon_k-epsilon_1*sind(phi)^2);
a=.5*(1+n_k/n_j); 
b=.5*(1-n_k/n_j);
ts=[a b;b a];
end

function propag=prop(epsilon_j,epsilon_1,w,theta,d)
%calculate propagation matrix throuh phase j
k=w*2*pi*sqrt(epsilon_j-epsilon_1*sind(theta)^2);
e1=exp(1i*k*d*1e-7);
propag=[1/e1 0;0 e1];
end

function Mp=mat_p(Epsilon,phi1,wcm,d)
%calculates product matrix for p-polarized light
Tp=zeros(2,2,size(Epsilon,1)-1);
P=zeros(2,2,size(Epsilon,1)-1);
Tp(:,:,1)=transf_p(Epsilon(1),Epsilon(2),Epsilon(1),phi1);
Mp=Tp(:,:,1);
for m=2:size(Epsilon,1)-1
    Tp(:,:,m)=transf_p(Epsilon(m),Epsilon(m+1),Epsilon(1),phi1);
    P(:,:,m)=prop(Epsilon(m),Epsilon(1),wcm,phi1,d(m));
    Mp=Mp*P(:,:,m)*Tp(:,:,m);
end
end

function Ms=mat_s(Epsilon,phi1,wcm,d)
%calculates product matrix for s-polarized light
Ts=zeros(2,2,size(Epsilon,1)-1);
P=zeros(2,2,size(Epsilon,1)-1);
Ts(:,:,1)=transf_s(Epsilon(1),Epsilon(2),Epsilon(1),phi1);
Ms=Ts(:,:,1);
for m=2:size(Epsilon,1)-1
    Ts(:,:,m)=transf_s(Epsilon(m),Epsilon(m+1),Epsilon(1),phi1);
    P(:,:,m)=prop(Epsilon(m),Epsilon(1),wcm,phi1,d(m));
    Ms=Ms*P(:,:,m)*Ts(:,:,m);
end
end

wIndex=1;
for wcm=wRange
    phiIndex=1;
    if size(phiRange,1)==1
        for phi1=phiRange
            Matp=mat_p(Epsilon(:,wIndex),phi1,wcm,d);
            Mats=mat_s(Epsilon(:,wIndex),phi1,wcm,d);
            rp=Matp(2,1)/Matp(1,1);
            rs=Mats(2,1)/Mats(1,1);
            RpEng(phiIndex,wIndex)=(abs(rp^2));
            RsEng(phiIndex,wIndex)=(abs(rs^2));
            R_mat(phiIndex,wIndex)=RpEng(phiIndex,wIndex)/RsEng(phiIndex,wIndex);
            phiIndex=phiIndex+1;
        end
    else
        for phi1=phiRange(wIndex,:)
            Matp=mat_p(Epsilon(:,wIndex),phi1,wcm,d);
            Mats=mat_s(Epsilon(:,wIndex),phi1,wcm,d);
            rp=Matp(2,1)/Matp(1,1);
            rs=Mats(2,1)/Mats(1,1);
            RpEng(phiIndex,wIndex)=(abs(rp^2));
            RsEng(phiIndex,wIndex)=(abs(rs^2));
            R_mat(phiIndex,wIndex)=RpEng(phiIndex,wIndex)/RsEng(phiIndex,wIndex);
            phiIndex=phiIndex+1;
        end
    end
    wIndex=wIndex+1;
end
end

% 
% phiIndex=1;
% trunc=2.0;
% for phi1=phi1Start:phi1Incr:phi1End
%     wIndex=1;
%     for wcm=wStart:wIncr:wEnd
%         R_mat(phiIndex,wIndex)=RpEng(phiIndex,wIndex)/RsEng(phiIndex,wIndex);
%         %Truncate Data
% %         if R_mat(phiIndex,wIndex)>trunc
% %             R_mat(phiIndex,wIndex)=trunc;
% %         end
%         wIndex=wIndex+1;
%     end
%     phiIndex=phiIndex+1;
% end

