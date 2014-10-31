clear;
close all;
% using the Matlab BGL graph library
addpath('matlab_bgl');

% workspace bounds
x_lim = [0,10];
y_lim = [0,10];

% obstacles
O = [6,6; 3,6; 9,6];
rads = [1,1,2]'; 
tool_rad = .25;
rads = rads + tool_rad * ones(size(rads));% include tool radius

radsSq = rads.*rads;
% other
start = [0,0];
finish = [10,10];

% creating nodes
intermediate_nodes = 50; % use n_nodes to include start and finish
nodes = get_nodes(x_lim, y_lim, intermediate_nodes);
nodes = [start; finish; nodes];
n_nodes = intermediate_nodes+2;
A = sparse(n_nodes,n_nodes);

% checking paths
for i = 1:n_nodes
    for j = 1:n_nodes
        if valid_segment(nodes(i,:), nodes(j,:), O, radsSq)
            A(i,j) = norm(nodes(i,:) - nodes(j,:));
            A(j,i) = A(i,j);
        end
    end
end

% getting shortest path
diff = nodes - repmat(finish,n_nodes,1);
heuristic = sqrt(sum(diff.*diff,2));
[d, pred, rank] = astar_search(A,1,heuristic);

disp('done');
draw(A,nodes);

% drawing shortest path
draw_sp(pred,nodes, 1, 2);

% extract waypoints of shortest path
wps = get_waypoints(pred, nodes, 1, 2);
wps = smaller_steps(wps,.5);

% now doing everything again to smooth -----------------------
nodes = wps;
n_nodes = size(wps,1);
A = sparse(n_nodes,n_nodes);
% checking paths
for i = 1:n_nodes
    for j = 1:n_nodes
        if valid_segment(nodes(i,:), nodes(j,:), O, radsSq)
            A(i,j) = norm(nodes(i,:) - nodes(j,:));
            A(j,i) = A(i,j);
        end
    end
end

% getting shortest path
diff = nodes - repmat(finish,n_nodes,1);
heuristic = sqrt(sum(diff.*diff,2));
[d, pred, rank] = astar_search(A,1,heuristic);

disp('done');
draw(A,nodes);

% drawing shortest path
draw_sp(pred,nodes, 1, n_nodes);

% extract waypoints of shortest path
wps = get_waypoints(pred, nodes, 1, n_nodes);
wps = smaller_steps(wps,.5);


figure;
scatter(wps(:,1),wps(:,2));

thetas = [];

% getting inverse kinematics to control the arm
tool_z = 6;
for i = 1:size(wps,1)
    [th1, th2, th3, th4, th5] = inverse_kinematics_lab4(wps(1),wps(2), tool_z);
    ths = [th1, th2, th3, th4, th5]';
    thetas = [thetas, ths];
end

% constructing A matrix
dt = 0.1;
tf = dt*size(thetas,2) + 9.9
t_vect = 9.9:dt:tf;
a = zeros(6,length(t_vect)+1);
a(1,1:end-1) = t_vect;
a(1,end) = 100000;
a(2:6,end-1:end) = zeros(5,2);

disp('Each joint trajetory should be a row vector of length:')
disp(num2str(size(a,2)-3))

theta1 = thetas(1,:);
theta2 = thetas(2,:);
theta3 = thetas(3,:);
theta4 = thetas(4,:);
theta5 = thetas(5,:);

%%%%%%%%%%%%%%%%%%%%%%

a(2,2:end-2) = theta1;
a(3,2:end-2) = theta2;
a(4,2:end-2) = theta3;
a(5,2:end-2) = theta4;
a(6,2:end-2) = theta5;