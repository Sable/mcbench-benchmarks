% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Returns discrete assignments matrix assigning closest points in both
% point sets
% 
% Input:
%   gD,gM: 2D point-sets
% 
% Output:
%   Sd: discrete {0,1} assignments matrix
% 

function Sd = ini_pos(gD,gM)

lD = length(gD);
lM = length(gM);

[gMc gDc] = center_rescale_weighted(gM,gD,ones(lD,lM));
sigma = sigma_weighted(gDc,gMc,ones(lD,lM));

Sini = zeros(lD,lM);
for it_dim = 1:2
    Sini = Sini - ...
        ((gDc(:,it_dim)*ones(1,lM) - ones(lD,1)*gMc(:,it_dim)').^2) ...
        ./ sigma(it_dim,it_dim);
end
Sini = exp(Sini ./ 2);
% 
Sd = clean(Sini);
