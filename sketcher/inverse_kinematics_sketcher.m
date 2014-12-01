function [theta1, theta2, theta3, theta4, theta5] = inverse_kinematics_sketcher(x_tool, y_tool, z_tool)
% inverse kinematics for use a pencil attachement
% pencil tip is 4.5in below attachement
% pencil tip is 7/8in in front of attachement
d6 = 0; %ENTER TRACK LENGTH

tool_dz = 4.5; % in inches
tool_dx = 7/8;

x_tool = x_tool - d6;

%calculate wrist center

theta1 = atan2(y_tool, x_tool);

if theta1 >= 0
    theta1_vector = [theta1, theta1, theta1-pi, theta1-pi];
else
    theta1_vector = [theta1, theta1, theta1+pi, theta1+pi];
end

oc = [(x_tool - (2+tool_dx)*cos(theta1));(y_tool - (2+tool_dx)*sin(theta1));(z_tool+tool_dz)];

ocx = oc(1);
ocy = oc(2);
ocz = oc(3);

theta1 = atan2(ocy, ocx);

if theta1 >= 0
    theta1_vector = [theta1, theta1, theta1-pi, theta1-pi];
else
    theta1_vector = [theta1, theta1, theta1+pi, theta1+pi];
end

D  = (ocx^2 + ocy^2 + (ocz-10)^2 - 10^2 - 10^2)/(2*10*10);

theta3_pos = atan2(sqrt(1-D^2), D);
theta3_neg = atan2(-sqrt(1-D^2), D);

theta3_vector_init = [theta3_pos, theta3_neg, theta3_pos, theta3_neg];

theta2_vector_init = atan2(ocz-10, sqrt(ocx^2+ocy^2)) - atan2(10*sin(theta3_vector_init), 10+10*cos(theta3_vector_init));

theta3_vector = -theta3_vector_init - pi/2;

theta2_vector_one = pi/2 - theta2_vector_init;

theta2_vector = [theta2_vector_one(1), theta2_vector_one(2), (theta2_vector_one(3) - pi), (theta2_vector_one(4) - pi)];



%calculate theta 4 and theta 5
theta4_vector = -(theta3_vector+theta2_vector);
theta5_vector = [0, 0, 0, 0];

solution = [transpose(theta1_vector), transpose(theta2_vector), transpose(theta3_vector), transpose(theta4_vector), transpose(theta5_vector)];

solution*180/pi;

%throw out invalid solutions due to angle limits
for i = 1:4
    if (solution(i,2) > 60*pi/180) || (solution(i,2) < 0*pi/180) || (solution(i,3) > 30*pi/180) || (solution(i,3) < -90*pi/180) || (solution(i,4) < -110*pi/180) || (solution(i,4) > 110*pi/180) || (solution(i,5) < -180*pi/180) || (solution(i,5) >180*pi/180)
        norm(i) = inf;
    else
        norm(i) = sqrt(solution(i,1)^2 + solution(i,2)^2 + solution(i,3)^2 + solution(i,4)^2 + solution(i,5)^2);
    end
    if i == 1
        final_solution = solution(i,:);
                if norm(i) == inf
            final_solution = final_solution*inf;
        end
    elseif (i > 1) && (norm(i) < norm(i-1))
        final_solution = solution(i,:);
        if norm(i) == inf
            final_solution = final_solution*inf;
        end
    end
end

theta1 = final_solution(1)*180/pi;
theta2 = final_solution(2)*180/pi;
theta3 = final_solution(3)*180/pi;
theta4 = final_solution(4)*180/pi;
theta5 = final_solution(5)*180/pi;

function [A] = DH_function(a,alpha,d,theta)

A = [cos(theta) -sin(theta)*cos(alpha) sin(theta)*sin(alpha) a*cos(theta); sin(theta) cos(theta)*cos(alpha) -cos(theta)*sin(alpha) a*sin(theta); 0 sin(alpha) cos(alpha) d; 0 0 0 1];