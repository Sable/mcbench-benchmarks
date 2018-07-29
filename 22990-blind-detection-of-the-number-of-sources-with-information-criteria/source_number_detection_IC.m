function [nb_sources]=source_number_detection_IC(received_signal,criterion,display)

%HELP source_number_detection_IC
%
%Detection of the number of sources with information criteria. The method
%assumes that the noise is spatially white.
%
%Input:     received_signal
%           criterion ('Akaike' or 'MDL')
%           (optional) Display criterion if non empty
%Sorties:   nb_sources
%
%Example:   X=randn(3,500); %3 sources
%           H=randn(10,3)+i*randn(10,3); %10 receivers
%           B=2*(randn(10,500)+i*randn(10,500));
%           Y=H*X+B; %MIMO Mixing Model
%           source_number_detection_IC(Y,'MDL',1)
%
%Reference: [WAX85] Wax, M. and Kailath, T., "Detection of signals by information
%theoretic criteria", IEEE Transactions on Acoustics, Speech and Signal
%Processing, 1985.


[Nb_receivers,Nb_samples]=size(received_signal);
%Computation of the covariance matrix
covariance=received_signal*received_signal'/Nb_samples;
%eigenvalue decomposition
[U,V]=eig(covariance);
%sort the eigenvalue in the decreasing order
eigenvalues=sort(diag(V),'descend');


%Compute criterion
for k=0:Nb_receivers-1
    coef=1/(Nb_receivers-k);
    a=coef*sum(eigenvalues(k+1:Nb_receivers));
    g=prod(eigenvalues(k+1:Nb_receivers)).^(coef); 
    akaike_criterion(k+1)=-log(((g/a)^(Nb_samples*(Nb_receivers-k))))+k*(2*Nb_receivers-k); 
    MDL_criterion(k+1)=-log(((g/a)^(Nb_samples*(Nb_receivers-k))))+0.5*k*(2*Nb_receivers-k)*log(Nb_samples);
end    

switch criterion
    case 'AIC'
        criterion_value=akaike_criterion;
    case 'MDL' 
        criterion_value=MDL_criterion;
end
[criterion_value_min,nb_sources]=min(criterion_value);
nb_sources=nb_sources-1; %retrieve 1 because the value k=0 is stocked in the index 1.

if nargin > 2
   plot(0:Nb_receivers-1,criterion_value);
   grid;
   hold on
   plot(nb_sources,criterion_value_min,'ro');
   hold off
   ylabel('Criterion value')
   xlabel('Number of sources')
end  

%Created by: Vincent Choqueuse, PhD (vincent.choqueuse@gmail.com)

    
    
    