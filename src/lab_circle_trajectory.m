function [thetas] = lab_circle_trajectory(radius, dt, n, w)
% lab_circle_trajectory returns a set of angle waypoints to make a circle
q_default = zeros(1,6);
[origin, T] = lab_fk(q_default, true);
thetas = [];

origin(1) = origin(1) - radius; % starting location

% looping
t = 0;
for i = 1:n
    tp = origin + radius*[cos(w*t); sin(w*t); 0];
    T(1:3,4) = tp;
    [Q, valid] = lab_ik(T);
    
    thetas = [thetas, rad2deg(Q)];
    t = t + dt;
end
    