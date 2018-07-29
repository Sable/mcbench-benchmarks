function n=random_n;
% random unit vector n



while 1
    % random from cube 3*3*3:
    rfc=3*rand(3,1)-1.5;
    rfcl=sqrt(rfc'*rfc); % length
    if (0.5<=rfcl)&&(rfcl<=1)
        break
    end
end

n=rfc/rfcl;
        
    