function [x,T] = forwardKinematics(u)
%% This function outputs the CRS Cat-5 end effector position
%  in the world x,y,z coordinate frame
% e.g [x,T] = forwardKinematics2014([theta1 theta2 ... theta5 track_pos])
% 1 vector inputs -- vector of {theta1,...,5 in degrees , track_pos in inches}
% 2 outputs - one vector of x,y,z position (x) in inches and
%             one 4x4 homogeneous transformation matrix (T) in inches
% Harvard SEAS -- ES 159/259
% Written by Ben Goldberg, Fall 2014 

%Joint Limitations:
if (u(1)>180 || u(1)<-180 )
    error('Joint 1 Limits Exceeded');
elseif (u(2)<0 || u(2)>45)
    error('Joint 2 Limits Exceeded');
elseif (u(3)<-90 || u(3)>30)
    error('Joint 3 Limits Exceeded');
elseif (u(4)<-45 || u(4)>45)
    error('Joint 4 Limits Exceeded');
elseif (u(5)<-75 || u(5)>75)
    error('Joint 5 Limits Exceeded');
elseif (u(6)<0 || u(6)>38)
    error('Track Limits Exceeded');
end

Ltp = 0; %Track Intermediate frame offset
L1 = 10; %Shoulder Height (inches)
L2 = 10; %Shoulder Length (inches)
L3 = 10; %Elbow Length (inches)
L4 = 2;  %Wrist Length (inches)

             % a_i(in.)  alpha_i(deg)  d_i(in.)  theta_i(deg)

ARM_CONFIG = [  0            90         0         90;        ...
                0            -90        u(6)      0;         ...
                Ltp          0          0         -90;       ...
                0            -90        L1        u(1);      ...
                L2           0          0         u(2)-90;   ...
                L3           0          0         u(3)+90;   ...
                0            -90        0         u(4)-90;   ...
                0            0          L4        u(5)+180];
            
            AW = DH(ARM_CONFIG(1,:)); %World Frame
            A0 = DH(ARM_CONFIG(2,:)); %Track
            A1 = DH(ARM_CONFIG(3,:)); %Track Intermediate
            A2 = DH(ARM_CONFIG(4,:)); %Base
            A3 = DH(ARM_CONFIG(5,:)); %Shoulder
            A4 = DH(ARM_CONFIG(6,:)); %Elbow
            A5 = DH(ARM_CONFIG(7,:)); %Wrist Pitch
            A6 = DH(ARM_CONFIG(8,:)); %Wrist Roll and offset to end effector
            
            T = AW*A0*A1*A2*A3*A4*A5*A6; %Compute overall transformation
            
            x = T(1:3,4); %Pick out x,y,z position from transformation matrix
            
function [A] = DH(p)
a     = p(1);
alpha = p(2);
d     = p(3);
theta = p(4);

A = [cosd(theta) -sind(theta)*cosd(alpha) sind(theta)*sind(alpha)   a*cosd(theta); ...
     sind(theta) cosd(theta)*cosd(alpha)  -cosd(theta)*sind(alpha)  a*sind(theta); ...
         0             sind(alpha)              cosd(alpha)               d      ; ...
         0                  0                        0                    1       ];
            
            
