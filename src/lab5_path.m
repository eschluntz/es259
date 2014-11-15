clear;
close all;
addpath('util/');
% getting values from picture
filename = '../data/lab5example.jpg';
[start_px, goal_px] = image_detect(filename);

% converting from pixels to world coords
top_left = [25,11.5]; % x,y inches
inch_per_px = 23.5/320;

start = top_left + inch_per_px .* [-start_px(2), -start_px(1)];
goal = top_left + inch_per_px .* [-goal_px(2), -goal_px(1)];

% generating waypoints
z_travel = 8; % inches
z_pick = 2; % inches
g_close = 10; % mm
g_open = 65; % mm
t_zchange = 3;
t_wait = .5;
t_grip = 2; 
t_move = 4;
dt = .1;

%{ 
waypoint path:
above start
at start
pick up
above start
above goal
drop off
%}
X = [];
Y = [];
Z = [];
G = [];

% descent
X = [X, linspace(start(1), start(1), t_zchange/dt)];
Y = [Y, linspace(start(2), start(2), t_zchange/dt)];
Z = [Z, linspace(z_travel, z_pick, t_zchange/dt)];
G = [G, linspace(g_open, g_open, t_zchange/dt)];

% grab
X = [X, linspace(start(1), start(1), t_grip/dt)];
Y = [Y, linspace(start(2), start(2), t_grip/dt)];
Z = [Z, linspace(z_pick, z_pick, t_grip/dt)];
G = [G, linspace(g_open, g_close, t_grip/dt)];

% rise
X = [X, linspace(start(1), start(1), t_zchange/dt)];
Y = [Y, linspace(start(2), start(2), t_zchange/dt)];
Z = [Z, linspace(z_pick, z_travel, t_zchange/dt)];
G = [G, linspace(g_close, g_close, t_zchange/dt)];

% move
X = [X, linspace(start(1), goal(1), t_move/dt)];
Y = [Y, linspace(start(2), goal(2), t_move/dt)];
Z = [Z, linspace(z_travel, z_travel, t_move/dt)];
G = [G, linspace(g_close, g_close, t_move/dt)];

% drop
X = [X, linspace(goal(1), goal(1), t_grip/dt)];
Y = [Y, linspace(goal(2), goal(2), t_grip/dt)];
Z = [Z, linspace(z_travel, z_travel, t_grip/dt)];
G = [G, linspace(g_close, g_open, t_grip/dt)];

figure;
scatter3(X,Y,Z);

% converting to THETAS
n = size(X,2);
Thetas = zeros(5,n);
for i = 1:n
    [th1, th2, th3, th4, th5] = inverse_kinematics_lab5(X(i), Y(i), Z(i));
    Thetas(:,i) = [th1, th2, th3, th4, th5]';
end

% constructing A matrix

% track forward
ts = 9.9:dt:12-dt;
a1 = zeros(8,size(ts,2));
a1(1,:) = ts;
a1(8,:) = g_open;
a1(7,3:end) = linspace(0,381,size(ts,2) -2);

% to initial location
ts = 12:dt:15-dt;
a2 = zeros(8,size(ts,2));
a2(1,:) = ts;
for i = 1:5
    a2(i+1,:) = linspace(0,Thetas(i,1), size(ts,2));
end
a2(8,:) = g_open;
a2(7,:) = 381;

% do our movement
tf = 15 + dt * n;
ts = 15:dt:tf-dt;
a3 = zeros(8,size(ts,2));
a3(1,:) = ts;
a3(2:6,:) = Thetas;
a3(7,:) = 381;
a3(8,:) = G;

% clean up
ts = tf:dt:tf+5;
a4 = zeros(8,size(ts,2));
a4(1,:) = ts;
final_pos = [0,0,0,0,0,0,0,65]';
for i = 2:8
    a4(i,:) = linspace(a3(i,end), final_pos(i), size(ts,2));
end

a5 = [1000,0,0,0,0,0,0,65]';

a = [a1,a2,a3,a4,a5];

save('ERIK_PICK.mat', 'a');

for i = 1:size(a,2)
    cla;
    lab_fk(deg2rad(a(2:7,i)),false);
    pause(.01);
end













