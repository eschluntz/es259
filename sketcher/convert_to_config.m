function [a] = convert_to_config(xyz, name)
% converting to THETAS

addpath('../src');
addpath('../src/util');
dt = .1;
X = xyz(:,1);
Y = xyz(:,2);
Z = xyz(:,3);

n = size(X,1);
Thetas = zeros(5,n);
for i = 1:n
    [th1, th2, th3, th4, th5] = inverse_kinematics_sketcher(X(i), Y(i), Z(i));
    Thetas(:,i) = [th1, th2, th3, th4, th5]';
end

% constructing A matrix

% track forward
ts = 9.9:dt:12-dt;
a1 = zeros(7,size(ts,2));
a1(1,:) = ts;
a1(7,3:end) = linspace(0,381,size(ts,2) -2);

% to initial location
ts = 12:dt:15-dt;
a2 = zeros(7,size(ts,2));
a2(1,:) = ts;
for i = 1:5
    a2(i+1,:) = linspace(0,Thetas(i,1), size(ts,2));
end
a2(7,:) = 381;

% do our movement
tf = 15 + dt * n;
ts = 15:dt:tf-dt;
a3 = zeros(7,size(ts,2));
a3(1,:) = ts;
a3(2:6,:) = Thetas;
a3(7,:) = 381;

% clean up
ts = tf:dt:tf+5;
a4 = zeros(7,size(ts,2));
a4(1,:) = ts;
final_pos = [0,0,0,0,0,0,0,65]';
for i = 2:7
    a4(i,:) = linspace(a3(i,end), final_pos(i), size(ts,2));
end

a5 = [1000,0,0,0,0,0,0]';

a = [a1,a2,a3,a4,a5];

save(name, 'a');

num_errors = sum(~isfinite(a(:)))
assert(num_errors == 0);

end
