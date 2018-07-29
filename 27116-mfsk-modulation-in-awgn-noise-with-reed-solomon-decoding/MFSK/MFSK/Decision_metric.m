function r_m = Decision_metric(r_mc, r_ms);

%Computes the m'th decision metric for an MFSK system.  (Proakis, p.307)

r_m = sqrt(r_mc^2 + r_ms^2);