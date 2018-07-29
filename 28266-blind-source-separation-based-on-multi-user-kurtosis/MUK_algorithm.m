function [estimated_sources,estimated_channel]=MUK_algorithm(received_signal,nt,mu,kurt_sign)

%HELP MUK_Algorithm
%
%Blind source Separation based on Multiuser Kurtosis Maximisation
%
%Input:     received_signal Y (nr*N matrix)
%           number of sources nt (nt<nr)
%           (optional) mu: step size (default 2*10^-3)
%           (optional) kurt_sign: sign of the kurtosis (default 1);
%Sorties:   Estimated sources X (nt*N matrix)
%           Estimated channel Matrix H (nr*nt) 
%
%Example:   
%           source_number_detection_PET(Y,1)
%
%Reference: [PAP00] Papadias CB "Globally Convergent Blind Source Separation 
%Based on a Multiuser Kurtosis Maximization Criterion", IEEE Transactions 
%on Signal Processing, 48(12), pp 3508-3519 2000.
%
%Programmed by: Vincent Choqueuse

[nr,length_signal]=size(received_signal);
%Algorithm Parameter
if nargin <3
   mu=2*10^(-2);    %step size
   kurt_sign=-1;    %depends on the distribution of the source (=-1 for most of the digital constellation)
end

%-------------------------------------------%
%   Perform Principal Component Analysis    %
%-------------------------------------------%

R=received_signal*received_signal'/length_signal;           %compute correlation matrix
[U,V]=eig(R);                                               %perform eignevalue decomposition
[V_sorted,index_sorted]=sort(diag(V),'descend');            %sort the eigenvalues in the decreasing order
V_reduced=diag(V_sorted(1:nt));                             %keep the largest eigenvalues
U_reduced=U(:,index_sorted(1:nt));                          %keep the eigenvectors associated the the largest eigenvalues
whitened_data=V_reduced^(-1/2)*U_reduced'*received_signal;  %extract whitened data

%-------------------------------------------%
%      Perform Kurtosis maximisation        %
%-------------------------------------------%

k=1;
W=eye(nt);
for k=1:length_signal
    Yk=whitened_data(:,k);
    z_k=W.'*Yk;
    Z_k=((abs(z_k).^2).*z_k).';
    
    %update W with gradient descent
    W_prime=W+mu*kurt_sign*conj(Yk)*Z_k;
    
    %Apply Unitary Constraint (Gram-Schmidt orthogonalization)
    clear W_new;
    W_new(:,1)=W_prime(:,1)/sqrt(sum(abs(W_prime(:,1)).^2));

    for column_index=2:nt
        first_term=(W_new(:,1:column_index-1))'*W_prime(:,column_index);
        numerator=W_prime(:,column_index)-...
                  sum(repmat(first_term.',nt,1).*W_new(:,1:column_index-1),2);
        denominator=sqrt(sum(abs(numerator).^2));
        W_new(:,column_index)=numerator/denominator;
    end    
    W=W_new;
end

estimated_sources=W.'*whitened_data;
estimated_channel=U_reduced*V_reduced^(1/2)*conj(W);




