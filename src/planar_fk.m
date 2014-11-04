function [ Os, T] = planar_fk(joints, fast)
%planar_fk returns the position of the tool frame relative to the base frame
% for a 3 link 2D robot

% tool_pos = [x,y,z]
% joint_params = [waist, shoulder, elbow, wrist pitch, wrist roll,
% displacement]

%{
link, ai, alphi, di, thi
    1, 1, 0, 0, th1       
    2, 1, 0, 0, th2
    3, 1, 0, 0, th3

Ai = Rot(z,thi) * Trans(z,di) * Trans(x,ai) * Rot(x,alphi)
%}

assert(numel(joints) == 3);

% getting DH params
arm_length = 1;
a = [arm_length,arm_length,arm_length];
alpha = [0, 0, 0];
d = [0, 0, 0];
theta = [joints(1), joints(2), joints(3)];

% constructing Ai
A1 = rotz(theta(1)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
A2 = rotz(theta(2)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
A3 = rotz(theta(3)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));

Os = [];

if (fast)
    % combining for tool frame
    T = eye(4);
    Os = [Os, inhomog(T * [0,0,0,1]')];
    T = T*A1;
    Os = [Os, inhomog(T * [0,0,0,1]')];
    T = T*A2;
    Os = [Os, inhomog(T * [0,0,0,1]')];
    T = T*A3;
    Os = [Os, inhomog(T * [0,0,0,1]')];
else
    % drawing base frame
    draw_planar_scene(4);

    % combining for tool frame
    T = eye(4);
    Os = [Os, inhomog(T * [0,0,0,1]')];
    draw_planar_frame(T,.5);
    T = T*A1;
    Os = [Os, inhomog(T * [0,0,0,1]')];
    draw_planar_frame(T,.5);
    T = T*A2;
    Os = [Os, inhomog(T * [0,0,0,1]')];
    draw_planar_frame(T,.5);
    T = T*A3;
    Os = [Os, inhomog(T * [0,0,0,1]')];
    draw_planar_frame(T,.5);

end

end

