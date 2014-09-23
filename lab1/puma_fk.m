function [ tool_pos] = puma_fk(joints, fast)
%puma_fk returns the position of the tool frame relative to the base frame
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

if (fast)
    T = A0*A1*A2*A3*A4*A5*A6;
else
    % drawing base frame
    draw_scene(30);

    % combining for tool frame
    T = eye(4);
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
    T = T*A6;
    draw_frame(T,5);
end
% origin in homogenous coords
tool_pos = inhomog(T * [0,0,0,1]');

end

