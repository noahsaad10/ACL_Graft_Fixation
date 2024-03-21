clc; clear all; close all;

[d,h] = load_sto('../Passive_Flexion/Runner18_states.sto');
[df,hf] = load_sto('../Passive_Flexion/Runner18_ForceReporter_forces.sto');
[dp,hp] = load_sto('../Passive_Flexion/Runner18_PointKinematics_pACL_t_pos.sto');

%% plot force in each ligament

ligs = {'aACL',3600;
        'pACL',4000;
		'aPCL',3600;
		'pPCL',1600;
		'LCL',2700;
        'PFL',1620;
		'CAPa',1350;
		'CAPl',2000;
		'CAPo',1500;
		'CAPm',2000;
		'aMCL',2000;
		'iMCL',2000;
        'pMCL',4000;
        'aCM',2000;
        'pCM',1800};
[force,stretch] = lig_properties2();

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};
count = 0;
leg_entries = {};
time = df(:,strcmp('time',hf));
k_flex = (180/3.14)*d(:,strcmp('/jointset/knee_r/knee_angle_r/value',h));

ii = find(time>2);

for i = 1:size(ligs,1)
% % for i = 1;
    count = count+1;
    leg_entries{i,1} = ligs{i,1};
    lig_force = df(:,strcmp(ligs{i,1},hf));
    subplot(2,1,1)
    hold on;
    plot(-k_flex(ii),lig_force(ii),l_type{count});
    for jj = 1:size(lig_force,1)
        lig_strain(jj) = interp1(force,stretch,lig_force(jj)/ligs{i,2})-1;
    end
    subplot(2,1,2)
    hold on;
    plot(-k_flex(ii),100*lig_strain(ii),l_type{count});
end
subplot(2,1,1)
lh = legend(leg_entries);
set(lh,'EdgeColor','w');
xlim([0 100]);
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
ylabel('Ligament Force (N)');

subplot(2,1,2)
set(gca,'box','off','FontSize',14);
xlim([0 100]);
xlabel('Flexion Angle (deg)');
ylabel('Ligament Strain (%)');

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../Passive_Flexion/Ligament_Forces.bmp');
saveas(gcf,'../Passive_Flexion/Ligament_Forces.fig');

%% plot force in each ligament for just flexion

[c,kk] = min(k_flex);

count = 0;
leg_entries = {};

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

for i = 1:size(ligs,1)
    count = count+1;
    leg_entries{i,1} = ligs{i,1};
    lig_force = df(:,strcmp(ligs{i,1},hf));
    subplot(2,1,1)
    hold on;
    plot(-k_flex(ii(1):kk),lig_force(ii(1):kk),l_type{count});
    for jj = 1:size(lig_force,1)
        lig_strain(jj) = interp1(force,stretch,lig_force(jj)/ligs{i,2})-1;
    end
    subplot(2,1,2)
    hold on;
    plot(-k_flex(ii(1):kk),100*lig_strain(ii(1):kk),l_type{count});
end
subplot(2,1,1)
lh = legend(leg_entries);
set(lh,'EdgeColor','w');
xlim([0 100]);
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
ylabel('Ligament Force (N)');

subplot(2,1,2)
set(gca,'box','off','FontSize',14);
xlim([0 100]);
xlabel('Flexion Angle (deg)');
ylabel('Ligament Strain (%)');

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../Passive_Flexion/Ligament_Forces_Flex.bmp');
saveas(gcf,'../Passive_Flexion/Ligament_Forces_Flex.fig');

%% plot degrees of freedom as functions of time

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

subplot(3,2,1);
plot(d(:,strcmp('time',h)),(180/3.14)*d(:,strcmp('/jointset/knee_r/knee_angle_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel(' ');
ylabel('Knee Angle (deg)');
title('+Extension');

subplot(3,2,3);
plot(d(:,strcmp('time',h)),(180/3.14)*d(:,strcmp('/jointset/knee_r/knee_add_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel(' ');
ylabel('Knee Angle (deg)');
title('+Adduction');

subplot(3,2,5);
plot(d(:,strcmp('time',h)),(180/3.14)*d(:,strcmp('/jointset/knee_r/knee_rot_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel('Time (s)');
ylabel('Knee Angle (deg)');
title('+Internal Rotation');

subplot(3,2,2);
plot(d(:,strcmp('time',h)),1000*d(:,strcmp('/jointset/knee_r/knee_tx_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel(' ');
ylabel('Position (mm)');
title('+Anterior');

subplot(3,2,4);
plot(d(:,strcmp('time',h)),1000*d(:,strcmp('/jointset/knee_r/knee_ty_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel(' ');
ylabel('Position (mm)');
title('+Superior');

subplot(3,2,6);
plot(d(:,strcmp('time',h)),1000*d(:,strcmp('/jointset/knee_r/knee_tz_r/value',h)))
set(gca,'box','off','FontSize',14);
xlabel('Time (s)');
ylabel('Position (mm)');
title('+Right (Lateral)');

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../Passive_Flexion/Kinematics.bmp');
saveas(gcf,'../Passive_Flexion/Kinematics.fig');

%% compare with literature

figure('color','w','units','normalized','outerposition',[0 0 1 1]);
ii = find(d(:,strcmp('time',h))>2);
ii1 = ii(1);
iip = find(dp(:,strcmp('time',hp))>2);
xx1 = 5:1:95;

subplot(3,2,1);
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_angle_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Angle (deg)');
title('+Flexion');

subplot(3,2,3);
% passive data from Wilson, D. R., et al. J Biomech 33, 465-473, 2000
fid = fopen('../Lit_Data/Wilson_Ave_AA.csv');
AA_Data = textscan(fid,'%f,%f');
fid2 = fopen('../Lit_Data/Wilson_SD_AA.csv');
AA_SD_Data = textscan(fid2,'%f,%f');
knee_angle3 = AA_Data{1,1}(:,1);
knee_var_rot = -1*AA_Data{1,2}(:,1);
var_sd = interp1(AA_SD_Data{1,1}(:,1),-1*AA_SD_Data{1,2}(:,1),knee_angle3)-knee_var_rot;
pp23 = griddedInterpolant(knee_angle3,knee_var_rot,'pchip');
v23 = pp23(xx1);
pp33 = griddedInterpolant(knee_angle3,var_sd,'pchip');
v33 = pp33(xx1);
hold on;
errorfill(xx1,v23,v33,'g-');
hold on;
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_add_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_add_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Angle (deg)');
title('+Adduction');

subplot(3,2,5);
% passive data from Wilson, D. R., et al. J Biomech 33, 465-473, 2000
fid = fopen('../Lit_Data/Wilson_Ave_IE.csv');
IE_Data = textscan(fid,'%f,%f');
fid2 = fopen('../Lit_Data/Wilson_SD_IE.csv');
IE_SD_Data = textscan(fid2,'%f,%f');
knee_angle5 = IE_Data{1,1}(:,1);
knee_int_rot = IE_Data{1,2}(:,1);
rot_sd = interp1(IE_SD_Data{1,1}(:,1),IE_SD_Data{1,2}(:,1),knee_angle5)-knee_int_rot;
pp25 = griddedInterpolant(knee_angle5,knee_int_rot,'pchip');
v25 = pp25(xx1);
pp35 = griddedInterpolant(knee_angle5,rot_sd,'pchip');
v35 = pp35(xx1);
hold on;
errorfill(xx1,v25,v35,'g-');
hold on;
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_rot_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_rot_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlabel('Flexion Angle (deg)');
xlim([0 100]);
ylabel('Angle (deg)');
title('+Internal Rotation');

subplot(3,2,2);
% passive data from Wilson, D. R., et al. J Biomech 33, 465-473, 2000
fid = fopen('../Lit_Data/Wilson_Ave_AP.csv');
AP_Data = textscan(fid,'%f,%f');
fid2 = fopen('../Lit_Data/Wilson_SD_AP.csv');
AP_SD_Data = textscan(fid2,'%f,%f');
knee_angle2 = AP_Data{1,1}(:,1);
knee_ap = -1*AP_Data{1,2}(:,1);
ap_sd = abs(interp1(AP_SD_Data{1,1}(:,1),-1*AP_SD_Data{1,2}(:,1),knee_angle2,'linear','extrap')-knee_ap);
pp22 = griddedInterpolant(knee_angle2,knee_ap,'pchip');
v22 = pp22(xx1);
pp32 = griddedInterpolant(knee_angle2,ap_sd,'pchip');
v32 = pp32(xx1);
hold on;
errorfill(xx1,v22,v32,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_tx = 1000*dp(iip,2)-1000*dp(iip(1),2);
k_tx_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_tx_time,k_tx,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Translation (mm)');
title('+Anterior');
lh = legend('Wilson 2000',' ','Model');
set(lh,'EdgeColor','w');

subplot(3,2,4);
% passive data from Wilson, D. R., et al. J Biomech 33, 465-473, 2000
fid = fopen('../Lit_Data/Wilson_Ave_SI.csv');
SI_Data = textscan(fid,'%f,%f');
fid2 = fopen('../Lit_Data/Wilson_SD_SI.csv');
SI_SD_Data = textscan(fid2,'%f,%f');
knee_angle4 = SI_Data{1,1}(:,1);
knee_si = SI_Data{1,2}(:,1);
si_sd = abs(interp1(SI_SD_Data{1,1}(:,1),SI_SD_Data{1,2}(:,1),knee_angle4,'linear','extrap')-knee_si);
pp24 = griddedInterpolant(knee_angle4,knee_si,'pchip');
v24 = pp24(xx1);
pp34 = griddedInterpolant(knee_angle4,si_sd,'pchip');
v34 = pp34(xx1);
hold on;
errorfill(xx1,v24,v34,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_ty = 1000*dp(iip,3)-1000*dp(iip(1),3);
k_ty_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_ty_time,k_ty,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Translation (mm)');
title('+Superior');

subplot(3,2,6);
% passive data from Wilson, D. R., et al. J Biomech 33, 465-473, 2000
fid = fopen('../Lit_Data/Wilson_Ave_ML.csv');
ML_Data = textscan(fid,'%f,%f');
fid2 = fopen('../Lit_Data/Wilson_SD_ML.csv');
ML_SD_Data = textscan(fid2,'%f,%f');
knee_angle6 = ML_Data{1,1}(:,1);
knee_ml = -1*ML_Data{1,2}(:,1);
ml_sd = abs(interp1(ML_SD_Data{1,1}(:,1),-1*ML_SD_Data{1,2}(:,1),knee_angle6,'linear','extrap')-knee_ml);
pp26 = griddedInterpolant(knee_angle6,knee_ml,'pchip');
v26 = pp26(xx1);
pp36 = griddedInterpolant(knee_angle6,ml_sd,'pchip');
v36 = pp36(xx1);
hold on;
errorfill(xx1,v26,v36,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_tz = 1000*dp(iip,4)-1000*dp(iip(1),4);
k_tz_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_tz_time,k_tz,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlim([0 100]);
ylabel('Translation (mm)');
title('+Lateral');
xlabel('Flexion Angle (deg)');

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../Passive_Flexion/Kinematics_LitCompare.bmp');
saveas(gcf,'../Passive_Flexion/Kinematics_LitCompare.fig');

%% compare just flexion literature

figure('color','w','units','normalized','outerposition',[0 0 1 1]);
ii = find(d(:,strcmp('time',h))>2 & d(:,strcmp('time',h))<22);
ii1 = ii(1);
iip = find(dp(:,strcmp('time',hp))>2 & dp(:,strcmp('time',hp))<22);

subplot(3,2,1);
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_angle_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Angle (deg)');
title('+Flexion');

subplot(3,2,3);
errorfill(xx1,v23,v33,'g-');
hold on;
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_add_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_add_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Angle (deg)');
title('+Adduction');

subplot(3,2,5);
errorfill(xx1,v25,v35,'g-');
hold on;
plot(-(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h)),(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_rot_r/value',h))-(180/3.14)*d(ii1,strcmp('/jointset/knee_r/knee_rot_r/value',h)),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlabel('Flexion Angle (deg)');
xlim([0 100]);
ylabel('Angle (deg)');
title('+Internal Rotation');

subplot(3,2,2);
errorfill(xx1,v22,v32,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_tx = 1000*dp(iip,2)-1000*dp(iip(1),2);
k_tx_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_tx_time,k_tx,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Translation (mm)');
title('+Anterior');
lh = legend('Wilson 2000',' ','Model');
set(lh,'EdgeColor','w');

subplot(3,2,4);
errorfill(xx1,v24,v34,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_ty = 1000*dp(iip,3)-1000*dp(iip(1),3);
k_ty_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_ty_time,k_ty,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'XTickLabel',{' '});
xlim([0 100]);
ylabel('Translation (mm)');
title('+Superior');

subplot(3,2,6);
errorfill(xx1,v26,v36,'g-');
hold on;
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));
k_flex_time = d(ii,strcmp('time',h));
k_tz = 1000*dp(iip,4)-1000*dp(iip(1),4);
k_tz_time = dp(iip,strcmp('time',hp));
plot(k_flex,interp1(k_tz_time,k_tz,k_flex_time),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlim([0 100]);
ylabel('Translation (mm)');
title('+Lateral');
xlabel('Flexion Angle (deg)');

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../Passive_Flexion/KinematicsFlex_LitCompare.bmp');
saveas(gcf,'../Passive_Flexion/KinematicsFlex_LitCompare.fig');

%% plot contact

clc;

time = df(:,1);
ii = find(time>2 & time<22);
k_flex = -(180/3.14)*d(ii,strcmp('/jointset/knee_r/knee_angle_r/value',h));

mFX = df(ii,strcmp('medial_tf.femur_r.force.X',hf));
mFY = df(ii,strcmp('medial_tf.femur_r.force.Y',hf));
mFZ = df(ii,strcmp('medial_tf.femur_r.force.Z',hf));
mTX = df(ii,strcmp('medial_tf.femur_r.torque.X',hf));
mTY = df(ii,strcmp('medial_tf.femur_r.torque.Y',hf));
mTZ = df(ii,strcmp('medial_tf.femur_r.torque.Z',hf));

lFX = df(ii,strcmp('lateral_tf.femur_r.force.X',hf));
lFY = df(ii,strcmp('lateral_tf.femur_r.force.Y',hf));
lFZ = df(ii,strcmp('lateral_tf.femur_r.force.Z',hf));
lTX = df(ii,strcmp('lateral_tf.femur_r.torque.X',hf));
lTY = df(ii,strcmp('lateral_tf.femur_r.torque.Y',hf));
lTZ = df(ii,strcmp('lateral_tf.femur_r.torque.Z',hf));

[med_mag_force] = calc_magnitude(mFX,mFY,mFZ);
[lat_mag_force] = calc_magnitude(lFX,lFY,lFZ);

freg_med_data = [63 0.2; 57 0.11; 25 0.3; 5 0.6];
freg_lat_data = [63 0.22; 57 0.08; 25 0.15; 5 0.57];

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

subplot(2,3,4);
plot(k_flex,lat_mag_force/(9.81*77.5),'g:','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlabel('Flexion Angle (deg)');
ylabel('Force (N/BW)');
title('Lateral');
hold on;
plot(freg_lat_data(:,1),freg_lat_data(:,2),'rs','LineWidth',3)
% line([0 100],[0.9 0.9],'Color','r','LineStyle',':','LineWidth',3);
y4 = ylim;

subplot(2,3,5);
plot(k_flex,med_mag_force/(9.81*77.5),'b-','LineWidth',3)
set(gca,'box','off','FontSize',14,'YTickLabel',{' '});
xlabel('Flexion Angle (deg)');
title('Medial');
hold on;
plot(freg_med_data(:,1),freg_med_data(:,2),'rs','LineWidth',3)
% line([0 100],[2 2],'Color','r','LineStyle',':','LineWidth',3);
y5 = ylim;

subplot(2,3,6);
plot(k_flex,(lat_mag_force+med_mag_force)/(9.81*77.5),'k-','LineWidth',3)
set(gca,'box','off','FontSize',14);
xlabel('Flexion Angle (deg)');
title('Medial + Lateral');
hold on;
plot(freg_med_data(:,1),freg_med_data(:,2)+freg_lat_data(:,2),'rs','LineWidth',3)
% line([0 100],[3 3],'Color','r','LineStyle',':','LineWidth',3);
y6 = ylim;

lh = legend('Model During Passive Flexion','Measured During Gait (Fregly 2012)');
set(lh,'EdgeColor','w');

for i = 4:6
    subplot(2,3,i);
    ylim([min([y4 y5 y6]) max([y4 y5 y6])]+0.01);
end

% subplot(2,3,[1 2]);
% fname = 'OS_Femur_Scaled';
% dir = '../Geometry/OpenSim Bones/';
% [p,v,f,c] = schmitz_display_stlFile(fname,dir);
% axis equal;
% view([0 0]);
% y_bone = ylim;
% ylim([min(y_bone) -0.3]);
% camroll(90);
% x_bone = xlim;
% z_bone = zlim;
% set(gca,'box','off','XTickLabel',{' '},'YTickLabel',{' '},'ZTickLabel',{' '});
% axis off;
% 
% text(max(x_bone),min(y_bone),0,'Anterior','FontSize',14);
% text(0,min(y_bone),max(z_bone)-0.01,'Lateral','FontSize',14);

% [COP_med] = calc_COP(mFX,mFY,mFZ,mTX,mTY,mTZ);
% hold on;
% plot3(COP_med(:,1),COP_med(:,2),COP_med(:,3),'k.');

saveas(gcf,'../Passive_Flexion/Contact_Check.bmp');
saveas(gcf,'../Passive_Flexion/Contact_Check.fig');




