clear;
close all;

joints1 = [pi/4,pi/4,0,0,0,0];
joints2 = [-pi/6,0,-pi/6,pi/4,0,0];
joints3 = [pi, degtorad(13.5), degtorad(20), 0, 0, 4];
joints4 = [-pi/2, pi/4, -pi/2, 0, 0, 4];
joints5 = [-pi/2, 0, 0, 0, 0, 8];

% paramter sweep
a1 = -pi/8;
a2 = pi/8;
j = 1;
lab_fk(joints4)
%{
for th = a1:.1:a2
    % move joint
    joints(j) = th;
    [tool] = lab_fk(joints);
end

%}

