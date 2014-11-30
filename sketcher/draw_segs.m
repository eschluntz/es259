function [] = draw_segs(Segs)
% quiver plots the segments to debug them
x = Segs(:,1);
y = Segs(:,2);
u = Segs(:,3) - x; 
v = Segs(:,4) - y;

quiver(x,y,u,v,0)
end