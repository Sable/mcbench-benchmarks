function [vol_tmp,H] = iconebeamdemo2007(dir,flprefix,theta,interp,filter,d,N,step,Ro,range_slices,cut)

%   author: Gianni Schena Sept. 2004 (schena@univ.trieste.it - I welcome suggestions !)
%   Reconstructs image/s for cone beam (CB) geometry according to
%   the classical Feldkamp et al. algorithm. Individual slices are stored in a volume 
%
%   FDK10_CB reconstructs the 3D volume image vol from planar projection 
%   data. The routine assumes that the center of rotation
%   is the center point of the projections. 
%
%   THETA describes the angles (in degrees) at which the projections    
%   were taken.  It it is a vector containing angle between 
%   projections. THETA is a vector and must contain angles with 
%   equal spacing between them.  
%
%   The routine uses the filtered backprojection.The filter is designed directly 
%   in the frequency domain and then multiplied by the FFT of the 
%   projections.  The projections are zero-padded to a power of 2 
%   before filtering to prevent spatial domain aliasing and to 
%   speed up the FFT.
%
%   INTERP specifies the type of interpolation to use in the   
%   backprojection.  The available options are listed in order
%   of increasing accuracy and computational complexity:
%
%      'nearest' - nearest neighbor interpolation 
%      'linear'  - linear interpolation (suggested)
%
%   FILTER specifies the filter to use for frequency domain filtering.  
%   FILTER is a string that specifies any of the following standard 
%   filters:
% 
%   'Ram-Lak'     The cropped Ram-Lak or ramp filter (default).  The    
%                 frequency response of this filter is |f|.  Because 
%                 this filter is sensitive to noise in the projections, 
%                 one of the filters listed below may be preferable.   
%   'Shepp-Logan' The Shepp-Logan filter multiplies the Ram-Lak
%                 filter by a sinc function.
%   'Cosine'      The cosine filter multiplies the Ram-Lak filter 
%                 by a cosine function.
%   'Hamming'     The Hamming filter multiplies the Ram-Lak filter 
%                 by a Hamming window.
%   'Hann'        The Hann filter multiplies the Ram-Lak filter by 
%                 a Hann window.
%   
%   D is a scalar in the range (0,1] that modifies the filter by 
%   rescaling its frequency axis.  The default is 1.  If D is less 
%   than 1, the filter is compressed to fit into the frequency range  
%   [0,D], in normalized frequencies; all frequencies above D are set  
%   to 0.
% 
%   N is a scalar that specifies the number of rows and columns in the 
%   reconstructed 2D slice images.  If N is not specified, the size is determined   
%
%   [vol,H] = FDKX... (...) returns also the frequency response of the filter
%   in the vector H.
%
%   Ro is the orbital radius i.e. the distance source to object
%   Ds2dct is the distance between source and planar detector
%   Ds2dct = Ro + Do2dct = Ds2obj + Do2dct 
%   pxlsz is the size of the (square) pixel of the detector dct
%   Class Support : All input arguments must be of class double.  
%   The output arguments are of class double.

%   References: 
%   A. C. Kak, Malcolm Slaney, "Principles of Computerized Tomographic
%   Imaging", IEEE Press 1988. Chapter 3 (available by downloading)

%[p,theta,filter,d,interp,N] = parse_inputs(varargin{:});
thetag=theta;
theta = pi*theta/180; % from degrees to radiants

A=read_1rad(1.,dir,flprefix); % read in image frame
figure , imshow(A,[]); title(' first projection') % disp first image file 


%global flat , global dark

% get size of the data files
[nr_p , nc_p] = size(A) ; % get the number of rows and colums of the data files
% 
range_slices=range_slices(range_slices>-nr_p/2 & range_slices<nr_p/2);
% remove slices out of range
%  N is a scalar that specifies the number of rows and columns in the 
%  reconstructed 2D slice images.  If N is not specified, the size is determined   
%  If the user didn't specify the size of the reconstruction, so 
%  deduce it from the length of projections

% nr_p; % sinogram size i.e. one size of the projection 

if N==0  ||  isempty(N) % if N is not given then ...
    N = 2*floor( nc_p /(2*sqrt(2)) ); % take the default value
end


imgDiag = 2*ceil(N/sqrt(2))+1;  % largest distance through image.

%np = length(theta);
W=pix_weight(nr_p,nc_p,Ro,0,0); % weights to account for a planar detector
%size(W)

% Design the filter H
len=nc_p;
H = designFilter(filter, len, d);
LH=length(H); % length filter in the line vector H

% Define the x & y axes for the reconstructed image so that the origin
xax = (1:N)-ceil(N/2); x = repmat(xax, N, 1);  y= repmat(xax', 1, N);  
%y = rot90(x);   % x coordinates, the y coordinates are rot90(x)
mask= ((x-0).^2+(y-0).^2) <= (N/2).^2 ; % mask the inner circle of diam N
mask=true(N); % no mask : all  the pixels are to be reconstructed
maskV=mask(:); % mask in a vector 

costheta = cos(theta); sintheta = sin(theta);
ctrIdx = ceil(len/2);     % index of the center of the projections (on the hor axis)

% range slices  to be recons
if exist('range_slices','var') & ~isempty(range_slices)
    slices=range_slices; % slices to be recons
    if isempty( find(slices==0) ) % se non c'e' la slice centrale aggiungila 
        slices=[slices ,0];  slices=sort(slices) ;
    end 
else
    % if no slices then recns the slice z=0 only 
    slices=[0];% [-floor(nc_p/2):step:+floor(nc_p/2)];
end
cnt_slc=find(slices==0);
slices

%vol = repmat(0,[N,N,length(slices)]) ;% allocate 3D volume matrix
vol_tmp=repmat(single(0),[(N.^2),length(slices)]); % allocation 
szproj=[nr_p,nc_p;]; % size(proj);
% 

% Filtered Back-projection - i.e. from proj pixel (u,v) to voxel (x,y,z) 
if strcmp(interp, 'nearest neighbor')
    x=x(maskV); y=y(maskV); % mask !
    
    nw_slices = real(sort(complex(slices))) ; % sort and reordering for faster reconstruction
   % eg. +5 -5 + 6 -6 ...it allows to change the sign of v rather than recalculating v
    
    ZFlag= abs(nw_slices(2:end)) == nw_slices(1:(end-1)) ; % logical variable
    ZFlag=real([0, ZFlag] ); % true if +z is followed by -z and one can exploit symmetry
    
    for ipos=1:length(slices) % right positioning the re-orded slices in the volume
        iposz_v(ipos)=find( nw_slices(ipos)== slices) ;  % slice correspondence  
    end
    % data type and array allocation statements    
    proj=repmat(0,nr_p,nc_p);
    tmp=zeros(nnz(mask),1); tmp2=zeros(N.^2,1); % allocate memory to temporary arrays
   % tmp1
    v0=zeros([size(x)]); v1=v0; u1=v1; % u=u1; v=u;
    good_u=logical(v0); idx=zeros(size(v0)); % allocation
    
    for i=1:length(theta) % loop over the projections
       % i
        dgri=thetag(i); % theta in degrees
        
        proj=read_1rad(i,dir,flprefix); % read in the i-th radiograph 
        proj = radio2proj(proj,W,H,len); % tranforms radiog. into projection and multiply by W
        %%%
        proj(:,length(H))=0;  % Zero pad projections for 
        for ir = 1:nr_p; % filtering row  by row  with row vector H
            proj(ir,:)= real (ifft ( fft(proj(ir,:)).*H ) );  % fast frequency domain filtering
        end
        proj(:,len+1:end) = [] ;   % Truncate the filtered projections
        %%%
        s =  x.*costheta(i) + y.*sintheta(i); t = -x.*sintheta(i) + y.*costheta(i); % Goddard & Trepanier
        % s = x.*costheta(i) + y.*sintheta(i); % also in matlab iradon 
        R_s = Ro-s; u=round( Ro*t./(R_s) + ctrIdx) ; % u is the 1st projection pixel coordinate
        good_u = (u>0 & u<(nc_p+1)) ; % only valid pixels -i.e. within the projection frame
        lengoodu=length(good_u);
        u1=u(good_u);%
        inv_R_s_quad=1./(R_s(good_u).^2); Ro_dev_R_s=Ro./(R_s(good_u)); % for generally .* is faster than ./
        iz=0;
        id_1_term=(u1-1)*szproj(1); % does not depend up on v
        for z=nw_slices % for all the (re-ordered) slices 
            iz=iz+1;  % z slice under reconstruction
           if ZFlag(iz)==1; % z symmetry (floting point is faster than logical operators!)
          %  if ( iz>=2 & ( abs(nw_slices(iz)) == nw_slices(iz-1) ) ) % z symmetry
                v0=-v0;   % allows calc time saving
            else %  v is the 2nd proj. pixel coord. (u,v)
                v0=Ro_dev_R_s.*z ;  %
            end
            v1=round( v0+nr_p/2 ) ;  % coord. correction
            %v1=v(good_u);  % logical operations i.e. only valid pixels
            idx = id_1_term + v1 ; % idx = sub2ind(szproj,u1, v1); 
            tmp = proj(idx); % just in case
            tmp = tmp(:).*inv_R_s_quad; % back-projection ... from pixels to voxels ...!
            tmp1(good_u)=tmp; tmp1(lengoodu)=0;% 
            tmp2(maskV)=tmp1; % prepare for image reconst. within the mask
            iposz=iposz_v(iz); % position of the current slice iz in the volume at iposz
            vol_tmp(:,iposz)=vol_tmp(:,iposz)+tmp2; % sum up back-projections without reshaping
        end % loop over z
    end % end loop over theta for the nearest neighbout method
    vol_tmp=reshape(vol_tmp,[N,N,length(slices)]) ; % reshape 1D vector into 2D image for each z
    % shows central slice only , in figure 10
    figure(10), imshow(fliplr(vol_tmp(:,:,cnt_slc)'),[]); % visualize central slice after vol reconstruction
    stringa = [' NN back-prj. cntrl slice , radiog. degrees: ' , num2str(dgri)];  
    title(stringa);   colormap(gray(256));
    display(' done cone beam back projection  ! - nearest neighbour method')
    %*********************************************************** 
end

if  strcmp(interp, 'bilinear')
    x=x(mask); y=y(mask); % mask !
    temp_1=zeros(nnz(mask(:)),1); temp_2=zeros(nnz(mask(:)),1); 
    tmp2=zeros(N.^2,1); % viene retroproiettato 
    for i=1:length(theta) % loop over projections
    %   i
        dgri=thetag(i); % angolo corrente in gradi
        proj=read_1rad(i,dir,flprefix); % read in the i-th projection 
        proj = radio2proj(proj,W,H,len); 
        
        proj(:,length(H))=0;  % Zero pad projections 
        for ir = 1:nr_p; % filtering row  by row  
            proj(ir,:)=real (ifft ( fft(proj(ir,:)).*H ) );  % fast frequency domain filtering
        end % done for each row 
        proj(:,len+1:end) = [];   % Truncate the filtered projections
        proj=proj(:);
        proj1=[proj(2:end,:); proj(end,:)]; proj1=proj1(:);
        % imshow(proj,[ ]) ;  title(' log proj'); 
        % proj. is transposed with respect to the original radiograph!
        s =  x.*costheta(i) + y.*sintheta(i); t = -x.*sintheta(i) + y.*costheta(i); % Goddard&Trepanier
        R_s=Ro-s; u=Ro*t./R_s; u=u+ctrIdx; fu=floor(u(:)); % 
        iz=0;
        good=( (fu>0 & fu<nc_p+1) );  lengoodu=length(good);
        for z= slices
            iz=iz+1  ;%z % slice under reconstruction 
            v=Ro*z./R_s + nr_p/2;  % coord. correction
            fv=floor(v(:)); 
           % good=( (fu>0 & fu<=nc_p) & (fv>0 & fv<=nr_p) ); 
            fu1=fu(good); fv1=fv(good);
            idx = (fu1-1)*szproj(1)+fv1 ; %idx = sub2ind(size(proj),fu, fv);
            temp_1(good) = (u(good)-fu1).*proj1(idx) + (fu1+1-u(good)).*proj(idx);              
            proj=[proj(:,(2:end)),proj(:,end)];   proj1=[proj(2:end,:);proj(end,:)];
            temp_2(good) = (u(good)-fu1).*proj1(idx) + (fu1+1-u(good)).*proj(idx);
            R_s1=R_s(:); 
            tmp =( (v(good)-fv1) .* temp_2(good)  + (fv1+1-v(good)) .* temp_1(good) ) ./ (R_s1(good).^2);  
            tmp1(good)=tmp;  tmp1( lengoodu)=0; tmp2(mask(:))=tmp1;
            vol_tmp(:,iz)=vol_tmp(:,iz)+tmp2(:); % $$$$$$$$$$$$$
        end % loop over z
    end % end loop over theta for bilinear method
    vol_tmp=reshape(vol_tmp',[N,N,length(slices)]) ; % reshape $$$$$$$$$$
    % shows central slice in figure 10
    figure(10), imshow(fliplr(vol_tmp(:,:,cnt_slc)'),[]); % visualize central slice after vol reconstruction
    stringa = [' Bi-LNR bk prj. rad. ' , num2str(i-1)];  title(stringa)
    colormap(gray(256));    display(' done back projection  ! - Bilinear method')
end % closee else linear 



% Filtered Back-projection - i.e. from proj pixel (u,v) to voxel (x,y,z) 
if strcmp(interp, 'n_n_demo')
    x=x(maskV); y=y(maskV); % mask !
    
    nw_slices = real(sort(complex(slices))) ; % sort and reordering for faster reconstruction
   % eg. +5 -5 + 6 -6 ...it allows to change the sign of v rather than recalculating v
    
    ZFlag= abs(nw_slices(2:end)) == nw_slices(1:(end-1)) ; % logical variable
    ZFlag=real([0, ZFlag] ); % true if +z is followed by -z and one can exploit symmetry
    
    for ipos=1:length(slices) % right positioning the re-orded slices in the volume
        iposz_v(ipos)=find( nw_slices(ipos)== slices) ;  % slice correspondence  
    end
    % data type and array allocation statements    
    proj=repmat(0,nr_p,nc_p);
    tmp=zeros(nnz(mask),1); tmp2=zeros(N.^2,1); % allocate memory to temporary arrays
   % tmp1
    v0=zeros([size(x)]); v1=v0; u1=v1; % u=u1; v=u;
    good_u=logical(v0); idx=zeros(size(v0)); % allocation
    
    for i=1:length(theta) % loop over the projections
       % i
        dgri=thetag(i); % theta in degrees
        
        proj=read_1rad(i,dir,flprefix); % read in the i-th radiograph 
        proj = radio2proj(proj,W,H,len); % tranforms radiog. into projection and multiply by W
        %%%
        proj(:,length(H))=0;  % Zero pad projections for 
        for ir = 1:nr_p; % filtering row  by row  with row vector H
            proj(ir,:)= real (ifft ( fft(proj(ir,:)).*H ) );  % fast frequency domain filtering
        end
        proj(:,len+1:end) = [] ;   % Truncate the filtered projections
        %%%
        s =  x.*costheta(i) + y.*sintheta(i); t = -x.*sintheta(i) + y.*costheta(i); % Goddard & Trepanier
        % s = x.*costheta(i) + y.*sintheta(i); % also in matlab iradon 
        R_s = Ro-s; u=round( Ro*t./(R_s) + ctrIdx) ; % u is the 1st projection pixel coordinate
        good_u = (u>0 & u<(nc_p+1)) ; % only valid pixels -i.e. within the projection frame
        lengoodu=length(good_u);
        u1=u(good_u);%
        inv_R_s_quad=1./(R_s(good_u).^2); Ro_dev_R_s=Ro./(R_s(good_u)); % for generally .* is faster than ./
        iz=0;
        id_1_term=(u1-1)*szproj(1); % does not depend up on v
        for z=nw_slices % for all the (re-ordered) slices 
            iz=iz+1;  % z slice under reconstruction
           if ZFlag(iz)==1; % z symmetry (floting point is faster than logical operators!)
          %  if ( iz>=2 & ( abs(nw_slices(iz)) == nw_slices(iz-1) ) ) % z symmetry
                v0=-v0;   % allows calc time saving
            else %  v is the 2nd proj. pixel coord. (u,v)
                v0=Ro_dev_R_s.*z ;  %
            end
            v1=round( v0+nr_p/2 ) ;  % coord. correction
            %v1=v(good_u);  % logical operations i.e. only valid pixels
            idx = id_1_term + v1 ; % idx = sub2ind(szproj,u1, v1); 
            tmp = proj(idx); % just in case
            tmp = tmp(:).*inv_R_s_quad; % back-projection ... from pixels to voxels ...!
            tmp1(good_u)=tmp; tmp1(lengoodu)=0;% 
            tmp2(maskV)=tmp1; % prepare for image reconst. within the mask
            iposz=iposz_v(iz); % position of the current slice iz in the volume at iposz
            vol_tmp(:,iposz)=vol_tmp(:,iposz)+tmp2; % sum up back-projections without reshaping
            figure(8), imshow(reshape(vol_tmp,[N,N,length(slices)]),[ ]) ; 
            title('back-projection in progress');
        end % loop over z
    end % end loop over theta for the nearest neighbout method
    vol_tmp=reshape(vol_tmp,[N,N,length(slices)]) ; % reshape 1D vector into 2D image for each z
    % shows central slice only , in figure 10
    figure(10), imshow(fliplr(vol_tmp(:,:,cnt_slc)'),[ ]); % visualize central slice after vol reconstruction
    stringa = [' NN back-prj. cntrl slice , radiog. degrees: ' , num2str(dgri)];  
    title(stringa);   colormap(gray(256));
    display(' done cone beam back projection  ! - nearest neighbour method')
    %*********************************************************** 
end












vol_tmp= vol_tmp*Ro.^2*pi/(2*length(theta)); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%  Sub-Function:  designFilter
%%%
function filt = designFilter(filter, len, d)
% Returns the Fourier Transform of the filter which will be 
% used to filter the projections
%
% INPUT ARGS:   filter - either the string specifying the filter 
%               len    - the length of the projections
%               d      - the fraction of frequencies below the nyquist
%                        which we want to pass
%
% OUTPUT ARGS:  filt   - the filter to use on the projections

order = max(64,2^nextpow2(2*len));

% First create a ramp filter - go up to the next highest
% power of 2.

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W = pix_weight(nr,nc,R,Nofs,Eofs)
% weight for the pixels of the projetions/radiographs
% R is the orbital radius i.e. source to object distance
% off set ... Nofs=Nord off set ; Eofs= East ..
% nr, nc number of rows and columns of W

if nargin <4 % missing off set values
    Nofs=0;Eofs=0; % no off set then 
end

if abs(Nofs) > floor(nc/2) | abs(Eofs) > floor(nr/2) 
    display(' off set overflow in pix_weight')  
end
% grid !
[X,Y]=meshgrid([[floor(nc/2):-1:0],[1:(nc-floor(nc/2)-1)]],...
    [[floor(nr/2):-1:0],[1:(nr-floor(nr/2)-1)]]);
%W=R.* ( (X.^2 + Y.^2 + R^2).^-0.5 ); 
W=R* ( ((X-Nofs) .^2 + (Y-Eofs).^2 + R^2).^-0.5 ); 
%figure, imshow(W,[]); title(' pxls weights')
%figure, surf(W); title(' pixel weighting matrix ')
%colormap(jet)
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function y = embed(x, mask)
% %function y = embed(x, mask)
% %	embed x in nonzero elements of a logical mask
% %   x is a 1D array and mask is 2D
% 
% if max(size(mask)) <= 1
%     y = x; % peculiar 
% else 
%     good = find(mask(:) ~= 0);
%     np = length(good);
%     if size(x, 1) ~= np
%         error 'bad input size' % 
%     end
%     xdim = size(x);
%     y = zeros(prod(size(mask)), prod(xdim(2:end)));
%     y(good,:) = x;
%     y = reshape(y, size(mask), xdim(2:end));
% end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function proj = radio2proj(radio,W,H,len)
% the routine corrects the radiog. for flat and dark images
% weights the radiographs 
% log process the radio to generate a projection
global flat , global dark
% 
% num=(radio-dark); den=(flat-dark);  
% num(num<=0)=1.E-6; den(den<=0)=1.E-4;  
% proj=num./den; % correzione per dark & flat
% proj(proj>1)=1; proj(proj<=0)=1E-6; 
% proj=-log(proj); % da radio 2 proj 
%size(radio)
proj=radio;
proj=proj.*W; % weighting projection 
%return
% filtring projection
% proj(:,length(H))=0;  % Zero pad projections 
% %proj = fft(proj);    % p holds fft of projections
% for ic = 1:size(proj,1)
%     % filter column by column i.e. row sino by row sino 
%     %proj(:,ic) = proj(:,ic).*H(:); % fast frequency domain filtering
%     proj(ic,:)=real (ifft ( fft(proj(ic,:)).*H ) );  
% end
% %proj = real(ifft(proj));     % p is the filtered projections
% proj(:,len+1:end) = [];   % Truncate the filtered projections
%figure(6),  imshow(proj,[ ]); title(' proiezione filtrata ')
return
