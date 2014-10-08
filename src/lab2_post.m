clear; close all;

% getting data
addpath('lab2data/');
addpath('util/');
load('lab2data\measured_angles.mat');
load('lab2data\predicted_angles.mat');
load('lab2data\commanded_position.mat');
load('lab2data\predicted_position.mat');

% recalculating predicted angles
pred_angs = predicted_angles;
validity = -ones(1,size(predicted_angles,2));
TS = size(predicted_angles,2);
step = 100;
for i = 1:step:TS
    joints = [deg2rad(measured_angles(2:6,i))',0];
    [toolpos, T] = lab_fk(joints, true);
    [Q, is_valid] = lab_ik(T);
    validity(i:i+step-1) = is_valid;
    pred_angs(2:6,i:i+step-1) = repmat(rad2deg(Q),1,step);
    if (mod(i,1000) == 1)
        percent = i/TS * 100 
    end
end

plot(validity,'.');
figure;
plot(measured_angles(2:6,:)');
hold on;
plot(pred_angs(2:6,:)','.');
