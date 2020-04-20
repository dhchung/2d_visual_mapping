function run()
clc;clear all;close all;

global D2R R2D;
D2R = pi/180;
R2D = 180/pi;

K = [498.0944   0     318.3069;
     0      497.9453  248.2361;
     0          0     1.0000 ];
 
% K = [fx skew_cfx cx;
%      0     fy    cy;
%      0     0     1]
data_dir = getdatapath();

img_path = data_dir+"Imgs/";

image_files = dir(img_path+"*.jpg");
image_no = size(image_files,1);

img_num_vec = zeros(image_no,1);

Traj = load(data_dir+"Gantry_140226_1.txt");
Traj(:,4) = Traj(:,4)+320;

data_no = size(Traj,1);

for i = 1:image_no
    
    filename = image_files(i).name;
    
    check = 0;
    check_num = 0;
    for j = 1:size(filename,2)
        if filename(j)=='_'
            if check==0
                check = check+1;
            else
                check_num = j+1;
                break;
            end
        end
    end
    
    img_num = str2double(filename(check_num:end-4));
    img_num_vec(i) = img_num;
end
% [~, idx] = sort(img_num_vec);

for i = 1:data_no
    DrawRealTraj(Traj, i, 1);
    axis equal;
    xlabel X;
    ylabel Y;
    zlabel Z;
    hold off;
    
    Traj(i,5)
    
    img_idx = find(Traj(i,1)==img_num_vec);
    if isempty(img_idx)
        
        continue;
    end
        
        
    figure(2);
    I = imread(img_path+image_files(img_idx).name);
    imshow(I);
    drawnow;

end

end

function DrawRealTraj(Trajectory, i, figno)
global D2R R2D;

P = [2 0 0; -1 1 0; -1 -1 0; 2 0 0]*20;
R = [cos(Trajectory(i,5)*D2R) -sin(Trajectory(i,5)*D2R) 0;...
     sin(Trajectory(i,5)*D2R)  cos(Trajectory(i,5)*D2R) 0;...
     0                         0                        1];
T = [R Trajectory(i,2:4)';0 0 0 1];
P2 = (T*[P';ones(1,4)])';
P2 = P2(:,1:3);

figure(figno);
% plot3(P2(:,1),P2(:,2),P2(:,3),'g'); hold on;
fill3(P2(:,1),P2(:,2),P2(:,3),'g'); hold on;
plot3(Trajectory(1:i,2), Trajectory(1:i,3), Trajectory(1:i,4),'-b*');
hold off;
end