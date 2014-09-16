function [ tool_pos, T] = lab_fk(joints)
%lab_fk returns the position of the tool frame relative to the base frame
%with respect to the jointe paramters passed in.

% tool_pos = [x,y,z]
% joint_params = [waist, shoulder, elbow, wrist pitch, wrist roll,
% displacement]

%{
link, ai, alphi, di, thi
    1, 0, 90, 10, 90+th1       
    2, 10, 0, 0, 90+th2
    3, 10, 0, 0, th3
    4, 0, 90, 0, 90+th4

Ai = Rot(z,thi) * Trans(z,di) * Trans(x,ai) * Rot(x,alphi)
%}


% getting DH params
a = [0,10,10,0,0];
alpha = [-pi/2, 0, 0, pi/2,0];
d = [10,0,0,0,0];
theta = [joints(1),joints(2), joints(3), joints(4), joints(5)];

% constructing Ai
A1 = rotz(theta(1)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
A2 = rotz(theta(2)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
A3 = rotz(theta(3)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));
A4 = rotz(theta(4)) * transz(d(4)) * transx(a(4)) * rotx(alpha(4));
A5 = rotz(theta(5)) * transz(d(5)) * transx(a(5)) * rotx(alpha(5));

% combining for tool frame
T = A1*A2*A3*A4*A5;

draw_frame(eye(4),5);
draw_frame(A1,5);
draw_frame(A1*A2,5);
draw_frame(A1*A2*A3,5);
draw_frame(A1*A2*A3*A4,5);
draw_frame(A1*A2*A3*A4*A5,5);

% origin in homogenous coords
tool_pos = inhomog(T * [0,0,0,1]');

end

