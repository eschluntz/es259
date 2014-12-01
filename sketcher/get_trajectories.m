%function [xyz] = get_trajectories(pxs, pys, lens, im_size)
% turns a list of pixel paths into workspace trajectories
% .1s between each waypoint

xyz = [];

% constraints
px_min = min(pxs(:));
px_max = max(pxs(:));
py_min = min(pys(:));
py_max = max(pys(:));

wx_min = -7; % TODO
wx_max = 7;
wy_min = 20;
wy_max = 28;


% constants
z_draw = 8; % TODO
z_move = 9;
pts_up = 3; % number of points when doing vertical transitions
mv_speed = 1; % inches / .1 sec while moving
sample_rate = 10; % frequency of pixels to sample
n = size(lens);


% finding scaling factor, maintaining aspect ratio
x_ratio = (wx_max - wx_min) / (px_max - px_min);
y_ratio = (wy_max - wy_min) / (py_max - py_min);
ratio = min(x_ratio, y_ratio);

% centering
cpx = (px_max + px_min)/2;
cpy = (px_max + px_min)/2;
cwx = (wx_max + wx_min)/2;
cwy = (wy_max + wy_min)/2;
cur_pos = [cwx, cwy]; % current pos of arm

% shifting
xs = pxs - cpx;
ys = pys - cpy;

% scaling
xs = xs * ratio;
ys = ys * ratio;

% shifting to world center
xs = xs + cwx;
ys = ys + cwy;

% endpoints [x, y, curve, backwards?]
ends = [];
for j = 1:n
    ends = [ends; [xs(1,j), ys(1,j), j, 0]];
    ends = [ends; [xs(lens(j),j), ys(lens(j),j), j, 1]];
end

ends_orig = ends;
dt = .01;
%%%%%%%%%%%%%%%%% looping
while (size(ends,1))
    % getting closest
    dists = [ends(:,1) - cur_pos(1), ends(:,2) - cur_pos(2)];
    dists = sum(dists .* dists,2);
    [d,i] = min(dists);
    
    disp('closest');
    disp(i);
    disp(ends(i,:));

    % move to segment
    [seg, cur_pos] = move_to(cur_pos, ends(i,1:2), z_move, mv_speed);
    xyz = [xyz; seg];
    
    plot3(xyz(:,1), xyz(:,2), xyz(:,3));
    pause(dt);

    % go down
    seg = updn(cur_pos, z_move, z_draw, pts_up);
    xyz = [xyz; seg];
    
    plot3(xyz(:,1), xyz(:,2), xyz(:,3));
    pause(dt);

    % draw segment
    pi = ends(i, 3);
    [seg, cur_pos] = draw_to(cur_pos, xs(:,pi), ys(:,pi), ends(i,4), z_draw, sample_rate);
    xyz = [xyz; seg];
    
    plot3(xyz(:,1), xyz(:,2), xyz(:,3));
    pause(dt);

    % move up
    seg = updn(cur_pos, z_draw, z_move, pts_up);
    xyz = [xyz; seg];
    
    plot3(xyz(:,1), xyz(:,2), xyz(:,3));
    pause(dt);

    % remove ends
    % if backwards, 1 before, else 1 after
    sh = ends(i,4);
    ends(i+1-sh,:) = [];
    ends(i-sh,:) = [];
end

%plot3(xyz(:,1), xyz(:,2), xyz(:,3));
