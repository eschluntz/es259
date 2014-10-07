function [ R ] = rotx( th )
%rotz returns rotation matrix for a rotation around the x axis by theta
R = [
    1, 0, 0, 0;
    0, cos(th), -sin(th), 0;
    0, sin(th), cos(th), 0;
    0, 0, 0, 1;
    ];
end

