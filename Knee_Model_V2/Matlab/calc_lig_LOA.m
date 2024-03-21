function [lig] = calc_lig_LOA(tx,ty,tz,r3,r1,r2)
% input angle in degrees!

% clc; clear all; close all;
% % tibia postion
% tx = 0;
% ty = 0;
% tz = 0;
% % tibia orientation (angles in radians)
% r3 = -70;  % flexion (about z) 
% r1 = 0;    % adduction (about x)
% r2 = 0;    % internal rotation (about y)
% num = [0 0 0 1 1 0];
% txt{2,1} = 'aACL';

[num,txt] = xlsread('../Geometry/Ligament_Attachments_Model5.xlsx');

for i = 2:size(txt,1)   % cycle through all ligaments
    % local position of femur attachment
    f_x = num(i-1,1);
    f_y = num(i-1,2);
    f_z = num(i-1,3);
    % local position of tibial attachment
    t_x = num(i-1,4);
    t_y = num(i-1,5);
    t_z = num(i-1,6);
    l_name = txt{i,1};
    for jj = 1:size(r3,1); % cycle through all frames of data
        f_p1 = [f_x f_y f_z]';
        t_p2 = [t_x t_y t_z]';
        f_p_ft = [tx(jj) ty(jj) tz(jj)]';
        f_R_t = body312(r3(jj)*3.14/180,r1(jj)*3.14/180,r2(jj)*3.14/180);
        
        f_p2 = f_p_ft + (f_R_t*t_p2);
        f_p12 = f_p2 - f_p1;
        
        lig.(genvarname(l_name)).tib_attach(jj,1:3) = f_p2';
        lig.(genvarname(l_name)).loa(jj,1:3) = (f_p12')./(norm(f_p12));
        
    end
end