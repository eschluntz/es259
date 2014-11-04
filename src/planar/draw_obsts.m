function [  ] = draw_obsts( obsts )
%draw_obsts draws [x,y,r]' obstacles
%   Detailed explanation goes here

for i = 1:size(obsts,2)
    d = obsts(3,i)*2;
    px = obsts(1,i)-obsts(3,i);
    py = obsts(2,i)-obsts(3,i);
    rectangle('Position',[px py d d],'Curvature',[1,1]);

end

