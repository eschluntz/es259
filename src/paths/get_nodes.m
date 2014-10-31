function [ nodes ] = get_nodes( xs, ys, n )
%get_nodes generates n_nodes random points within constraints
%   x_lim = [x1, x2] etc
%   nodes = [x1, y1; ...; xn, yn] 
dx = xs(2) - xs(1);
dy = ys(2) - ys(1);

M = repmat([dx,dy], n,1);
B = repmat([xs(1),ys(1)], n,1);
nodes = M .* rand(n,2) + B;
end

