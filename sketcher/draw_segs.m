function [] = draw_segs(Segs)
% quiver plots the segments to debug them
x = Segs(:,1);
y = Segs(:,2);
u = Segs(:,3) - x; 
v = Segs(:,4) - y;

u = u .* Segs(:,5);
v = v .* Segs(:,5);

quiver(x,y,u,v)
end