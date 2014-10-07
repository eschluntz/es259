function [] = draw_frame(T,s)
%draw_frame draws axes of an origin with the transformation matrix T

s;
pts = [
    [s,0,0,1];
    [0,0,0,1];
    [0,s,0,1];
    [0,0,0,1];
    [0,0,s*1.2,1];
    [0,0,0,1];
    ];

ir = inhomog(T * pts');

line(ir(1,1:2),ir(2,1:2),ir(3,1:2), 'color','red');
line(ir(1,3:4),ir(2,3:4),ir(3,3:4), 'color','green');
line(ir(1,5:6),ir(2,5:6),ir(3,5:6), 'color','blue');
end

