function [ R ] = rotz( th )
%rotz returns rotation matrix for a rotation around the z axis by theta
R = [
    cos(th), -sin(th), 0, 0;
    sin(th), cos(th), 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1;
    ];
end

