function q = coordinates(settings)
% function q = coordinates creates generalized coordinates in symbolic form
%
% function q = coordinates creates specific coordinate values, 
% which can be used as initial conditions.
%   settings can have the following values:
%   'dummy'         - dummy values
%   'drop'          
%   'srad_steadystate_vx20'    
%
% feel free to add your own motorcycle configuration
%
% generalized coordinates and their definition:


if nargin < 1
    syms qx qy qz q0 q1 q2 q3 q4 q5 q6 q7 qf q8 q9
    q.qx = qx ;
    q.qy = qy ;
    q.qz = sym('qz') ;
    q.q0 = q0 ;
    q.q1 = q1 ;
    q.q2 = q2 ;
    q.q3 = q3 ; % It must be investigated if q3 as a generalized
%     coordinate is better. for now, q3 is not a generalized coordinate,
%     but a dependent coordinate.
    q.q4 = q4 ;
    q.q5 = q5 ;
    q.q6 = q6 ;
    q.q7 = q7 ;
    q.qf = qf ;
    q.q8 = q8 ;
    q.q9 = q9 ;


else
    switch settings
        case 'dummy'
            q.qx = 0 ;
            q.qy = 0 ;
            q.qz = .775 ;
            q.q0 = 0 ;
            q.q1 = 0;
            q.q2 = -0.412 ;
            q.q3 = 0 ;
            q.q4 = q.q0+atan((sin(q.q3)*cos(q.q2))/(cos(q.q1)*cos(q.q3)-sin(q.q1)*sin(q.q2)*sin(q.q3)));
            q.q5 = asin(cos(q.q1)*sin(q.q2)*sin(q.q3)+sin(q.q1)*cos(q.q3))     ; 
            q.q6 = -.5;atan((-sin(q.q3)*tan(q.q1)+sin(q.q2)*cos(q.q3))/cos(q.q2))  ; 
            q.q7 = -0.372 ;
            q.qf = .5988 ;
            q.q8 = 0 ;
            q.q9 = 0 ;
            q.qxd = 0 ;
            q.qyd = 0 ;
            q.qzd = 0 ;
            q.q0d = 0 ;
            q.q1d = 0 ;
            q.q2d = 0 ;
            q.q3d = 0 ;
            q.q4d = 0 ;
            q.q5d = 0 ;
            q.q6d = 0 ;
            q.q7d = 0 ;
            q.qfd = 0 ;
            q.q8d = 0 ;
            q.q9d = 0 ;

            
            q.qx = 0.558123872263452+0.081672082894096 ;
            q.qy = 0 ;
            q.qz = 0.670744189904527 ;
            q.q0 = 0 ;
            q.q1 = 0;
            q.q2 = -0.35 ;
            q.q3 = 0 ;
            q.q4 = 0 ;
            q.q5 = 0 ; 
            q.q6 = q.q2 ; 
            q.q7 =  0.0175 ;
            q.qf =  0.38 ;
            q.q8 = 0 ;
            q.q9 = 0 ;
            q.qxd = 16.07;
            q.qyd = 0;
            q.qzd = 0;
            q.q0d = 0;
            q.q1d = 0;
            q.q2d = 0;
            q.q3d = 0;
            q.q4d = 0;
            q.q5d = 0;
            q.q6d = 0;
            q.q7d = 0;
            q.qfd = 0;
            q.q8d = 16.07/.303;
            q.q9d = 16.07/.288;

        otherwise
            q='bad input argument';
    end
end
