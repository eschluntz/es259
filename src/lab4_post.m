clear; close all;
addpath('util/');


%% Question 1
% getting data 
addpath('../data/Lab4PathPlanningTrial3/');
load measured_joint_angles;
load measured_joint_velocity;
load measured_world_position;
load measured_world_velocity;
load ERIK_SCHLUNTZ_AVOID2;
cmd_joint_angles = a;

% calculating predicted velocities
dt = a(1,2) - a(1,1);
cmd_joint_velocity = a;
cmd_joint_velocity(2:6,2:end) = ...
    (cmd_joint_velocity(2:6,2:end) - cmd_joint_velocity(2:6,1:end-1))/dt;
cmd_joint_velocity(2:6,1) = 0;
n = size(cmd_joint_velocity,2);

% calculating workspace velocities
cmd_world_velocity = cmd_joint_velocity(1:4,:);
for i = 1:n
   Jcb = lab_jacobian(deg2rad(cmd_joint_angles(2:6,i)));
   vel =  Jcb*cmd_joint_velocity(2:6,i);
   cmd_world_velocity(2:4,i) = vel(1:3);
end

% plotting
plot(cmd_joint_velocity(2:6,:)');
figure;
plot(measured_joint_velocity(2:6,:)');

% plotting
figure;
plot(cmd_world_velocity(2:4,:)');
figure;
plot(measured_world_velocity(2:4,:)');












