function [x,T] = forwardKinematicsPlotting(u)
%% This function outputs the CRS Cat-5 end effector position
%  in the world x,y,z coordinate frame
% e.g [x,T] = forwardKinematics2014([theta1 theta2 ... theta5 track_pos])
% 1 vector inputs -- vector of {theta1,...,5 in degrees , track_pos in inches}
% 2 outputs - one vector of x,y,z position (x) in inches and
%             one 4x4 homogeneous transformation matrix (T) in inches
% Harvard SEAS -- ES 159/259
% Written by Ben Goldberg, Fall 2014 

global ll q1 q2 q3
persistent ncall
if isempty(ncall)
    ncall =1;
end

%Joint Limitations:
if (u(1)>180 || u(1)<-180 )
    error('Joint 1 Limits Exceeded');
elseif (u(2)<0 || u(2)>45)
    error('Joint 2 Limits Exceeded');
elseif (u(3)<-90 || u(3)>30)
    error('Joint 3 Limits Exceeded');
elseif (u(4)<-45 || u(4)>45)
    error('Joint 4 Limits Exceeded');
elseif (u(5)<-75 || u(5)>75)
    error('Joint 5 Limits Exceeded');
elseif (u(6)<0 || u(6)>38)
    error('Track Limits Exceeded');
end


Ltp = 0; %Track Intermediate frame offset
L1 = 10; %Shoulder Height (inches)
L2 = 10; %Shoulder Length (inches)
L3 = 10; %Elbow Length (inches)
L4 = 2;  %Wrist Length (inches)

             % a_i(in.)  alpha_i(deg)  d_i(in.)  theta_i(deg)

ARM_CONFIG = [  0            90         0         90;        ...
                0            -90        u(6)      0;         ...
                Ltp          0          0         -90;       ...
                0            -90        L1        u(1);      ...
                L2           0          0         u(2)-90;   ...
                L3           0          0         u(3)+90;   ...
                0            -90        0         u(4)-90;   ...
                0            0          L4        u(5)+180];
            
            %Compute Transformations and Plot
            n_links = length(ARM_CONFIG');
            baseframe = eye(3)*2; %Vectors for plotting coordinate frames
            pos = zeros(3,n_links+1); %Matrix for storing positions

            
            
            %Initializes the plot with the home position:
            if ncall == 1
                
                
                
                %Create, position, format figure:
                ff=figure(1);view(-154,18);axis equal;hold on;
                sz = [800 800]; % figure size
                screensize = get(0,'ScreenSize');
                xpos = ceil((screensize(3)-sz(2))/2); % center horizontally
                ypos = ceil((screensize(4)-sz(1))/2); % center vertically
                set(ff,'Color','w','Position',[xpos ypos sz]);
                set(get(ff, 'currentaxes'),'FontSize',16,'LineWidth',2);
                xlabel('X position (inches)');ylabel('Y position (inches)'); zlabel('Z position (inches)')
                title('CAT-5 Forward Kinematics with DH Framework')
                xlim([-22 22]);ylim([-25 25]);zlim([0 25]);
                
                for i=1:n_links
                    T = eye(4);
                    for j=1:i
                        T = T*DH(ARM_CONFIG(j,:));
                    end
                    pos(:,i+1) =  T(1:3,4);
                    tframe = T(1:3,1:3)*baseframe;
                    %Plot and define figure handles
                    q1(i) = quiver3(pos(1,i+1),pos(2,i+1),pos(3,i+1),tframe(1,1),tframe(2,1),tframe(3,1),'r','Linewidth',2);
                    q2(i) = quiver3(pos(1,i+1),pos(2,i+1),pos(3,i+1),tframe(1,2),tframe(2,2),tframe(3,2),'g','Linewidth',2);
                    q3(i) = quiver3(pos(1,i+1),pos(2,i+1),pos(3,i+1),tframe(1,3),tframe(2,3),tframe(3,3),'b','Linewidth',2);
                    ll(i) = line([pos(1,i) pos(1,i+1)],[pos(2,i) pos(2,i+1)],[pos(3,i) pos(3,i+1)]);
                    set(ll(i),'Linewidth',4,'Color',[0.4 0.4 0.4])
                end
                ncall = ncall+1;
                x = T(1:3,4);
            else
pause(.01)
                for i=1:n_links
                    T = eye(4);
                    for j=1:i
                        T = T*DH(ARM_CONFIG(j,:));
                    end
                    
                    pos(:,i+1) =  T(1:3,4);
                    tframe = T(1:3,1:3)*baseframe;
                    %Update figure handles
                    set(q1(i), 'XData', pos(1,i+1), 'YData', pos(2,i+1), 'ZData',pos(3,i+1),'UData', tframe(1,1),'VData', tframe(2,1),'WData',tframe(3,1))
                    set(q2(i), 'XData', pos(1,i+1), 'YData', pos(2,i+1), 'ZData',pos(3,i+1),'UData', tframe(1,2),'VData', tframe(2,2),'WData',tframe(3,2))
                    set(q3(i), 'XData', pos(1,i+1), 'YData', pos(2,i+1), 'ZData',pos(3,i+1),'UData', tframe(1,3),'VData', tframe(2,3),'WData',tframe(3,3))
                    set(ll(i), 'XData', [pos(1,i) pos(1,i+1)], 'YData', [pos(2,i) pos(2,i+1)], 'ZData', [pos(3,i) pos(3,i+1)])
                    x = T(1:3,4);
                end

%                 xlim([min(pos(1,:))-2.5 max(pos(1,:))+2.5]);ylim([-max(pos(2,:))-2.5 max(pos(2,:))+2.5]);zlim([0 max(pos(3,:))+2.5]);
            end
             
            
function [A] = DH(p)
a     = p(1);
alpha = p(2);
d     = p(3);
theta = p(4);

A = [cosd(theta) -sind(theta)*cosd(alpha) sind(theta)*sind(alpha)   a*cosd(theta); ...
     sind(theta) cosd(theta)*cosd(alpha)  -cosd(theta)*sind(alpha)  a*sind(theta); ...
         0             sind(alpha)              cosd(alpha)               d      ; ...
         0                  0                        0                    1       ];
            
            
