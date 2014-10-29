function [J] = lab_jacobian(joints)
    %lab_jacobian returns the jacobian of the lab arm
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
    5, 0,  0, 2, th5

Ai = Rot(z,thi) * Trans(z,di) * Trans(x,ai) * Rot(x,alphi)
%}

arm_length = 10;

% getting DH params
a = [0,arm_length,arm_length,0,0];
alpha = [-pi/2, 0, 0, pi/2,0];
d = [10,0,0,0,2];
theta = [joints(1),joints(2) - pi/2, joints(3) + pi/2, joints(4) + pi/2, joints(5)];

    % constructing Ai
    A1 = rotz(theta(1)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
    A2 = rotz(theta(2)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
    A3 = rotz(theta(3)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));
    A4 = rotz(theta(4)) * transz(d(4)) * transx(a(4)) * rotx(alpha(4));
    A5 = rotz(theta(5)) * transz(d(5)) * transx(a(5)) * rotx(alpha(5));

    % gettin Ts
    T0 = eye(4);
    T1 = T0*A1;
    T2 = T1*A2;
    T3 = T2*A3;
    T4 = T3*A4;
    T5 = T4*A5;

    % constructing jacobian
    J = zeros(6);
    Jv1 = cross(get_z(T0), get_oc(T5) -get_oc(T0));
    Jv2 = cross(get_z(T1), get_oc(T5) -get_oc(T1));
    Jv3 = cross(get_z(T2), get_oc(T5) -get_oc(T2));
    Jv4 = cross(get_z(T3), get_oc(T5) -get_oc(T3));
    Jv5 = cross(get_z(T4), get_oc(T5) -get_oc(T4));

    Jw1 = get_z(T0);
    Jw2 = get_z(T1);
    Jw3 = get_z(T2);
    Jw4 = get_z(T3);
    Jw5 = get_z(T4);

J = [Jv1,Jv2,Jv3,Jv4,Jv5; Jw1,Jw2,Jw3,Jw4,Jw5];