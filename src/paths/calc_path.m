clear;
close all;
% using the Matlab BGL graph library
addpath('matlab_bgl');

% workspace bounds
x_lim = [12,22];
y_lim = [-10,10];

% obstacles
%O = [18,-5; 15,-1; 16,4];
O = [12,5; 14,5; 16,5;   22,-5; 20,-5; 18,-5; 16,-5];
rads = [1,1,1,1,1,1,1]'; 
tool_rad = 1;
rads = rads + tool_rad * ones(size(rads));% include tool radius

radsSq = rads.*rads;
% other
start = [14,8];
finish = [17,-7.5];
tool_z = 6;
step_size = .5;
step_size_small = 1;

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
wps = smaller_steps(wps,step_size);

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
wps = smaller_steps(wps,step_size);


figure;
scatter(wps(:,1),wps(:,2));

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
wps = smaller_steps(wps,step_size_small);


figure;
scatter(wps(:,1),wps(:,2));


thetas = [];

% getting inverse kinematics to control the arm ----------
for i = 1:size(wps,1)
    [th1, th2, th3, th4, th5] = inverse_kinematics_lab4(wps(i,1),wps(i,2), tool_z);
    ths = [th1, th2, th3, th4, th5]';
    thetas = [thetas, ths];
end


theta1 = thetas(1,:);
theta2 = thetas(2,:);
theta3 = thetas(3,:);
theta4 = thetas(4,:);
theta5 = thetas(5,:);

% appending linspaces
[th1, th2, th3, th4, th5] = inverse_kinematics_lab4(start(1), start(2), tool_z);
theta1 = [linspace(0,th1, 20), theta1];
theta2 = [linspace(0,th2, 20), theta2];
theta3 = [linspace(0,th3, 20), theta3];
theta4 = [linspace(0,th4, 20), theta4];
theta5 = [linspace(0,th5, 20), theta5];

% constructing A matrix
dt = 0.1;
tf = dt*size(theta1,2) + 9.9
t_vect = 9.9:dt:tf;
a = zeros(6,length(t_vect)+2);

disp('sizes');
size(t_vect)
size(a(1,1:end-2))

a(1,1:end-2) = t_vect;
a(1,end) = 100000;
a(2:6,end-1:end) = zeros(5,2);

disp('Each joint trajetory should be a row vector of length:')
disp(num2str(size(a,2)-3))

%%%%%%%%%%%%%%%%%%%%%%

a(2,2:end-2) = theta1;
a(3,2:end-2) = theta2;
a(4,2:end-2) = theta3;
a(5,2:end-2) = theta4;
a(6,2:end-2) = theta5;