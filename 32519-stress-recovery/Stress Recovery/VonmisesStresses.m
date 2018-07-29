function [vonmises] = VonmisesStresses(stressGP)


% To find the Principal Stresses 
toumax = +sqrt((0.5*(stressGP(:,1)-stressGP(:,2))).^2+stressGP(:,3).^2);
sigma1 = 0.5*(stressGP(:,1)+stressGP(:,2))+toumax ;

toumin = -sqrt((0.5*(stressGP(:,1)-stressGP(:,2))).^2+stressGP(:,3).^2);
sigma2 = 0.5*(stressGP(:,1)+stressGP(:,2))+toumin ;

%shear = [toumax toumin] ;
%principal = [sigma1 sigma2] ;


% To find the Von-Mises stresses
vonmises = sqrt(0.5*((sigma1-sigma2).^2+sigma2.^2+sigma1.^2)) ;
