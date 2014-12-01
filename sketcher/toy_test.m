% Toy script
% tests the pipeline with a small toy example
close all;

clear;
close all;
addpath('matlab_bgl');

% constants
tries = 40;
min_len = 20;
name = 'data/pb/pb_6.png';
save_name = 'ERIK_DRAW_TAJ.mat';

img = imread('data/raw/lenna.jpg');
imshow(img);
figure;
% load image
disp('getting image');
edge_im = load_img(name);

% data structure
disp('creating graph');
G = sparse(numel(edge_im),numel(edge_im));

% create edges
disp('generating edges');
G = generate_segments(G, edge_im);

% find paths
disp('finding paths');
[axs, ays, alens] = long_search(G, size(edge_im), tries);

% get best paths
disp('picking best paths');
picks = find(alens > min_len);
pxs = axs(:,picks);
pys = ays(:,picks);
lens = alens(picks);

% replacing zeros
pxs(~pxs) = NaN;
pys(~pys) = NaN;

% displaying best paths
figure;
imshow(edge_im);
hold on;
plot(pxs(:),pys(:),'.');

% turning into trajectories
disp('getting workspace trajectories');
xyz = get_trajectories(pxs, pys, lens);

% turn into configuration space
disp('going to config space');
a = convert_to_config(xyz, save_name);

% drawing
figure;
for i = 1:size(a,2)
    cla;
    lab_fk(deg2rad(a(2:7,i)),false);
    pause(.01);
end

