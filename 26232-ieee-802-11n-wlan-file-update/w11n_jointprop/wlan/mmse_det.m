function [dataout] = mmse_det(ch_and_rx)
% mmse_det  User-defined function for MMSE detector.
% Input: 'ch_and_rx'
%    - first elements are MIMO parameters (STBC, Nss, etc.)
%    - next 16*NST elements are channel estimates.
%    - next (NSTS+1)*NST elements are reference training symbols.
%    - next (NSTS+1)*NST elements are received training symbols.
%    - remaining x*NST elements are received data symbols.
% Output: 'detout'
%    - x*NST elements are MMSE detector outputs.
%    - x*NST elements are Viterbi metric weights.
global PER_snr snr_idx ch_type;

% Initialize vectors
Clk = ch_and_rx(1);
STBC = ch_and_rx(2);
Nss  = ch_and_rx(3);
Nsts = Nss + STBC;
Nltf = Nsts;
if (Nsts==3) % use 4 TRN symbols for NSTS=3
   Nltf = 4;
end

Nrx  = ch_and_rx(4);
ch_est  = ch_and_rx(4+(1:16*56));
ref_trn = ch_and_rx(4+16*56+(1:4*56*(Nltf)));
rx_trn  = ch_and_rx(4+16*56+4*56*(Nltf)+(1:4*56*(Nltf)));
rx_data = ch_and_rx((5+16*56+2*4*56*(Nltf)):end);

%%%% Form channel matrix
idx = 0;
H = zeros(4,4,56);
for c=1:4
    for r=1:4
        H(r,c,:) = ch_est(idx+(1:56));
        idx=idx+56;
    end
end
H = H(1:Nrx,1:Nsts,:);  %% channel matrix is Nrx x Nsts

%%%% Train data symbols...
idx = 0;
nsymtrn = (length(ref_trn)/4/56);
trnRef = zeros(Nrx,56,nsymtrn);
for n=1:nsymtrn
    for m=1:Nsts
        trnRef(m,:,n) = ref_trn(idx+(m-1)*56+(1:56));
        trnRx(m,:,n)  =  rx_trn(idx+(m-1)*56+(1:56));
    end
    idx=idx+4*56;
end

%%%% Rx data symbols...
idx = 0;
nsymdata = (length(rx_data)/4/56);
rdata = zeros(4,56,nsymdata);
for n=1:nsymdata
    for m=1:Nrx
        rdata(m,:,n) = rx_data(idx+(m-1)*56+(1:56));
    end
    idx=idx+4*56;
end

%%%%
%%%% STBC or MMSE detection...
%%%%
if (STBC)    
    %%%% Form space-time decoding matrices
    for k=1:56
        if (STBC==1 && Nss==1)
            % Heff matrix (assumes channel stationary for 2 symbols)
            Heff(:,:,k) = [      H(1,1,k)      -H(1,2,k); ...  
                            conj(H(1,2,k)) conj(H(1,1,k)) ];  
        elseif (STBC==1 && Nss==2)
            % Heff matrix (assumes channel stationary for 2 symbols)
            Heff(:,:,k) = [      H(1,1,k)      -H(1,2,k)       H(1,3,k)              0;  ...  
                            conj(H(1,2,k)) conj(H(1,1,k))             0  conj(H(1,3,k)); ...  
                                 H(2,1,k)      -H(2,2,k)       H(2,3,k)              0;  ...
                            conj(H(2,2,k)) conj(H(2,1,k))             0  conj(H(2,3,k)) ];  
        elseif (STBC==1 && Nss==3)
            % Heff matrix (assumes channel stationary for 2 symbols)
            Heff(:,:,k) = [      H(1,1,k)      -H(1,2,k)       H(1,3,k)              0        H(1,4,k)              0;  ...  
                            conj(H(1,2,k)) conj(H(1,1,k))             0  conj(H(1,3,k))              0  conj(H(1,4,k)); ...  
                                 H(2,1,k)      -H(2,2,k)       H(2,3,k)              0        H(2,4,k)              0;  ...
                            conj(H(2,2,k)) conj(H(2,1,k))             0  conj(H(2,3,k))              0  conj(H(2,4,k)); ...  
                                 H(3,1,k)      -H(3,2,k)       H(3,3,k)              0        H(3,4,k)              0;  ...
                            conj(H(3,2,k)) conj(H(3,1,k))             0  conj(H(3,3,k))              0  conj(H(3,4,k)) ];  
        elseif (STBC==2 && Nss==2)
            % Heff matrix (assumes channel stationary for 2 symbols)
            Heff(:,:,k) = [      H(1,1,k)      -H(1,2,k)       H(1,3,k)      -H(1,4,k);  ...  
                            conj(H(1,2,k)) conj(H(1,1,k)) conj(H(1,4,k)) conj(H(1,3,k)); ...
                                 H(2,1,k)      -H(2,2,k)       H(2,3,k)      -H(2,4,k);  ...
                            conj(H(2,2,k)) conj(H(2,1,k)) conj(H(2,4,k)) conj(H(2,3,k)) ];  
        end
    end

    %%%% Compute noise power...
    N_o = 0;
    for k=1:56
        He = Heff(:,:,k);
        N_o = N_o + (1/56)*sum(sum(He.*conj(He)))/Nrx;     % Signal power
    end
    snr_val = PER_snr(snr_idx);
    N_o = N_o * 10^(-snr_val/10);     % Adjust by SNR
    
    %%%% Compute space-time detector coeff's
    C = zeros(Nss*2,Nss*2,56);
    for k=1:56
        %%%% MMSE coeff's
        He = Heff(:,:,k);
        C(:,:,k) = inv(He'*He + N_o*eye(Nss*2))*He';
    end
    
    %%%% Compute space-time decoding outputs, Viterbi metric weights
    idx = 0;
    detout = zeros(4*56*nsymdata,1);
    metout = zeros(4*56*nsymdata,1);
    for n=1:2:nsymdata
        for k=1:56
            if (STBC==1 && Nss==1)
                % MMSE detector outputs
                detset = C(:,:,k) * [ rdata(1,k,n); ...
                                      conj(rdata(1,k,n+1)) ];
                detout(k+idx+0*56) = detset(1);         % first symbol in time, ss1
                detout(k+idx+4*56) = conj(detset(2));   % second symbol in time, ss1
                % Viterbi metric weights
                metset = eps+abs(1-diag(C(:,:,k)*Heff(:,:,k)));
                metout(k+idx+0*56) = 1/metset(1);
                metout(k+idx+4*56) = 1/metset(2);
            elseif (STBC==1 && Nss==2)
                % MMSE detector outputs
                detset = C(:,:,k) * [ rdata(1,k,n); ...
                                      conj(rdata(1,k,n+1)); ...
                                      rdata(2,k,n); ...
                                      conj(rdata(2,k,n+1)) ];
                detout(k+idx+0*56) = detset(1);         % first symbol in time, ss1
                detout(k+idx+4*56) = conj(detset(2));   % second symbol in time, ss1
                detout(k+idx+1*56) = detset(3);         % first symbol in time, ss2
                detout(k+idx+5*56) = conj(detset(4));   % second symbol in time, ss2
                % Viterbi metric weights
                metset = eps+abs(1-diag(C(:,:,k)*Heff(:,:,k)));
                metout(k+idx+0*56) = 1/metset(1);
                metout(k+idx+4*56) = 1/metset(2);
                metout(k+idx+1*56) = 1/metset(3);
                metout(k+idx+5*56) = 1/metset(4);
            elseif (STBC==1 && Nss==3)
                % MMSE detector outputs
                detset = C(:,:,k) * [ rdata(1,k,n); ...
                                      conj(rdata(1,k,n+1)); ...
                                      rdata(2,k,n); ...
                                      conj(rdata(2,k,n+1)); ...
                                      rdata(3,k,n); ...
                                      conj(rdata(3,k,n+1)) ];
                detout(k+idx+0*56) = detset(1);         % first symbol in time, ss1
                detout(k+idx+4*56) = conj(detset(2));   % second symbol in time, ss1
                detout(k+idx+1*56) = detset(3);         % first symbol in time, ss2
                detout(k+idx+5*56) = conj(detset(4));   % second symbol in time, ss2
                detout(k+idx+2*56) = detset(5);         % first symbol in time, ss3
                detout(k+idx+6*56) = conj(detset(6));   % second symbol in time, ss3
                % Viterbi metric weights
                metset = eps+abs(1-diag(C(:,:,k)*Heff(:,:,k)));
                metout(k+idx+0*56) = 1/metset(1);
                metout(k+idx+4*56) = 1/metset(2);
                metout(k+idx+1*56) = 1/metset(3);
                metout(k+idx+5*56) = 1/metset(4);
                metout(k+idx+2*56) = 1/metset(5);
                metout(k+idx+6*56) = 1/metset(6);
            elseif (STBC==2 && Nss==2)
                % MMSE detector outputs
                detset = C(:,:,k) * [ rdata(1,k,n); ...
                                      conj(rdata(1,k,n+1)); ...
                                      rdata(2,k,n); ...
                                      conj(rdata(2,k,n+1)) ];
                detout(k+idx+0*56) = detset(1);         % first symbol in time, ss1
                detout(k+idx+4*56) = conj(detset(2));   % second symbol in time, ss1
                detout(k+idx+1*56) = detset(3);         % first symbol in time, ss2
                detout(k+idx+5*56) = conj(detset(4));   % second symbol in time, ss2
                % Viterbi metric weights
                metset = eps+abs(1-diag(C(:,:,k)*Heff(:,:,k)));
                metout(k+idx+0*56) = 1/metset(1);
                metout(k+idx+4*56) = 1/metset(2);
                metout(k+idx+1*56) = 1/metset(3);
                metout(k+idx+5*56) = 1/metset(4);
            end
        end
        idx=idx+8*56;
    end

else

    %%%% Compute noise power...
    N_o = 0;
    for k=1:56
        He = H(:,:,k);
        N_o = N_o + (1/56)*sum(sum(He.*conj(He)))/Nrx;     % Signal power
    end
    snr_val = PER_snr(snr_idx);
    N_o = N_o * 10^(-snr_val/10);     % Adjust by SNR
    
    %%%%% MMSE linear detector (no STBC)
    C = zeros(Nsts,Nrx,56);
    for k=1:56
        %%%% MMSE coeff's
        He = H(:,:,k);
        C(:,:,k) = inv(He'*He + N_o*eye(Nrx)) * He';        
    end

    %%%% MMSE detector outputs, Viterbi metric weights
    idx = 0;
    detset = zeros(4,1);
    detout = zeros(4*56*nsymdata,1);
    metset = eps+zeros(4,1);
    metout = zeros(4*56*nsymdata,1);
    for n=1:nsymdata
        for k=1:56
            % MMSE detector outputs
            detset(1:Nsts) = C(:,:,k)*rdata(1:Nrx,k,n);
            detout(k+idx+0*56) = detset(1);
            detout(k+idx+1*56) = detset(2);
            detout(k+idx+2*56) = detset(3);
            detout(k+idx+3*56) = detset(4);
            % Viterbi metric weights
            metset(1:Nsts) = eps+abs(1-diag(C(:,:,k)*H(:,:,k)));
            metout(k+idx+0*56) = 1/metset(1);
            metout(k+idx+1*56) = 1/metset(2);
            metout(k+idx+2*56) = 1/metset(3);
            metout(k+idx+3*56) = 1/metset(4);
        end
        idx=idx+4*56;
    end
    
end

% Adjust metric scaling range (0 - least confident, 7 - most confident)
% (based on use of 4-bit data, soft decisions, for Viterbi module) 
max_metout = max(metout(find(metout<1e14)));
log_metout = log(metout + 1e-6);
log_max_metout = log(max_metout + 1e-6);
metout = floor(7.99 * log_metout/log_max_metout);
metout = (metout >= 7).*7 + (metout < 7).*metout;


% MMSE module output
dataout = [detout; metout];
