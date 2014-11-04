function [] = draw_planar_frame(T,s)
%draw_frame draws axes of an origin with the transformation matrix T

pts = [
    [s,0,0,1];
    [0,0,0,1];
    [0,s,0,1];
    ];

ir = inhomog(T * pts');

line(ir(1,1:2),ir(2,1:2), 'color','red');
line(ir(1,2:3),ir(2,2:3), 'color','blue');
end

