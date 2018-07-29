function [sos,g]=tf2dspiciirc(b,a,filename)
%TF2DSPICIIRC Transfer Function to DSPic IIR Canonic coefficients.
%   [SOS,G] = TF2DSPICIIRC(B,A,FILENAME) finds a matrix SOS in second-order 
%   sections form and a gain G (minimizing the probability of overflow in 
%   the realization) which represent the same system H(z) as the one
%   with numerator B and denominator A.  The poles and zeros of H(z)
%   must be in complex conjugate pairs. 
%
%   The DSPic filter definition file is saved as FILENAME.s
%   Do not use special charachter in FILENAME like '/','.','_','%','&'...
% 
%   [SOS,G] are multipied 2^15 and rounded, offering so the possibility to 
%   verify stability, overflow and noise, since the DSPic works with 
%   fractional numbers (fixed point, 16 bit). 
%   Gain or b coefficients have to be divided by 2^15, to obtain
%   practical results.
%
%   No input parameter check is performed, hence try to know what you do.
%
%   TF2DSPICIIRC HAS NOT BEEN TESTED CORRECTLY! IT POSSIBLY HAS BUGS!
% 
;
% Authors:  Louis Moret, Christoph Thurnherr, Marco Minder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision  Author  Date       Comments     
% 0.0       tc,ml   09.10.2004 initial design
% 0.1       ml      10.10.2004 new coeff scaling
% 0.2       ml      12.10.2004 new write routine
% 0.3       ml      13.10.2004 scaling debugged


%====================================================
% coefficient preparation and scaling
%====================================================
% scale using infinity norm scaling in conjunction
% with up ordering to minimize the probability of 
% overflow in the realization

[sos,g] = tf2sos(b,a,'UP',Inf); 

% normalize gain to 1/2
gain = 0.5*g

% setting final shift
finalshift = 0;

[lin col] = size(sos)

% begin for loop ------------------------------------
for k = 1 : lin
    
    a = sos(k,4:6);
    b = sos(k,1:3);
    
%====================================================
%  distribute b coefficient if first order
%====================================================

    if ((b(2) == 0) && (b(3)==0) && (a(3)==0))
        b(2) = b(1);
        b = b/2;
    end
     
%====================================================
% normalize a0 to 1/2
%====================================================

    b    = 0.5*b/a(1);
    a    = 0.5*a/a(1);

%====================================================
% scale coefficients to fractional
%====================================================

    % NOT NEEDED, since coeffs << 1
    %b = 0.5*(b + 1);  % -1 -> 0, 1 -> 1
    %  1 -> 1-2^-15, but 0 (-1) remains 0 (-1)
    %b = b*(1-2^-16);  
    %b = 2*b - 1;

%====================================================
% sorting
%====================================================

coeffs(k,:) = fliplr([b -a(2:3)]);
sos(k,:)    = [b,a];

end
% end for loop --------------------------------------

%====================================================
% convert to integer (15 bit) and round
%====================================================

coeffs      = round(2^15*coeffs);
gain        = round(2^15*gain);
finalshift  = round(2^15*finalshift);

%====================================================
% write filter file 
%====================================================

fid = fopen([filename,'.s'],'w');
fprintf(fid, ';-----------------------------------------------\n');
fprintf(fid, [';   file: ',filename,'.s\n']);
fprintf(fid, ';-----------------------------------------------\n\n');
fprintf(fid, ';   number of filter sections:\n\n\t');
fprintf(fid, ['.equ ',filename,'NumSections, %d\n\n'],lin);
fprintf(fid, ';   initial gain:\n\n\t');
fprintf(fid, ['.equ ',filename,'IniGain, 0x%04X\n\n'],gain); % gain should be posive
fprintf(fid, ';   final shift:\n\n\t');
fprintf(fid, ['.equ ',filename,'FinShift, 0x%04X\n\n'],finalshift);
fprintf(fid, ';   allocate and initialize filter coefficients:\n\n\t');
fprintf(fid, '.section .xdata\n\n');
fprintf(fid, [filename,'Coeffs:\n']);

for k = 1:lin
    fprintf(fid,'\t.hword  ');
    for n = 1:col-1,
        fprintf(fid,'0x');
        if coeffs(k,n)>=0,
             % positive int -> fractional-hex
            fprintf(fid,'%04X',coeffs(n));          
        else
            % negative int -> fractional-hex
            fprintf(fid,'%04X',2^16-abs(coeffs(n))); 
        end
        if n == col-1
            fprintf(fid,' ; %d\n',k);
        else
            fprintf(fid,', ');
        end
    end
end
fprintf(fid,'\n');
fprintf(fid, ';   allocate states buffer in y data space:\n\n\t');
fprintf(fid, '.section .ybss, "b"\n\n');
fprintf(fid, [filename,'States:\n\t']);
fprintf(fid, ['.space ',filename,'NumSections*2*2\n\n']);
fprintf(fid, ';   allocate and initialize filter structure:\n\n\t');
fprintf(fid, '.section .data\n\t');
fprintf(fid, ['.global _',filename,'Filter\n\n_',filename,'Filter:\n\t']);
fprintf(fid, ['.hword ',filename,'NumSections-1\n\t']);
fprintf(fid, ['.hword ',filename,'Coeffs\n\t']);
fprintf(fid, '.hword 0xFF00\n\t');
fprintf(fid, ['.hword ',filename,'States\n\t']);
fprintf(fid, ['.hword ',filename,'IniGain\n\t']);
fprintf(fid, ['.hword ',filename,'FinShift\n\n']);
fprintf(fid, ';-----------------------------------------------\n');
fprintf(fid, [';   file: ',filename,'.s ends here\n']);
fprintf(fid, ';-----------------------------------------------\n');
fclose(fid);


%====================================================
% recalc return values
%====================================================

g   = 2*gain;
sos = round(2^15*sos);