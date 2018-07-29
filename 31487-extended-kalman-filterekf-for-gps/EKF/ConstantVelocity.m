% Constant Velocity model for GPS navigation.
function [Val, Jacob] = ConstantVelocity(X, T)

Val = zeros(size(X));
Val(1:2:end) = X(1:2:end) + T * X(2:2:end);
Val(2:2:end) = X(2:2:end);
Jacob = [1,T; 0,1];
Jacob = blkdiag(Jacob,Jacob,Jacob,Jacob);

end