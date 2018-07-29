function vol = backprojection(proj,param,angle_rad)

vol = zeros(param.nx,param.ny,param.nz,'single');

[uu,vv] = meshgrid(-param.us,param.vs);

w = (param.DSD)./sqrt((param.DSD)^2+uu.^2 + vv.^2);
proj = proj.*w';

if strcmp(param.filter,'ram-lak') || strcmp(param.filter,'shepp-logan') || strcmp(param.filter,'cosine') || strcmp(param.filter,'hamming') || strcmp(param.filter,'hann')
    
    d = 1;

    filt = Filter(param.filter, param.nu, d);
    
    fproj = zeros(length(filt),param.nv);
    
    fproj(end/2-param.nu/2:end/2+param.nu/2-1,:) = (proj);
    
    fproj = fft(fproj);
    
    for iv = 1:param.nv
        fproj(:,iv) = fproj(:,iv).*filt';
    end
    
    fproj = real(ifft(fproj));
    
    proj = fproj(end/2-param.nu/2:end/2+param.nu/2-1,:)/2/param.du*(2*pi/param.nProj);

end


[xx,yy] = meshgrid(param.xs,param.ys);

rx = xx.*cos(angle_rad-pi/2) + yy.*sin(angle_rad-pi/2);
ry = -xx.*sin(angle_rad-pi/2) + yy.*cos(angle_rad-pi/2);

pu = rx.*(param.DSD)./(ry + param.DSO);

for iz = 1:param.nz   
    
    pv = param.zs(iz)*(param.DSD)./(ry + param.DSO);
    
    vol(:,:,iz) = interp2(uu,vv ,proj',pu,pv,'linear');
    
end

vol(isnan(vol))=0;

return


function filt = Filter(filter, len, d)

order = max(64,2^nextpow2(2*len));

filt = 2*( 0:(order/2) )./order;
w = 2*pi*(0:size(filt,2)-1)/order;   % frequency axis up to Nyquist 

switch lower(filter)
    case 'ram-lak'
        % Do nothing
    case 'shepp-logan'
        % be careful not to divide by 0:
        filt(2:end) = filt(2:end) .* (sin(w(2:end)/(2*d))./(w(2:end)/(2*d)));
    case 'cosine'
        filt(2:end) = filt(2:end) .* cos(w(2:end)/(2*d));
    case 'hamming'  
        filt(2:end) = filt(2:end) .* (.54 + .46 * cos(w(2:end)/d));
    case 'hann'
        filt(2:end) = filt(2:end) .*(1+cos(w(2:end)./d)) / 2;
    otherwise
        filter
        error('Invalid filter selected.');
end

filt(w>pi*d) = 0;                      % Crop the frequency response
filt = [filt , filt(end-1:-1:2)];    % Symmetry of the filter
return

















