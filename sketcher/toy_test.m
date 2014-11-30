% Toy script
% tests the pipeline with a small toy example
%{
clear;
close all;
addpath('matlab_bgl');

% constants
tries = 40;
min_len = 20;
name = 'data/pb/pb_10.png';

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
%}
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
close;
imshow(edge_im);
hold on;
plot(pxs(:),pys(:),'.');

figure;
% turning into trajectories
disp('getting workspace trajectories');
get_trajectories;

