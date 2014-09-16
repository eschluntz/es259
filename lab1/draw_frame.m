function [] = draw_frame(T,s)
%draw_frame draws axes of an origin with the transformation matrix T

s;
pts = [
    [s,0,0,1];
    [0,0,0,1];
    [0,s,0,1];
    [0,0,0,1];
    [0,0,1.5*s,1];
    ];
ir = inhomog(T * pts');

line(ir(1,:),ir(2,:),ir(3,:), 'color','green');
end

