function [im, kspFull] = pocs( ksp, iter, watchProgress )
%Partial-Fourier Reconstruction with POCS
%
% [im, kspFull] = pocs( kspIn, iter, watchProgr )
%
% === Input ===
%
%   kspIn:      Reduced Cartesian MRI Data-Set
%               Any dimension may be reduced,
%               but only one reduction dim. is allowed due to Physics/Math.
%
%               Allowed shapes for kspIn are...
%                 ... Ny x Nx
%                 ... Nc x Ny x Nx
%                 ... Nc x Ny x Nx x Nz
%
%               With Nc == number of receive Channels / Coils.
%
%               kspIn can either be a zero-padded array, so the partial Fourier property is obvious.
%               Or kspIn can be the measured data only, then we try to find k-space centre automagically
%               and create a zero-padded array with the full size, first.
%               Errors are however more likely to occur in the latter case.
%
%
%   iter:       No. of iterations
%   (optional)  default: iter = 20
%               Try on your own if larger iter improves your results!
%
%   watchProgr: true/false; Whether the progress of the reconstruction should
%   (optional)  be monitored in an image window.
%               In 3D data, only the central partition will be shown.
%
%
% === Output ===
%
%   im:         Reconstructed Images (channels not combined)
%
%   kspFull:    Reconstructed full k-space data
%
%
%
% === About the code ===
%
%   (1) We find out whether input data is
%       a) already zero-filled or
%       b) the pure asymmetric dataset, only
%
%       If b) is true, we zero-fill the data ourselves, which means we have to
%       determine the dimension first, in which the partial Fourier reduction was done.
%       We therefor find the position of the max. intensity in k-space which should
%       be identical to k-space centre. If the k-space centre is different from the
%       centre of the matrix, we know the partial Fourier dimension.
%       We then enlarge the matrix to its desired full size and fill the new part
%       with zeros.
%       If a) was true, finding the partial Fourier dimension is easy:
%       It is the dimension with all the zeros. :-)
%
%   (2) We create one low resolution image per channel/coil:
%
%       We need a symmetrically sampled part around the central k-space. Think of a
%       small stripe of phase encoding lines in the central k-space.
%       We only use these symmetric data (setting the rest zero) to reconstruct
%       low-resolution images. In order to avoid Gibbs-Ringing, a Hamming-filter
%       with the width of the stripe is multiplied with the data.
%       Additionally, all the fully sampled dimensions get a Hamming filter, too,
%       since we increase SNR, reduce further Gibbs-ringing and do not lose much
%       resolution.
%
%   (3) The phase of the low-resolution images is saved
%
%       POCS uses the fact that k-space data of real objects (no imaginary part)
%       have a point symmetry:
%           S(-k)  =  S*(k)      with k = (kx, ky, kz)
%       Our MRI objects are always complex, but we assume that phase variations
%       are due to coil sensitivities and B0-inhomgeneities,
%       which are both slowly varying (no high res. required).
%       Small-scale phase pertubations will decrease the reconstruction quality.
%
%   (4) Reference phase is applied in image space
%
%       We...
%       ... transform our zero-filled data to image space (IFFT)
%       ... remove the phase --> abs(image)
%       ... set the phase of our reference phase map --> image .* exp(1i.*phase)
%       ... transform back to k-space (FFT)
%       ... re-insert the measured data (self-consistency!)
%       ... goto "We..."
%
%       Iterating through the above steps fills the missing k-space points
%       with reasonable values.
%       If the phase varies slowly and there is no aliasing, this works very well.
%
% Aliasing artifacts are very challenging for POCS.
% So try to prevent aliasing in the first place (sufficient Field of View).

% =========================================================================
% Original code by Martin Blaimer
% * changed by Uvo Hoelscher
% * changed by Michael Völker
%        -- auto-detect PF dimension
%        -- auto-find centre point/line/partition
%        -- accept zerofilled or "pure" data
%        -- for multichannel or plain 2D data (single-channel)
%        -- 2D and 3D
%        -- error handling
%        -- comments, comments, comments
%        -- added option to monitor progress
%        -- moved code to seperate functions
%        -- smooth transition between acquired signal and
%           reconstructed data
%
% Problems? Suggestions?
%  --> michael.voelker@mr-bavaria.de
% =========================================================================

    % ( ===================================================================
    % Input Handling
    %
        if ~exist( 'ksp', 'var' ) || isempty(ksp) || ~isnumeric(ksp)
            error('pocs:input', 'First input must be Cartesian k-space data.')
        end
        if ~exist('iter','var') || isempty(iter) || numel(iter) ~= 1 || ~isnumeric(iter)
            iter = 20;
        end
        if ~exist('watchProgress','var')  || isempty(watchProgress) ||  numel(watchProgress) ~= 1 || ~isfinite(watchProgress)
            watchProgress = false;
        else
            watchProgress = logical( watchProgress );
        end

        Ndim = ndims( ksp );

        if Ndim > 4 || Ndim < 2
            error('pocs:shape','First input ''kspace'' should have one of these shapes:\n\n\t... Ny x Nx\n\t... Nc x Ny x Nx\n\t... Nc x Ny x Nx x Nz')
        end
        if Ndim == 2    % Ny x Nx
            ksp = reshape( ksp, [1 size(ksp)] );    %  1 x Ny x Nx  --> now we have one channel...
            wasAddedCoilDim = true;
            Ndim = 3;
        else
            wasAddedCoilDim = false;
        end

        % read the properties of the data
        sz   = size( ksp );
        sz   = sz(2:end);           % the (k-)spatial size of the array (i.e. without channels)
        prec = class( ksp );        % single or double precision?
    % ) ===================================================================

    % First: Check the sampling pattern (which parts of input are actually data?)
    smplPtrn = reshape( sum(abs(ksp),1) ~= 0, sz);        % Ny x Nx x Nz


    % ( ===================================================================
    % If input data is not yet zero-filled, do it here
    %
        if nnz(smplPtrn) == numel(smplPtrn)     % only the sampled data were passed / |N|umber of |N|on |Z|ero elements

            [ ksp, pfDim, isUpper, isLower, Nsmp ] = zerofillPFdim( ksp, wasAddedCoilDim );

            sz = size( ksp );
            sz = sz(2:end);     % ignore channels
        else
            [ pfDim, isUpper, isLower, Nsmp ] = detectPFdim( smplPtrn, wasAddedCoilDim );
        end
        clear  smplPtrn
    % ) ===================================================================


    if numel(sz) < 3
        sz(3) = 1;
    end
    Ny = sz(1);
    Nx = sz(2);
    Nz = sz(3);


    % ( ===================================================================
    % Handle ugly problems.
    %
        if ~isUpper && ~isLower
            error('pocs:UnknownErrorFound', 'I thought we are partial Fourier, but things seem to make no sense... :-(')
        end
    % ) ===================================================================



    % =====================================================================
    %
    %        We can now be sure to operate with zero-padded data.
    %
    % =====================================================================



    % initialize a cell of subscripts
    subs = { ':', ':', ':', ':' };      % all channels / all Ny / all Nx / all Nz

    % If the first entries are zero-filled (instead of the trailing ones),
    % flip the entries so we can treat them as if we pf'ed the first half of kspace.
    if isLower
        subs{pfDim+1} = sz(pfDim):-1:1;     % ...esreveR
        ksp           = ksp(subs{:});       % !ecaps-k si sihT
        subs{pfDim+1} = 1:sz(pfDim);        % lalala, we didn't do anything...
    end

    % Find out which point is in the centre and which indices belong to the
    % symmetrically sampled part of k-space.
    [ centreLine, idxSym ] = findSymSampled( ksp, pfDim, Nsmp );

    szSym = numel( idxSym );                % 2 * (Nsmp - centreLine) + 1

    if isUpper
        fprintf('Using %g points around point %g\n', szSym,    centreLine    );
    else
        fprintf('Using %g points around point %g\n', szSym, sz(pfDim)-centreLine+1 );
    end

    % ( ===================================================================
    % build up a symmetric low-pass filter
    %
    filter = cast( 1, prec );
    for d = 1:Ndim-1

        reshRule = ones(1,Ndim);    % how the filter will be reshaped

        if d ~= pfDim   % Each standard dimension gets a simple low-pass filter

            filt1D = hamming( sz(d), 'periodic'  );

        else            % our partial Fourier dimension gets an extra nice filter

            % create a narrow filter and remove everything else
            filt1D          = zeros(sz(d), 1, prec);            % full-size filter
            tmp             = hann( szSym + 2, 'symmetric' );   % a very narrow window
            filt1D(idxSym)  = tmp(2:end-1);                     % cut out the zeros at the edges (we have data there!)

            % take a look:
            %figure, plot(filt1D)
        end

        % reshape the filter according to the dimension it represents
        reshRule(d+1) = sz(d);

        filt1D = reshape( filt1D, reshRule );
        filter = bsxfun( @times, filter, filt1D );      % iteratively build up a multidimensional filter
    end
    % ) ===================================================================

    % Apply the low-pass filter
    kspLowRes = bsxfun( @times, filter, ksp);
    clear  filt1D  filter  reshRule  idxSym


    % ( ===================================================================
    % prerequisites prior to the iteration loop
    %
    %  Set everything up here, do computations that you don't have
    %  to do in the loop, remove no longer needed variables...
    %
        % fftshift everything once before and after for-looping
        %  => less overhead during iteration
        ksp       = cmshiftnd(       ksp, [0  sz/2] );
        kspLowRes = cmshiftnd( kspLowRes, [0  sz/2] );

        % reorder arrays such that the fft-dimensions come first
        % => faster memory access
        ksp       = permute(       ksp, [2 3 4 1] );      % Ny x Nx x Nz x Nc
        kspLowRes = permute( kspLowRes, [2 3 4 1] );      %
        subs      = { subs{2}, subs{3}, subs{4}, subs{1} };

        % calc. initial image and the reference phase map
        im        =  fft( fft( fft( conj(ksp), [], 1), [], 2), [], 3);  % im's phase is wrong now, but we only want it's abs() to be correct
        phase     = ifft(ifft(ifft( kspLowRes, [], 1), [], 2), [], 3);
        phase     = exp(1i * angle(phase));

        % We use a trick in the loop to avoid using ifft (fft is faster).
        % We only need to calculate the factor 1/N ourselves, with N = prod(sz)
        phase = phase ./ prod(sz);      % 1/N is absorbed inside the phase array, once
        
        % create image with calculated phasemap from low res image
        im = abs(im) .* phase;

        % In the loop, we want to know where we have to copy the
        % measured data to, so we set the subscript of the pf dimension
        % accordingly.
        % We have to do this due to the ifftshift'ing above.
        tmp         = false( 1, sz(pfDim));
        tmp(1:Nsmp) = true;
        subs{pfDim} = find(ifftshift(tmp));

        % release RAM
        clear  tmp  kspLowRes

        % only keep the acquired data in memory
        ksp = ksp(subs{:});
    % ) ===================================================================

    % Helpers for pretty-printing:
    % Such a mess for such beautiful output!
    b = repmat('=',1,80);
    progress_str = 'starting POCS loop...';
    fprintf( '%s\n%s\n%s   %s', b, b(1), b(1), progress_str )
    edging = sprintf( '\n%s\n%s', b(1), b );
    fprintf( edging )


    % ( ===================================================================
    % iterative reconstruction POCS
    %
    tic
    for ii = double(~watchProgress) : iter

        if ii > 0

            % Fourier transform the image to k-space
            im = fft(fft(fft(  im  ,[],1),[],2),[],3);      % "im" is a really bad variable name now
                                                            % but we save a lot of RAM with this
            % Data Consistency:
            % insert original data where we have them
            im(subs{:}) = ksp;                              % "im" is still our reconstructed k-space signal

            % Fourier transform into image domain
            im = conj( im );
            im = fft(fft(fft(  im  ,[],1),[],2),[],3);      % Now, "im" is an image again.

            % create image with calculated phasemap from low res image
            im = abs(im) .* phase;

            prevLength = numel(progress_str) + numel(edging);
            t = toc;
            ETA = (t./ii) * iter  - t;
            progress_str = sprintf( 'Iteration %g/%g, in %g s,  ETA: %g s...', ii, iter, t, ETA );

            fprintf([repmat('\b',1,prevLength) '%s' '%s'], progress_str, edging );

        end % if ii > 0

        % a rough way to monitor the progress
        %
        if watchProgress
            tmp = ifftshift(sqrt(sum(abs(im(:,:,1,:).^2),4)));      % due to fftshift(), the 1st partition is the central one
            maxRange = sort( tmp(:), 'descend' );
            maxRange = maxRange( ceil(0.05 * numel(maxRange)) );    % ignore the "hottest" 5%

            if ~exist('pic','var')
                pic = [tmp tmp zeros(size(tmp),prec)];
                diffScale = 1;
            else
                delta = abs( pic(:,Nx+(1:Nx)) - tmp );
                diffScale = 0.5 * maxRange / median( delta(:) );
                pic(:,  Nx+(1:Nx)) = tmp;
                pic(:,2*Nx+(1:Nx)) = diffScale * delta;
                clear delta
            end

            figure(999)
            imagesc( pic, [0    maxRange ] )
            title(sprintf('\\bfiteration %g\ninitial     |    current     |     abs(previous - current) × %g', ii, diffScale ))
            axis image
            colormap(gray(256))
            drawnow
            clear tmp

            %if Nz == 1          % little pause for 2D (too fast otherwise)
            %    pause(2 / iter)
            %end
        end

    end % for ii = 1:iter
    fprintf([repmat('\b',1, numel(progress_str) + numel(edging)) 'POCS done! (%g s)' '%s\n\n'], t, edging );
    % ) ===================================================================

    clear  phase  pic

    % ( ===================================================================
    % The main part is over. Time for some thoughts.
    %
    % We began with a dataset that had fewer data samples than would be
    % necessary for an unambiguous image reconstruction. As a consequence,
    % an infinite number of images corresponds to the acquired data.
    % The above iteration picks that single image whose abs() fits the data
    % AND whose phase corresponds to the low-resolution phase, obtained
    % using the symmetric part of the data.
    %
    % Viewed in k-space, there is almost always a severe edge at the border
    % between acquired and interpolated data, which is due to imperfections
    % in the assumptions made.
    % Namely, phase often has some high frequency components which cannot be
    % accounted for in the low-resolution map. Additionally, there is noise
    % and we may have changing contrast or trajectory errors in our MRI
    % sequence.
    %
    %         ^
    %         | A A A A A A A A   \
    %         | A A A A A A A A
    %         | A A A A A A A A     acquired signal
    %      k2 | A A A A A A A A
    %         | A A A A A A A A   /
    %         | I I I I I I I I   \
    %         | I I I I I I I I     interpolated data
    %         | I I I I I I I I   /
    %         ----------------->
    %                 k1
    %
    % Empirically, it should be wise to create a smoother transition from
    % the acquired part of the signal to the interpolated data.
    %
        Ntrans = floor( (szSym-1)/3 );      % width of the transition zone

        % Create subscripts where we intend to keep the measured data, only.
        tmp                 = false( 1, sz(pfDim));
        tmp(1:Nsmp-Ntrans)  = true;
        subsPure            = subs;
        subsPure{pfDim}     = find(ifftshift(tmp));

        % Create subscripts where we want to have a smooth transition between
        % measured and phase-corrected data.
        subsTrans           = subs;
        subsTrans{pfDim}    = setdiff( subs{pfDim}, subsPure{pfDim} );

        % build a filter for the transition:
        tmp         = hann( 2*Ntrans+3, 'symmetric');
        filterTrans = tmp( Ntrans+3 : end-1 );
        filterTrans = reshape( filterTrans, [ ones(1,pfDim-1)  Ntrans  1] );

        % Seperate data in unfiltered part and transition zone.
        tmp = zeros( size(im), prec );
        tmp(subs{:}) = ksp;
        kspPure  = tmp(subsPure{:});
        kspTrans = tmp(subsTrans{:});
        clear  tmp  ksp

        im = fft(fft(fft(  im  ,[],1),[],2),[],3);      % "im" becomes k-space signal, again

        im(subsPure{:}) = kspPure;                      % strict data consistency for Nsmp-Ntrans samples
        im(subsTrans{:}) =  bsxfun( @times,   filterTrans,  kspTrans         )     ...
                          + bsxfun( @times, 1-filterTrans,  im(subsTrans{:}) );
    
        clear  subsPure  subsTrans  filterTrans  kspPure  kspTrans
        
        if nargout > 1
            kspFull = im;
        else
            kspFull = double.empty([sz 0]);     % kspFull exists, but no memory required
        end

        im = ifft(ifft(ifft(  im  ,[],1),[],2),[],3);   % "im" is an image, again
    % ) ===================================================================


    % ( ===================================================================
    % Undo the prerequisites (--> postrequisites???)
    %
        % undo the permutations
        im      = permute(      im, [4 1 2 3] );
        kspFull = permute( kspFull, [4 1 2 3] );
        subs    = { subs{4}, subs{1}, subs{2}, subs{3} };

        % undo the fftshifts
        im      = cmshiftnd(      im, [0  sz/2] );
        kspFull = cmshiftnd( kspFull, [0  sz/2] );

        % undo flipping
        if isLower
            subs{pfDim+1} = sz(pfDim):-1:1;
            im            = im(subs{:});
            kspFull       = kspFull(subs{:});
        end
    % ) ===================================================================

    if wasAddedCoilDim                              % we initially reshaped a simple 2D raw data matrix to be of size 1 x Ny x Nx
        im      = reshape(      im, Ny, Nx, [] );
        kspFull = reshape( kspFull, Ny, Nx, [] );
    end

end     % of pocs()






% =========================================================================
%                                                                         =
%                      SWAPPED CODE                                       =
%                                                                         =
% =========================================================================






function [ ksp, pfDim, isUpper, isLower, Nsmp ] = zerofillPFdim( ksp, wasAddedCoilDim )
    % Only the acquired data were passed and we have to find the asymmetric
    % dimension. Then we increase the size along this dimension and pad with 0.

    Ndim    = ndims( ksp ) - 1;     % one dimension was for the channels
    sz      = size(  ksp );
    sz      = sz(  2:end );         % ignore channel dimension
    Nc      = size(  ksp, 1 );
    prec    = class( ksp );

    % init some helper variables
    pfDim    = 0;               % partial Fourier reduction dimension
    isUpper  = false;
    isLower  = false;
    isPartialFourier = false(Ndim,1);

    % ( ===============================================================
    % autodetect the Partial Fourier dimension
    %
    for d = 1:Ndim

        centre = floor( sz(d)/2 ) + 1;

        tmp = squeeze( sum(abs(ksp),1) );
        for d2 = 1:Ndim
            if d2 ~= d
                tmp = max(tmp,[],d2);       % keep only the maximum of non-partial data points
            end
        end
        [ dummy, maxPos(d) ] = max( tmp(:) );   %#ok <-- don't use "~", for compatibility

        if abs(maxPos(d) - centre) >= 2      % significant asymmetry ==> partial Fourier acquisition

            isPartialFourier(d) = true;
            pfDim = d;
            Nsmp = sz(d);

            isUpper = maxPos(d) > centre;   % Did we sample the upper matrix part, so the lower part is missing...
            isLower = maxPos(d) < centre;   % ... or are the first data points missing (e.g. asymmetric echo)?
        end
    end % for d = 1:Ndim
    %
    % ) ===== (PF dim detection) ======================================


    switch nnz(isPartialFourier)    % |N|umber of |N|on |Z|ero elements
        case 0
            error( 'pocs:NoPfDim', 'No partial Fourier dimension found.' )
        case 1
            fprintf( 'Found partial Fourier along array dimension %d\n', pfDim + ~wasAddedCoilDim )
        otherwise
            error( 'pocs:TooManyPfDims', 'Partial Fourier only allowed in 1 dimension, but %g were found!', nnz(isPartialFourier) )
    end

    if pfDim == 0   % our init value above
        error('zerofillPF:NoPF','No partial Fourier property found!')
    end

    % initialize a cell of subscripts
    subs = { ':', ':', ':', ':' };      % all channels / all Ny / all Nx / all Nz

    c = maxPos(pfDim);

    if isUpper

        sz(pfDim) = 2 * (c - mod(c,2));         % determine the blown-up size we want to achieve
        subs{pfDim+1} = 1:Nsmp;

    elseif  isLower

        sz(pfDim) = 2 * (Nsmp - c + 1);
        c = floor( sz(pfDim)/2 ) + 1;
        sz(pfDim) = sz(pfDim) + 2*~mod(c,2);    % A hack for Stefan's data... keep an eye on this!
        subs{pfDim+1} = (1:Nsmp) + (sz(pfDim)-Nsmp);

    else
        error( 'zerofillPF:PFdimNotClassified', 'Could not tell how partial Fourier was implemented.' )
    end

    % do the zerofilling
    tmp = zeros( [Nc sz], prec );
    tmp(subs{:}) = ksp;
    ksp = tmp;

end % of zerofillPFdim()

function [ pfDim, isUpper, isLower, Nsmp ] = detectPFdim( smplPtrn, wasAddedCoilDim )
    % User passed already zero-padded data. This was nice, now it's easy
    % to find the partial Fourier dimension!

    Ndim = ndims( smplPtrn );
    sz = size( smplPtrn );

    % init some helper variables
    pfDim    = 0;               % partial Fourier reduction dimension
    isUpper  = false;
    isLower  = false;
    isPartialFourier = false( Ndim, 1 );

    % ( ===============================================================
    % Determine if this is a zerofilled partial Fourier measurement
    % and along which dimension the data is reduced.
    %
    % smplPtrn in Partial Fourier looks like this:
    %
    %     ^
    %     | 1 1 1 1 1 1 1 1     --->  sampling pattern is the same
    %     | 1 1 1 1 1 1 1 1           for all k1 points
    %     | 1 1 1 1 1 1 1 1
    %  k2 | 1 1 1 1 1 1 1 1             i.e. for programming:
    %     | 1 1 1 1 1 1 1 1             smplPtrn == repmat( smplPtrn(:,1,1), [1 Nx Nz] )
    %     | O O O O O 0 0 0
    %     | O O O O O 0 0 0
    %     | O O O O O 0 0 0
    %      ----------------->
    %           k1
    %
    for d = 1:Ndim

        subs = { ones(1,sz(d)),     ... % initialize a cell of subscripts we might be interested in
                 ones(1,sz(d)),     ...
                 ones(1,sz(d))  };
        subs{d} = 1:sz(d);              % we ask for all entries in the d'th dimension

        idx_d = sub2ind( sz, subs{:} ); % convert to linear array indices

        oneCol = smplPtrn( idx_d );     % one column of the d'th dimension

        % create a rule how to reshape oneCol
        reshRule = ones(1,Ndim);
        reshRule(d) = sz(d);                    % e.g. reshRule = [   1   1 128 ]
        oneCol = reshape( oneCol, reshRule);

        % create a rule how to replicate oneCol
        repRule = sz;
        repRule(d) = 1;                         % e.g. repRule  = [ 256 256   1 ]

        % Check if we get the sampling pattern again
        % just by replicating oneCol along the other dimensions
        isPartialFourier(d) = isequal( smplPtrn, repmat( oneCol, repRule ) );

        if isPartialFourier(d)
            pfDim = d;
            Nsmp  = nnz( oneCol );      % how many fully sampled lines do we have?

            % Sampled upper or lower part of k-space matrix?
            isUpper = isequal( oneCol(:).', [ true( 1,Nsmp)          false(1,sz(d)-Nsmp)    ]);
            isLower = isequal( oneCol(:).', [ false(1,sz(d)-Nsmp)    true( 1,Nsmp)          ]);
        end
    end
    % ) ===============================================================

    switch nnz(isPartialFourier)    % |N|umber of |N|on |Z|ero elements
        case 0
            error( 'pocs:NoPfDim', 'No partial Fourier dimension found.' )
        case 1
            fprintf( 'Found partial Fourier along array dimension %d\n', pfDim + ~wasAddedCoilDim )
        otherwise
            error( 'pocs:TooManyPfDims', 'Partial Fourier only allowed in 1 dimension!' )
    end

end % of detectPFdim()

function [ centreLine, idxSym ] = findSymSampled( ksp, pfDim, Nsmp )

    Ndim = ndims( ksp ) - 1;    % one for channels
    sz = size( ksp );
    sz = sz(2:end);

    % autodetect the central k-space line
    %if ~exist('centreLine', 'var') || isempty(centreLine)
        tmp = squeeze( sum(abs(ksp),1) );
        for d = 1:Ndim
           if d ~= pfDim
               tmp = max(tmp,[],d);     % keep only the maximum of non-partial data points
           end
        end
        [ dummy, centreLine] = max( tmp(:) );   %#ok the central line has the max intensity
    %end

    % calculate the size of the symmetric part and the full dataset
    startSym = centreLine - (Nsmp - centreLine);    % start of our symmetric sampling
    endSym   = centreLine + (Nsmp - centreLine);    % end of symmetric part
    idxSym   = startSym : endSym;

    if any(idxSym < 1)    ||   any(idxSym > sz(pfDim))
       error( 'pocs:BadDataProperty' , 'Symmetric part of k-space out of bounds.\nThe maximum k-space intensity is at index %g whereas it should be centred => near %g.\nThe way, zerofilling was done is probably wrong.\nCheck your input k-space.', centreLine, round(sz(pfDim)/2) )
    end

end % of findSymmetricSampled()

function x = cmshiftnd( x, shifts)
%Function to circularly shift N-D arrays

    if nargin < 2 || all(shifts(:) == 0)
       return                       % no shift
    end

    sz      = size( x );
    numDims = ndims(x);             % number of dimensions
    idx = cell(1, numDims);         % creates cell array of empty matrices,
                                    % one cell for each dimension

    for k = 1:numDims

        m = sz(k);
        p = ceil(shifts(k));

        if p < 0
            p = m + p;
        end

        idx{k} = [p+1:m  1:p];
    end

    % Use comma-separated list syntax for N-D indexing.
    x = x(idx{:});

end % of cmshiftnd()

% Avoid the need for the signal toolbox and implement
% hamming() and hann() manually:
%
function w = hamming( N, symFlag )
%Hamming window
%
% w = hamming(L) returns an L-point symmetric Hamming window in the column vector w.
% L should be a positive integer.
%
%  The coefficients of a Hamming window are computed from the following equation:
%
%       w(n) = 0.54  +  0.46 * cos(2*pi*n/N),   0 <= n <= N
%
%
% w = hamming( L, 'symFlag') returns an L-point Hamming window using the window sampling
% specified by 'symFlag', which can be either 'periodic'  or 'symmetric' (the default).
% The 'periodic' flag is useful for DFT/FFT purposes, such as in spectral analysis.
% The DFT/FFT contains an implicit periodic extension and the periodic flag enables a signal
% windowed with a periodic window to have perfect periodic extension.
% When 'periodic' is specified, hamming computes a length L+1 window and returns the first L points.
% When using windows for filter design, the 'symmetric' flag should be used.
%
% --> http://www.mathworks.de/de/help/signal/ref/hamming.html
% --> https://de.wikipedia.org/wiki/Hamming-Fenster

% implemented by Michael.Voelker@mr-bavaria.de, 2012

    if ~exist( 'N', 'var' ) || isempty(N) || numel(N) ~= 1 || ~isnumeric(N)  || ~isfinite(N) || N < 1 || floor(N) ~= N
        error( 'hamming:badSize', 'Window lenght must be a positive integer.' )
    end
    if ~exist( 'symFlag', 'var' ) || isempty(symFlag)
        symFlag = 'symmetric';
    end

    if N == 1
        w = 1;
        return
    end

    switch symFlag
        case 'symmetric'
            L = N-1;
        case 'periodic'
            L = N;
        otherwise
            error('hamming:symFlag', 'Unknown symmetry flag. Try ''symmetric'' (default) or ''periodic''.')
    end

    w = (0:N-1) - L/2;
    w = 0.54  +  0.46 * cos(2*pi * w(:)./L);

end % of hamming()


function w = hann( N, symFlag )
%von-Hann (Hanning) window
%
% w = hann(L) returns an L-point symmetric Hann window in the column vector w.
% L must be a positive integer.
%
% The coefficients of a Hann window are computed from the following equation:
%
%      w(n) = 0.5 * (1 + cos(2*pi*n/N)),   0 <= n <= N
%
% The window length is L = N+1.
%
% w = hann(L,'sflag') returns an L-point Hann window using the window sampling specified by 'sflag',
% which can be either 'periodic' or 'symmetric' (the default). The 'periodic' flag is useful for DFT/FFT purposes,
% such as in spectral analysis.
% The DFT/FFT contains an implicit periodic extension and the periodic flag enables a signal windowed
% with a periodic window to have perfect periodic extension.
% When 'periodic' is specified, hann computes a length L+1 window and returns the first L points.
% When using windows for filter design, the 'symmetric' flag should be used.
%
% --> http://www.mathworks.de/de/help/signal/ref/hann.html
% --> https://de.wikipedia.org/wiki/Hann-Fenster

% implemented by Michael.Voelker@mr-bavaria.de, 2012

    if ~exist( 'N', 'var' ) || isempty(N) || numel(N) ~= 1 || ~isnumeric(N)  || ~isfinite(N) || N < 1 || floor(N) ~= N
        error( 'hann:badSize', 'Window lenght must be a positive integer.' )
    end
    if ~exist( 'symFlag', 'var' ) || isempty(symFlag)
        symFlag = 'symmetric';
    end

    if N == 1
        w = 1;
        return
    end

    switch symFlag
        case 'symmetric'
            L = N-1;
        case 'periodic'
            L = N;
        otherwise
            error('hann:symFlag', 'Unknown symmetry flag. Try ''symmetric'' (default) or ''periodic''.')
    end

    w = (0:N-1) - L/2;
    w = 0.5 * ( 1 + cos(2*pi * w(:)./L) );

end % of hann()
