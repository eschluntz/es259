% Toy script
% tests the pipeline with a small toy example

clear;
close all;
addpath('matlab_bgl');
% fake data
%img = tril(ones(500));
%img = [ones(100,25), zeros(100,75)];

edge_im = imresize(double(imread('data/pb/pb_2.png')),[500,500]);
edge_im = edge_im / max(edge_im(:));
edge_im = edge_im .* (edge_im > .1);
%edge_im = edge(img);

% connect image
se = strel('disk',1);
edge_im = imclose(edge_im,se);

% data structure
G = sparse(numel(edge_im),numel(edge_im));
Curves = zeros(1000,50);

% create edges
disp('generating edges');
generate_segments;

% find longest
disp('finding paths');
long_search;
