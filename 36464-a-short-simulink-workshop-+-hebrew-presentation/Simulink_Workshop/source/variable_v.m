function desired_velocity = variable_v(position,velocity)
%{
This function  receives the following inputs:
    1. Position of the aircraft- [x, y, z]
    2. Velocity of the aircraft - [x,y,z]
Using the inputs, the function returns the value of the desired velocity,
cartasian coordinates.
Created by Roni Peer, 11.7.2010
%}
%#eml
height = position(3);                                           % Get the Height.
if height > 500                                                         % Maintain velocity.
    desired_descent_rate = velocity(3);     
elseif height > 200                                                % Slow down.
    desired_descent_rate = -10;
elseif height > 100
    desired_descent_rate = -2;
elseif height > 10
    desired_descent_rate = -1;
else
    desired_descent_rate = -0.5;                        % Break.
end
desired_velocity = [0; 0; desired_descent_rate];