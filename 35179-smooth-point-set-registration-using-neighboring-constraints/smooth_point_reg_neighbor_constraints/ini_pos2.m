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
% point sets (without changing the scale of the point-sets)
% 
% Input:
%   gD,gM: 2D point-sets
% 
% Output:
%   Sd: discrete {0,1} assignments matrix
% 

function Sd = ini_pos2(gD,gM)

lD = length(gD);
lM = length(gM);

Sini = zeros(lD,lM);
for it_dim = 1:2
    Sini = Sini + ...
        ((gD(:,it_dim)*ones(1,lM) - ones(lD,1)*gM(:,it_dim)').^2);
end
Sini = sqrt(Sini);
% 
Sd = clean(-Sini);
