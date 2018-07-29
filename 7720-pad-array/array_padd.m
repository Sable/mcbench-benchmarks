function [data_out, indd] = array_padd(data_in, padsize, paddvalue, direction, paddmode)

% function to pad data array with various border conditions
% INPUTS:   
%   DATA_IN - input data array 
%   PADSIZE - same as in padarray.m, [rowpad, colpad] number of samples to
%             pad in row and in column direction
%   PADDVALUE - numerical value used to pad (ignored within some pad modes)
%   DIRECTION - same as in padarray.m {'both' 'post' and 'pre'}
%   PADDMODE  - 'circular', 'replicate' and 'symmetric' are the  same as in 
%             padarray.m.  New options are:
%    'barthannwin', 'bartlett', 'blackman','blackmanharris', 'bohmanwin', 
%    'flattopwin','gausswin','hamming' ,'hann', 'nuttallwin','parzenwin', 'triang'
%     In it, 'symmetric' padded values are multiplied by the 1/2 of corresponding 
%     window to taper off the values to zero. Symmetrical padding option in
%     it can be replaced by 'replicate' by uncommenting line 70 and
%     commenting line 71 in function body. With these windowing options,
%     direction and paddvalue is ignored (but must be present for consistency) 
%     and internaly 'symmetric' and  'both' are used
%
%                         
% OUTPUTS:  DATA_OUT    - output padded data array
%           INDD        - indeces of padded array used to recover the original array
%
%EXAMPLES:
%       data_in = [1 1 1 1 1; 1 2 3 2 1; 1 2 3 2 1; 1 1 1 1 1]
%       [data_out, indd] = array_padd(data_in, [3, 5])
%       [data_out, indd] = array_padd(data_in, [3, 5], 5)
%       [data_out, indd] = array_padd(data_in, [3, 5], 0, 'both')
%       [data_out, indd] = array_padd(data_in, [3, 5], 0, 'both', 'replicate')
%       [data_out, indd] = array_padd(data_in, [3, 5], 0, 'both', 'symmetric')
%       [data_out, indd] = array_padd(data_in, [3, 5], 0, 'both', 'hamming')
%       imagesc(data_out); colorbar
% original array size and position within padded array can be recovered as 
%       data_out = data_out(indd(1):indd(2),indd(3):indd(4));

% Other m-files required: none
% Subfunctions: none
% MAT-files required: 
% window.m and padarray.m from Signal and Image Processing Toolboxes

%____________________________________________
% 	Sergei Koptenko, Resonant Medical Inc., 
%           Montreal, Qc., Canada
%	sergei.koptenko@resonantmedical.com 
%   Website: http://www.resonantmedical.com
%____________Feb/30/2005_____________________

if nargin <2, 
	disp('Not enough arguments')
    elseif  nargin <3, paddvalue =0; direction = 'both'; paddmode = 'simple'; 
        elseif  nargin <4, direction = 'both'; paddmode = 'simple'; 
            elseif nargin <5, paddmode = 'simple';    
end

[rrow,ccol] = size(data_in);
%Find indices of the original array within the padded array
switch direction
    case {'both','pre' }
       indd = [padsize(1)+1,(padsize(1)+rrow), padsize(2)+1,(padsize(2)+ccol)];
    case 'post'
        indd = [1,rrow, 1,ccol]; 
end

% Create the padded array
switch paddmode
    case 'simple'
          data_out = padarray(data_in, padsize, paddvalue, direction);
          
   case {'circular', 'replicate' , 'symmetric' }
        data_out = padarray(data_in,padsize, paddmode, direction);
       
    case  {'barthannwin', 'bartlett', 'blackman', 'blackmanharris',...
            'bohmanwin', 'flattopwin','gausswin', 'hann' , 'nuttallwin',...
            'parzenwin' , 'triang','hamming'} % This option forces direction == 'both'
        eval(['rowwind =window(@' paddmode ', ' num2str(2*padsize(1)) ');']);
        eval(['colwind =window(@' paddmode ', ' num2str(2*padsize(2)) ');']);   
        
%       data_out = padarray(data_in, padsize, 'replicate', 'both');
        data_out = padarray(data_in, padsize, 'symmetric', 'both');
        [mrow, mcol] = size(data_out);   
%________Create a Column mask______________
        tc =ones(mrow,1); % single column mask
        tc(1:indd(1)-1) = tc(1:indd(1)-1) .* rowwind(1:padsize(1));  % mask for the row start
        tc(indd(2)+1:end) = tc(indd(2)+1:end) .* rowwind(padsize(1)+1:end);%mask for the row end
        mc = repmat(tc, 1, mcol); %column mask array
%________Create a ROW mask______________
        tr =ones(1, mcol); % single ROW mask
        tr(1:indd(3)-1) = tr(1:indd(3)-1) .* colwind(1:padsize(2))';    % mask for the col start
        tr(indd(4)+1:end) = tr(indd(4)+1:end) .* colwind(padsize(2)+1:end)'; % mask for the col end
        mr = repmat(tr, mrow, 1); %  row mask array
%________Create FULL mask______________
        data_out = data_out .*  mr .* mc;    
       
   otherwise
      disp('Unknown method.')
end
return


