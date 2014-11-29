% Toy script
% tests the pipeline with a small toy example

clear;
close all;

addpath('myqueue_1.1');
% fake data
%img = tril(ones(10));
img = [ones(10,5), zeros(10,5)];
edge_im = edge(img);

% start process
disp('generating segments');
[Segs, Starts, Ends] = generate_segments(img);

disp('assigning segments');
Segs = assign_fs(Segs, edge_im);

% get best curve
disp('getting best');
find_curve;

imshow(img);
hold on;
plot(curve(:,1), curve(:,2));
