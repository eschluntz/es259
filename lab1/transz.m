function [ T ] = transz( d )
%rotz returns rotation matrix for a rotation around the z axis by theta
T = [
    1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, d;
    0, 0, 0, 1;
    ];
end

