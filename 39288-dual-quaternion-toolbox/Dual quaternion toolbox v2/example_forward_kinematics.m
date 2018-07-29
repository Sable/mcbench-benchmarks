%% EXAMPLE_FORWARD_KINEMATICS 
%  EXAMPLE_FORWARD_KINEMATICS describes the forward kinematics for 2 or
%           3-link arms. For both types, the user can choose to use
%           rotations and translation dual quaternions, or to use screw
%           motion dual quaternions. For the two-link arm, only the
%           end-effector position fporward kinematics is computed, while
%           for the 3-link arm, the end-effector orientation and position
%           forward kinematics are computed.
%           The user must specify the arm parameters at the beginning of 
%           this file. Two parameters are important:
%            - CHOICE_ARM: scalar value equal to:
%                --> 2 : the two-link arm is chosen
%                --> 3 : the three-link arm is chosen
%            - CHOICE_REPRESENTATION: scalar value equal to:
%                --> 1 : only rotations and translations are considered
%                --> 2 : screw mùotions are considered
%            Depending on the option you choose, the end-effector point
%            (and orientation) position and velocity is displayed.


%% parameters to be specified by the user
clear all;
close all;
clc;

choice_arm = 3; % 2 = two-link arm, 3 = three-link arm
choice_representation = 1; % 1 = rotation and translations, 2 = screw motions
% arm segement parameters 
a = 10; % length of the upper arm
b = 8; % length of the lower arm
c = 2; % distance between the wrist and the end-effector (e.g. a fingertip, or a tool)

% rotation parameters for the upper arm rotation around the shoulder
theta_UB = 0; % rotation angle [deg] of the upper arm around the shoulder
axis_UB = [0 0 1]'; % rotation axis of the upper arm around the shoulder
Omega_speed_UB = 0; % instantaneous rotational speed [deg/s] of the upper arm around the shoulder
Omega_axis_UB = [0 0 -1]'; % instantaneous rotational velocity axis of the upper arm around the shoulder

% rotation parameters for the lower arm rotation around the elbow
theta_LU = 90; % rotation angle [deg] of the lower arm around the elbow
axis_LU = [0 0 1]'; % rotation axis of the lower arm around the elbow
Omega_speed_LU = 20; % instantaneous rotational speed [deg/s] of the  lower arm around the elbow
Omega_axis_LU = [0 0 -1]'; % instantaneous rotational velocity axis of the lower arm around the elbow arm

if choice_arm == 3
    % rotation parameters for the hand rotation around the wrist
    theta_HL = 90; % rotation angle [deg] of the hand around the wrist
    axis_HL = [0 0 1]'; % rotation axis of the hand around the wrist
    Omega_speed_HL = 0; % instantaneous rotational speed [deg/s] of the hand around the wrist
    Omega_axis_HL = [0 0 -1]'; % instantaneous rotational velocity axis of the hand around the wrist
end

%% Forward kinematics of the end-effector of a two-link arm (point transformation)
if choice_arm == 2 % the two-link arm is considered
%% Using rotations and translations
    if choice_representation == 1 % rotations and translations operators
        % rotation, translation and rotational velocities dual quaternions
        R_UB = rot2dquat(theta_UB,axis_UB); % rotation dual quaternion of the upper arm around the shoulder
        R_LU = rot2dquat(theta_LU,axis_LU); % rotation dual quaternion of the lower arm around the elbow
        T_ES = trans2dquat([1 0 0]',a); % translation dual quaternion  specifying the offset between the elbow and the shoulder
        % (in upper-arm fixed shoulder centered
        % coordinates)
        Omega_UB = rotvel2dquat(Omega_speed_UB,Omega_axis_UB); % rotational velocity dual quaternion of the upper arm around the shoulder
        Omega_LU = rotvel2dquat(Omega_speed_LU,Omega_axis_LU); % rotational velocity dual quaternion of the lower arm around the elbow
        
        % position
        P_LE = [b 0 0]'; % position of the end-effector in (lower arm)-fixed elbow-centered coordinates
        P_LE_dq = pos2dquat(P_LE); % position dual quaternion for P_LE
        S_tot = DQmult(R_LU,T_ES,R_UB);
        P_BS_dq = DQmult(DQconj(S_tot),P_LE_dq,S_tot); % Forward kinematics computation
        P_BS = dquat2pos(P_BS_dq);
        
        % velocity (see equation (18) in the article)
        P_UE_dq = DQmult(DQconj(R_LU),P_LE_dq,R_LU); % position of the end-effector in (upper arm)-fixed elbow centered coordinates
        antisym_LU = 0.5*(DQmult(P_UE_dq,Omega_LU)-DQmult(Omega_LU,P_UE_dq));
        antisym_UB = 0.5*(DQmult(P_BS_dq,Omega_UB)-DQmult(Omega_UB,P_BS_dq));
        vel_P_BS_dq = antisym_UB + DQmult(DQconj(R_UB),antisym_LU,R_UB);
        vel_P_BS = dquat2vel(vel_P_BS_dq);        
%% Using screw motions 
    elseif choice_representation == 2% screw motion representation: the used reference frame is shoulder-centered body-fixed
        % parameters of the screw motion of the lower arm around the elbow
        d_LU = 0; % translation distance along the screw motion axis
        axispoint_LU = [a 0 0]'; % offset between the screw motion axis line and the origin (in the reference configuration)
        S_LU = screw2dquat(theta_LU,d_LU,axis_LU,axispoint_LU); % screw motion dual quaternion of the lower arm around the elbow.
                                                                % obviously, there is no translation component along the screw axis.
        S_LU_dot = screwvel2dquat(Omega_speed_LU,Omega_axis_LU,0,[0 0 0],S_LU); % screw motion velocity dual quaternion (due to the rotational speed only)
        
        % parameters of the screw motion of the upper arm around the shoulder
        d_UB = 0;
        axispoint_UB = [0 0 0]';
        S_UB = screw2dquat(theta_UB,d_UB,axis_UB,axispoint_UB);
        S_UB_dot = screwvel2dquat(Omega_speed_UB,Omega_axis_UB,0,[0 0 0],S_UB);
        
        % position
        P_BS_0 = [a+b 0 0]'; % reference position (arm extended) of the end-effector (in body fixed shoulder centered coordinates)
        P_BS_0_dq = pos2dquat(P_BS_0);
        S_tot = DQmult(S_LU,S_UB);
        P_BS_dq = DQmult(DQconj(S_tot),P_BS_0_dq,S_tot); % Forward kinematics computation
        P_BS = dquat2pos(P_BS_dq);
        
        % velocity
        P_elbow_dq = DQmult(DQconj(S_LU),P_BS_0_dq,S_LU);
        comp_UB_dot = DQmult(DQconj(S_UB_dot),P_elbow_dq,S_UB)+DQmult(DQconj(S_UB),P_elbow_dq,S_UB_dot);
        comp_LU_dot = DQmult(DQconj(S_LU_dot),P_BS_0_dq,S_LU)+DQmult(DQconj(S_LU),P_BS_0_dq,S_LU_dot);
        vel_P_BS_dq = comp_UB_dot+DQmult(DQconj(S_UB),comp_LU_dot,S_UB);
        vel_P_BS = dquat2vel(vel_P_BS_dq);
    end
    disp('The two-link arm end-effector position (in body-fixed shoulder-centered coordinates) is :');
    disp(P_BS);    
    disp('The two-link arm end-effector velocity (in body-fixed shoulder-centered coordinates) is :');
    disp(vel_P_BS);
    
    %% Forward kinematics of the end-effector of a three-link arm (point and line transformations)
elseif choice_arm == 3 % the three-link arm is considered
    %% Using rotations and translations
    if choice_representation == 1 % rotations and translations operators
        % rotation, translation and rotational velocities dual quaternions
        R_UB = rot2dquat(theta_UB,axis_UB); % rotation dual quaternion of the upper arm around the shoulder
        R_LU = rot2dquat(theta_LU,axis_LU); % rotation dual quaternion of the lower arm around the elbow
        R_HL = rot2dquat(theta_HL,axis_HL); % rotation dual quaternion of the hand around the wrist
        T_ES = trans2dquat([1 0 0]',a); % translation dual quaternion  specifying the offset between the elbow and the shoulder
        T_WE = trans2dquat([1 0 0]',b); % translation dual quaternion  specifying the offset between the wrist and the elbow

        Omega_UB = rotvel2dquat(Omega_speed_UB,Omega_axis_UB); % rotational velocity dual quaternion of the upper arm around the shoulder
        Omega_LU = rotvel2dquat(Omega_speed_LU,Omega_axis_LU); % rotational velocity dual quaternion of the lower arm around the elbow
        Omega_HL = rotvel2dquat(Omega_speed_HL,Omega_axis_HL); % rotational velocity dual quaternion of the hand around the wrist
        
        % position
        orientation_tool_H = [0 1 0]'; % tool (end-effector) orientation in hand-fixed coordinates
        position_tool_HW = [c 0 0]'; % tool position in hand-fixed wrist-centered coordinates
        L_HW_dq = line2dquat(orientation_tool_H,position_tool_HW); % line position dual quaternion in hand-fixed wrist-centered coordinates
        P_HW_dq = pos2dquat(position_tool_HW); % position dual quaternion specifying the tool position in hand-fixed wrist-centered coordinates
        S_tot = DQmult(R_HL,T_WE,R_LU,T_ES,R_UB);
        L_BS_dq = DQmult(DQconj(S_tot,'line'),L_HW_dq,S_tot); % Forward kinematics computation for the line position
        P_BS_dq = DQmult(DQconj(S_tot),P_HW_dq,S_tot);
        [orientation_tool_B,r] = dquat2line(L_BS_dq);
        P_BS = dquat2pos(P_BS_dq);
        
        % velocity
        orientation_tool_H_dot = [0 0 0]'; % the tool orientation rate of change (in hand-fixed coordinates)
        position_tool_H_dot = [0 0 0]'; % the tool velocity (in hand-fixed coordinates)        
        L_HW_dot = linevel2dquat(orientation_tool_H,position_tool_HW,orientation_tool_H_dot,position_tool_H_dot); 
        P_HW_dot_dq = vel2dquat(position_tool_H_dot);
        
        % end-effector orientation (line transfo)
        T_WE_R_LU = DQmult(T_WE,R_LU);
        L_LW = DQmult(DQconj(R_HL),L_HW_dq,R_HL);
        L_UE = DQmult(DQconj(T_WE_R_LU,'line'),L_LW,T_WE_R_LU);
        antisym_UB = 0.5*(DQmult(L_BS_dq,Omega_UB)-DQmult(Omega_UB,L_BS_dq));
        antisym_LU = 0.5*(DQmult(L_UE,Omega_LU)-DQmult(Omega_LU,L_UE));
        antisym_HL = 0.5*(DQmult(L_LW,Omega_HL)-DQmult(Omega_HL,L_LW));
        R_LU_R_UB = DQmult(R_LU,R_UB);
        R_tot = DQmult(R_HL,R_LU,R_UB);
        L_BS_dot = antisym_UB+...
                   DQmult(DQconj(R_UB),antisym_LU,R_UB)+...
                   DQmult(DQconj(R_LU_R_UB),antisym_HL,R_LU_R_UB)+...
                   DQmult(DQconj(R_tot),L_HW_dot,R_tot);
        [orientation_tool_B_dot,MP] = dquat2linevel(L_BS_dot) ;
        
        % end-effector position (point transfo)        
        P_LW = DQmult(DQconj(R_HL),P_HW_dq,R_HL);
        P_UE = DQmult(DQconj(T_WE_R_LU),P_LW,T_WE_R_LU);
        antisym_P_UB = 0.5*(DQmult(P_BS_dq,Omega_UB)-DQmult(Omega_UB,P_BS_dq));
        antisym_P_LU = 0.5*(DQmult(P_UE,Omega_LU)-DQmult(Omega_LU,P_UE));
        antisym_P_HL = 0.5*(DQmult(P_LW,Omega_HL)-DQmult(Omega_HL,P_LW));
        P_BS_dot_dq = antisym_P_UB+...
            DQmult(DQconj(R_UB),antisym_P_LU,R_UB)+...
            DQmult(DQconj(R_LU_R_UB),antisym_P_HL,R_LU_R_UB)+...
            DQmult(DQconj(R_tot),P_HW_dot_dq,R_tot);
        P_BS_dot = dquat2vel(P_BS_dot_dq);
    %% Using screw motions  
    elseif choice_representation == 2% screw motion representation: the used reference frame is shoulder-centered body-fixed
        % parameters of the screw motion of the lower arm around the elbow
        d_HL = 0; % translation distance along the screw motion axis
        axispoint_HL = [a+b 0 0]'; % offset between the screw motion axis line and the origin (in the reference configuration)
        S_HL = screw2dquat(theta_HL,d_HL,axis_HL,axispoint_HL); % screw motion dual quaternion of the hand around the wrist.
                                                                % obviously, there is no translation component along the screw axis.
        S_HL_dot = screwvel2dquat(Omega_speed_HL,Omega_axis_HL,0,[0 0 0],S_HL); % screw motion velocity dual quaternion (due to the rotational speed only)
        
        % parameters of the screw motion of the lower arm around the elbow
        d_LU = 0; % translation distance along the screw motion axis
        axispoint_LU = [a 0 0]'; % offset between the screw motion axis line and the origin (in the reference configuration)
        S_LU = screw2dquat(theta_LU,d_LU,axis_LU,axispoint_LU); % screw motion dual quaternion of the lower arm around the elbow.
                                                                % obviously, there is no translation component along the screw axis.
        S_LU_dot = screwvel2dquat(Omega_speed_LU,Omega_axis_LU,0,[0 0 0],S_LU); % screw motion velocity dual quaternion (due to the rotational speed only)
        
        % parameters of the screw motion of the upper arm around the shoulder
        d_UB = 0;
        axispoint_UB = [0 0 0]';
        S_UB = screw2dquat(theta_UB,d_UB,axis_UB,axispoint_UB);
        S_UB_dot = screwvel2dquat(Omega_speed_UB,Omega_axis_UB,0,[0 0 0],S_UB);
        
        % position 
        orientation_tool_0 = [0 1 0]'; % reference orientation of the end-effector (in body fixed shoulder centered coordinates)
        position_tool_0 = [a+b+c 0 0]'; % reference position (arm extended) of the end-effector (in body fixed shoulder centered coordinates)
        P_BS_0_dq = pos2dquat(position_tool_0);
        L_BS_0 = line2dquat(orientation_tool_0,position_tool_0);
        S_tot = DQmult(S_HL,S_LU,S_UB);
        L_BS = DQmult(DQconj(S_tot,'line'),L_BS_0,S_tot); % Forward kinematics computation for the line position
        P_BS_dq = DQmult(DQconj(S_tot),P_BS_0_dq,S_tot);
        [orientation_tool_B,r] = dquat2line(L_BS);
        P_BS = dquat2pos(P_BS_dq);
                
        % velocity
        orientation_tool_0_dot = [0 0 0]'; % the reference orientation rate of change
        position_tool_0_dot = [0 0 0]'; % the reference tool velocity
        L_BS_0_dot = linevel2dquat(orientation_tool_0,position_tool_0,orientation_tool_0_dot,position_tool_0_dot);      
        
        % end-effector orientation (line transfo)
        L_w = DQmult(DQconj(S_HL,'line'),L_BS_0,S_HL);
        L_e = DQmult(DQconj(S_LU,'line'),L_w,S_LU);
        comp_HL_dot = DQmult(DQconj(S_HL_dot,'line'),L_BS_0,S_HL)+DQmult(DQconj(S_HL,'line'),L_BS_0,S_HL_dot);
        comp_LU_dot = DQmult(DQconj(S_LU_dot,'line'),L_w,S_LU)+DQmult(DQconj(S_LU,'line'),L_w,S_LU_dot);
        comp_UB_dot = DQmult(DQconj(S_UB_dot,'line'),L_e,S_UB)+DQmult(DQconj(S_UB,'line'),L_e,S_UB_dot);
        S_LU_S_UB = DQmult(S_LU,S_UB);
        L_BS_dot = DQmult(DQconj(S_tot,'line'),L_BS_0_dot,S_tot)+...
                   DQmult(DQconj(S_LU_S_UB,'line'),comp_HL_dot,S_LU_S_UB)+...
                   DQmult(DQconj(S_UB,'line'),comp_LU_dot,S_LU_S_UB)+...
                   comp_UB_dot;
        [orientation_tool_B_dot,MP] = dquat2linevel(L_BS_dot);
        
        % end-effector position (point transfo)
        P_BS_0_dot_dq = vel2dquat(position_tool_0_dot);
        P_w = DQmult(DQconj(S_HL),P_BS_0_dq,S_HL);
        P_e = DQmult(DQconj(S_LU),P_w,S_LU);
        comp_P_HL_dot = DQmult(DQconj(S_HL_dot),P_BS_0_dq,S_HL)+DQmult(DQconj(S_HL),P_BS_0_dq,S_HL_dot);
        comp_P_LU_dot = DQmult(DQconj(S_LU_dot),P_w,S_LU)+DQmult(DQconj(S_LU),P_w,S_LU_dot);
        comp_P_UB_dot = DQmult(DQconj(S_UB_dot),P_e,S_UB)+DQmult(DQconj(S_UB),P_e,S_UB_dot);
        P_BS_dot_dq = DQmult(DQconj(S_tot),P_BS_0_dot_dq,S_tot)+...
                      DQmult(DQconj(S_LU_S_UB),comp_P_HL_dot,S_LU_S_UB)+...
                      DQmult(DQconj(S_UB),comp_P_LU_dot,S_LU_S_UB)+...
                      comp_P_UB_dot;
        P_BS_dot = dquat2vel(P_BS_dot_dq);      
    end 
    disp('The three-link arm end-effector position (in body-fixed shoulder-centered coordinates) is :');
    disp(P_BS);
    disp('The three-link arm end-effector velocity (in body-fixed shoulder-centered coordinates) is :');
    disp(P_BS_dot);
    disp('The three-link arm end-effector orientation (in body-fixed coordinates) is :');
    disp(orientation_tool_B);
    disp('The three-link arm end-effector orientation rate of change (in body-fixed coordinates) is :');
    disp(orientation_tool_B_dot);
end



