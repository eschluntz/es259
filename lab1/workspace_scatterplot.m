clear;
close all;
addpath('util/');
% draw a scatter plot of points in the work space by going through all
% possible combinations of angles

q1 = 0;
q2_a = 0;
q2_b = pi/4;
q3_a = -pi/2;
q3_b = pi/6;
q4_a = -pi/4;
q4_b = pi/4;
q5 = 0;
q6 = 0;

step = .05;
i = 1;
points = [];

for q2 = q2_a:step:q2_b
    for q3 = q3_a:step:q3_b
        for q4 = q4_a:step:q4_b
            % get the tool frame
            joints = [q1, q2, q3, q4, q5, q6];
            p = lab_fk(joints, true);
            points = [points, p];
            i = i + 1;
        end
        i
    end
end

figure;
scatter(points(1,:), points(3,:),'.');