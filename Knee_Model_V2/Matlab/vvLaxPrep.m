function [] = vvLaxPrep()

%% define variables

ap_angs = [0;-15;-30;-45;-60;-75; -90];

%% create mot files to apply force

for jj = 1:size(ap_angs,1);
% for jj = 1
    
    theta = ap_angs(jj,1);
    F_mag = 10;
    T_r_p = [0;-0.064;0];
    dc = body312((3.14/180)*theta,0,0);
    F_r_p = dc*T_r_p;
    F_r_to = [-0.006;-0.449;0];
    
    time = (0:.01:28)';
    
    femur_r_force_vx = zeros(size(time));
    femur_r_force_vy = zeros(size(time));
    femur_r_force_vz = zeros(size(time));
    femur_r_force_px = (F_r_to(1)+F_r_p(1))*ones(size(time));
    femur_r_force_py = (F_r_to(2)+F_r_p(2))*ones(size(time));
    femur_r_force_pz = (F_r_to(3)+F_r_p(3))*ones(size(time));
    femur_r_force_tz = zeros(size(time));
    
    for i = 1:size(time,1)
        if time(i)<=2
            femur_r_force_tx(i,1) = 0;
            femur_r_force_ty(i,1) = 0;
        elseif (time(i)>2) & (time(i)<=14.5)
            Fx = F_mag*cosd(-1*theta);
            Fy = -F_mag*sind(-1*theta);
            femur_r_force_tx(i,1) = 0.5*Fx*cos((1/6.3)*pi*(time(i)-2))-0.5*Fx;
            femur_r_force_ty(i,1) = 0.5*Fy*cos((1/6.3)*pi*(time(i)-2))-0.5*Fy;
        elseif (time(i)>14.5) & (time(i)<=16.5)
            femur_r_force_tx(i,1) = 0;
            femur_r_force_ty(i,1) = 0;
        else
            Fx = F_mag*cosd(-1*theta);
            Fy = -F_mag*sind(-1*theta);
            femur_r_force_tx(i,1) = -1*(0.5*Fx*cos((1/5.8)*pi*(time(i)-16.5))-0.5*Fx);
            femur_r_force_ty(i,1) = -1*(0.5*Fy*cos((1/5.8)*pi*(time(i)-16.5))-0.5*Fy);
        end
    end
    
    figure('color','w');
    subplot(2,2,1);
    plot(time,femur_r_force_tx);
    set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
    xlim([0 28]);
    ylabel('Torque (Nm)');
    title('Tx');
    
    subplot(2,2,3);
    plot(time,femur_r_force_ty);
    set(gca,'box','off','FontSize',14);
    xlim([0 28]);
    xlabel('Time (s)');
    ylabel('Torque (Nm)');
    title('Ty');
    
    file = ['../VV_Laxity/vv_' num2str(-1*ap_angs(jj,1)) '.mot'];
    data =     [time   femur_r_force_vx   femur_r_force_vy   femur_r_force_vz   femur_r_force_px   femur_r_force_py   femur_r_force_pz   femur_r_force_tx   femur_r_force_ty   femur_r_force_tz];
    headers = {'time' 'femur_r_force_vx' 'femur_r_force_vy' 'femur_r_force_vz' 'femur_r_force_px' 'femur_r_force_py' 'femur_r_force_pz' 'femur_r_torque_x' 'femur_r_torque_y' 'femur_r_torque_z'};
    
    write_motion(file,data,headers)
    
    [c,i] = max(femur_r_force_vx);
    subplot(2,2,[2 4]);
    schmitz_display_stlFile('OS_Femur_Scaled','../Geometry/OpenSim Bones/');
    axis equal;
    view(0,90);
    set(gca,'box','off','FontSize',8);
    hold on;
    p1 = [femur_r_force_px(i,1) femur_r_force_py(i,1) femur_r_force_pz(i,1)];
    scale_factor = 0.01;
    u = scale_factor*femur_r_force_tx(i,1);
    v = scale_factor*femur_r_force_ty(i,1);
    w = scale_factor*femur_r_force_tz(i,1);
    quiver3(p1(1), p1(2), p1(3), u, v, w);
    ylim([-0.6 0.03]);
    xlim([-0.1 0.1]);
    
    lh = legend('Bone','Torque applied to tibia');
    set(lh,'EdgeColor','w');
    
    set(gcf, 'Position', get(0,'Screensize'));
    saveas(gcf,['../VV_Laxity/TorqueApplied_vv' num2str(-1*ap_angs(jj,1)) '.bmp']);
    close(gcf);
    
end