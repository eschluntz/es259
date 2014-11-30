function [] = trace_curve(s, len, img, Segs, T)

curve = [];
st = s;
for l = len:-1:1
    curve = [curve; Segs(st,:)];
    st = T(st,l);
end

cla;
imagesc(img);
hold on;

x = curve(:,1);
y = curve(:,2);
u = curve(:,3) - x; 
v = curve(:,4) - y;

quiver(x,y,u,v,0,'linewidth',2);
pause(.1);
end