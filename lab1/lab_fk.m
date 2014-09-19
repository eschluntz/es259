function [ tool_pos] = lab_fk(joints)
%lab_fk returns the position of the tool frame relative to the base frame
%with respect to the jointe paramters passed in.

% tool_pos = [x,y,z]
% joint_params = [waist, shoulder, elbow, wrist pitch, wrist roll,
% displacement]

%{
link, ai, alphi, di, thi
    1, 0, -90, 10, th1       
    2, 10, 0, 0, th2-90
    3, 10, 0, 0, th3+90
    4, 0, 90, 0, th4+90
    5, 2,  0, 0, th5

Ai = Rot(z,thi) * Trans(z,di) * Trans(x,ai) * Rot(x,alphi)
%}

addpath('util/');

arm_length = 10;

% getting DH params
a = [0,arm_length,arm_length,0,0];
alpha = [-pi/2, 0, 0, pi/2,0];
d = [10,0,0,0,2];
theta = [joints(1),joints(2) - pi/2, joints(3) + pi/2, joints(4) + pi/2, joints(5)];

% constructing Ai
A0 = transx(joints(6)); % track underneith
A1 = rotz(theta(1)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
A2 = rotz(theta(2)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
A3 = rotz(theta(3)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));
A4 = rotz(theta(4)) * transz(d(4)) * transx(a(4)) * rotx(alpha(4));
A5 = rotz(theta(5)) * transz(d(5)) * transx(a(5)) * rotx(alpha(5));

% drawing base frame
draw_scene(30);

% combining for tool frame
T = eye(4);
draw_frame(T,5);
T = T*A0;
draw_frame(T,5);
T = T*A1;
draw_frame(T,5);
T = T*A2;
draw_frame(T,5);
T = T*A3;
draw_frame(T,5);
T = T*A4;
draw_frame(T,5);
T = T*A5;
draw_frame(T,5);

% origin in homogenous coords
tool_pos = inhomog(T * [0,0,0,1]');

end

