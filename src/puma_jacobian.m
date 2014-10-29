function [J] = puma_jacobian(joints)
    %puma_jacobian returns the jacobian of the puma arm
    %with respect to the jointe paramters passed in.

    % tool_pos = [x,y,z]
    % joint_params = [waist, shoulder, elbow, wr-roll, wr-pitch, end-roll]

    %{

    Ai = Rot(z,thi) * Trans(z,di) * Trans(x,ai) * Rot(x,alphi)
    %}
    shoulder_height = 13;
    upper_arm = 8;
    fore_arm = 8;
    ds = 2;
    de = 2;

    % getting DH params
    a = [0,upper_arm,0,0,0,0];
    alpha = [pi/2, 0, pi/2, pi/2, pi/2, 0];
    d = [shoulder_height,ds,0,fore_arm,0, de];
    theta = [joints(1),joints(2), joints(3) + pi/2,...
        joints(4), joints(5)+pi/2, joints(6)];

    % constructing Ai
    A1 = rotz(theta(1)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
    A2 = rotz(theta(2)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
    A3 = rotz(theta(3)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));
    A4 = rotz(theta(4)) * transz(d(4)) * transx(a(4)) * rotx(alpha(4));
    A5 = rotz(theta(5)) * transz(d(5)) * transx(a(5)) * rotx(alpha(5));
    A6 = rotz(theta(6)) * transz(d(6)) * transx(a(6)) * rotx(alpha(6));

    % gettin Ts
    T0 = eye(4);
    T1 = T0*A1;
    T2 = T1*A2;
    T3 = T2*A3;
    T4 = T3*A4;
    T5 = T4*A5;
    T6 = T5*A6;

    % constructing jacobian
    J = zeros(6);
    Jv1 = cross(get_z(T0), get_oc(T6) -get_oc(T0));
    Jv2 = cross(get_z(T1), get_oc(T6) -get_oc(T1));
    Jv3 = cross(get_z(T2), get_oc(T6) -get_oc(T2));
    Jv4 = cross(get_z(T3), get_oc(T6) -get_oc(T3));
    Jv5 = cross(get_z(T4), get_oc(T6) -get_oc(T4));
    Jv6 = cross(get_z(T5), get_oc(T6) -get_oc(T5));

    Jw1 = get_z(T0);
    Jw2 = get_z(T1);
    Jw3 = get_z(T2);
    Jw4 = get_z(T3);
    Jw5 = get_z(T4);
    Jw6 = get_z(T5);

J = [Jv1,Jv2,Jv3,Jv4,Jv5,Jv6; Jw1,Jw2,Jw3,Jw4,Jw5,Jw6];