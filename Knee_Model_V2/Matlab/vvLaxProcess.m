%% define variables

clc; clear all; close all;
ap_angs = [0;-15;-30;-45;-60;-75;-90];

%% plot torque-deflection curve and get i/e deflections

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};

for i = 1:size(ap_angs,1)
% for i = 1;    
    disp(['Working on torque-deflection of ' num2str(-1*ap_angs(i,1))]);
    [d,h] = load_mot(['../VV_Laxity/vv_' num2str(-1*ap_angs(i,1)) '.mot']);
    [d2,h2] = load_mot(['../VV_Laxity/vv' num2str(-1*ap_angs(i,1)) '_sim_states_degrees.mot']);
    tx_femur = d(:,strcmp('femur_r_torque_x',h));
    ty_femur = d(:,strcmp('femur_r_torque_y',h));
    force_t = d(:,strcmp('time',h));
    k_rot = d2(:,strcmp('knee_add_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    t_rot = [];
    for jj = 1:size(tx_femur,1)
        t_rot(jj,1) = -ty_femur(jj,1)/sind(-1*ap_angs(i));
    end
    if ap_angs(i) == 0
        t_rot = tx_femur;
    end
    if size(force_t,1)>size(kine_t,1)
        t = kine_t;
        t_rot = interp1(force_t,t_rot,kine_t);
    else
        t = force_t;
        k_rot = interp1(kine_t,k_rot,force_t);
    end
    ii = find(t>2);
    k_rot_neutral = k_rot(ii(1));
    
    leg_entries{i,1} = num2str(-1*ap_angs(i,1));
    hold on;
    plot(k_rot(ii)-k_rot_neutral,t_rot(ii),l_type{i})
    
    add_rot(i,1) = max(k_rot(ii)-k_rot_neutral);
    abd_rot(i,1) = min(k_rot(ii)-k_rot_neutral);

end

set(gca,'box','off','FontSize',14);
lh = legend(leg_entries);
set(lh,'EdgeColor','w','Location','BestOutside');
xlabel('Deflection (deg)');
ylabel('Torque (Nm)');
title('+Adduction');
ylim([-10 10]);

saveas(gcf,'../VV_Laxity/Torque_Deflection_Curves.bmp');
save('../VV_Laxity/vv_results.mat','add_rot','abd_rot','ap_angs');

%% compare vv deflections with literature

ang =             [0    10   15   20   30   45     60      75     90];

% 10 Nm var (adduction) rotation torque
gol87_var_rot   = [6    NaN  6.5  NaN  7.5  8      8.4     9      8.6];  % Gollehon 1987 %!
gol87_var_e  =    [2    NaN  2.5  NaN  2.25 3.5    4       4      2.2];                  %!
tsa10_var_rot   = [4.3  NaN  NaN  6.9  6.9  NaN    4.4     NaN    6.2];  % Tsai 2010 %!
tsa10_var_e  =    [0    NaN  NaN  0    0    NaN    0       NaN    0];                %!
tsa102_var_rot  = [3.5  NaN  NaN  5.5  5.3  NaN    4.3     NaN    6.4];  % Tsai 2010 %!
tsa102_var_e  =   [0    NaN  NaN  0    0    NaN    0       NaN    0];                %!
coo07_var_rot   = [3.7  NaN  5    NaN  5.6  NaN    5.4     NaN    5.4];  % Coobs 2007 %!
coo07_var_e  =    [1.8  NaN  2.5  NaN  2.3  NaN    1.2     NaN    1.1];               %!
mar81_var_rot   = [3    NaN  NaN  5    NaN  NaN    NaN     NaN    NaN];  % Markolf 1981 %!
mar81_var_e  =    [1    NaN  NaN  1    NaN  NaN    NaN     NaN    NaN];                 %!
mar76_var_rot   = [1    2.6  NaN  3.2  NaN  3.8    NaN     NaN    5.0];  % Markolf 1976 %!
mar76_var_e  =    [0    0    NaN  0    NaN  0      NaN     NaN    0];                   %!

% 10 Nm val (abduction) rotation torque
gol87_val_rot   = [5.5  NaN  8    NaN  8.5  8.5    9       9.8    10.5];  % Gollehon 1987 %!
gol87_val_e  =    [3    NaN  3.8  NaN  3.8  3.8    4.1     4.1    4.0];                   %!
and10_val_rot   = [2.9  NaN  NaN  6.3  8.7  NaN    12.3    NaN    12.6];  % Anderson 2010 %!
and10_val_e  =    [0.4  NaN  NaN  0.8  1.2  NaN    1.7     NaN    1.5];                   %!
coo10_val_rot   = [2.5  NaN  NaN  5.5  7    NaN    9.8     NaN    10.3];  % Coobs 2010  %!
coo10_val_e  =    [0.25 NaN  NaN  0.6  1    NaN    1.5     NaN    1.1];                 %!
tsa10_val_rot   = [4.6  NaN  NaN  6.6  7.1  NaN    9.8     NaN    10.8];  % Tsai 2010  %!
tsa10_val_e  =    [0    NaN  NaN  0    0    NaN    0       NaN    0];                  %!
tsa102_val_rot  = [3.1  NaN  NaN  4.5  5.4  NaN    8.3     NaN    9.2];  % Tsai 2010   %!
tsa102_val_e  =   [0    NaN  NaN  0    0    NaN    0       NaN    0];                  %!
gri09_val_rot   = [4    NaN  NaN  4.5  6.5  NaN    7       NaN    4.5];  % Griffith 2009
gri09_val_e  =    [0.25 NaN  NaN  0.5  0.4  NaN    2       NaN    0.9];
mar81_val_rot   = [3    NaN  NaN  5    NaN  NaN    NaN     NaN    NaN];  % Markolf 1981 %!
mar81_val_e  =    [1    NaN  NaN  1    NaN  NaN    NaN     NaN    NaN];                 %!
mar76_val_rot   = [1.2  2.8  NaN  3.2  NaN  3.5    NaN     NaN    3.9];  % Markolf 1976 %!
mar76_val_e  =    [0    0    NaN  0    NaN  0      NaN     NaN    0];                   %!

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

subplot(2,1,1);
plot(-ap_angs,add_rot,'bh','MarkerSize',14,'MarkerFaceColor','b')
subplot(2,1,2);
plot(-ap_angs,-abd_rot,'bh','MarkerSize',14,'MarkerFaceColor','b')

subplot(2,1,1);
set(gca, 'Box','off');
set(gca,'FontSize',14)

hold on;
gol87 = plot(ang,gol87_var_rot,'go','MarkerSize',14,'MarkerFaceColor','g');
gol87G = hggroup;
set(gol87,'Parent',gol87G);
set(get(get(gol87G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
tsa10 = plot(ang,tsa10_var_rot,'r<','MarkerSize',14,'LineWidth',2);
tsa10G = hggroup;
set(tsa10,'Parent',tsa10G);
set(get(get(tsa10G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
tsa102 = plot(ang,tsa102_var_rot,'r<','MarkerSize',14,'LineWidth',2);
tsa102G = hggroup;
set(tsa102,'Parent',tsa102G);
set(get(get(tsa102G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');

hold on;
coo07 = plot(ang,coo07_var_rot,'mh','MarkerSize',14,'LineWidth',2);
coo07G = hggroup;
set(coo07,'Parent',coo07G);
set(get(get(coo07G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
mar81 = plot(ang,mar81_var_rot,'ms','MarkerSize',14,'LineWidth',2);
mar81G = hggroup;
set(mar81,'Parent',mar81G);
set(get(get(mar81G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
mar76 = plot(ang,mar76_var_rot,'kd','MarkerSize',14,'LineWidth',2);
mar76G = hggroup;
set(mar76,'Parent',mar76G);
set(get(get(mar76G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

h_legend = legend('Schmitz Model','Gollehon 1987','Tsai 2010','Coobs 2007','Markolf 1981','Markolf 1976');
set(h_legend,'FontSize',13)
ylabel('Rotation (deg)','FontSize',16);
title({'Adduction Torque'},'FontSize',20)

hold on;
errorbar(ang,gol87_var_rot,gol87_var_e,'k.');
hold on;
errorbar(ang,tsa10_var_rot,tsa10_var_e,'k.');
hold on;
errorbar(ang,tsa102_var_rot,tsa102_var_e,'k.');
hold on;
errorbar(ang,coo07_var_rot,coo07_var_e,'k.');
hold on;
errorbar(ang,mar81_var_rot,mar81_var_e,'k.');
hold on;
errorbar(ang,mar76_var_rot,mar76_var_e,'k.');

subplot(2,1,2);
set(gca, 'Box','off');
set(gca,'FontSize',14)
ylabel('Rotation (deg)','FontSize',16)
title({'Abduction Torque'},'FontSize',20)
xlabel('Knee Angle (deg)','FontSize',16)

hold on;
gol87 = plot(ang,gol87_val_rot,'go','MarkerSize',14,'MarkerFaceColor','g');
gol87G = hggroup;
set(gol87,'Parent',gol87G);
set(get(get(gol87G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
tsa10 = plot(ang,tsa10_val_rot,'r<','MarkerSize',14,'LineWidth',2);
tsa10G = hggroup;
set(tsa10,'Parent',tsa10G);
set(get(get(tsa10G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
tsa102 = plot(ang,tsa102_val_rot,'r<','MarkerSize',14,'LineWidth',2);
tsa102G = hggroup;
set(tsa102,'Parent',tsa102G);
set(get(get(tsa102G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');

hold on;
coo10 = plot(ang,coo10_val_rot,'g^','MarkerSize',14,'LineWidth',2);
coo10G = hggroup;
set(coo10,'Parent',coo10G);
set(get(get(coo10G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
and10 = plot(ang,and10_val_rot,'bv','MarkerSize',14,'LineWidth',2);
and10G = hggroup;
set(and10,'Parent',and10G);
set(get(get(and10G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
mar81 = plot(ang,mar81_val_rot,'ms','MarkerSize',14,'LineWidth',2);
mar81G = hggroup;
set(mar81,'Parent',mar81G);
set(get(get(mar81G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
mar76 = plot(ang,mar76_val_rot,'kd','MarkerSize',14,'LineWidth',2);
mar76G = hggroup;
set(mar76,'Parent',mar76G);
set(get(get(mar76G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
gri09 = plot(ang,gri09_val_rot,'c>','MarkerSize',14,'LineWidth',2);
gri09G = hggroup;
set(gri09,'Parent',gri09G);
set(get(get(gri09G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

h_legend = legend('Schmitz Model','Gollehon 1987','Tsai 2010','Coobs 2010','Anderson 2010','Markolf 1981','Markolf 1976','Griffith 2009');
set(h_legend,'FontSize',13)
ylabel('Rotation (deg)','FontSize',16);
title({'Abduction Torque'},'FontSize',20)

hold on;
errorbar(ang,gol87_val_rot,gol87_val_e,'k.');
hold on;
errorbar(ang,tsa10_val_rot,tsa10_val_e,'k.');
hold on;
errorbar(ang,tsa102_val_rot,tsa102_val_e,'k.');
hold on;
errorbar(ang,coo10_val_rot,coo10_val_e,'k.');
hold on;
errorbar(ang,and10_val_rot,and10_val_e,'k.');
hold on;
errorbar(ang,mar81_val_rot,mar81_val_e,'k.');
hold on;
errorbar(ang,mar76_val_rot,mar76_val_e,'k.');
hold on;
errorbar(ang,gri09_val_rot,gri09_val_e,'k.');

subplot(2,1,1)
hold on;
plot(-1*ap_angs,add_rot,'bh-','MarkerSize',14,'MarkerFaceColor','b')
xlim([-5 95]);
set(gca,'XTickLabel',{' '});

subplot(2,1,2)
hold on;
plot(-1*ap_angs,-abd_rot,'bh-','MarkerSize',14,'MarkerFaceColor','b')
xlim([-5 95]);

saveas(gcf,'../VV_Laxity/VV_Laxity_LitCompare.bmp');
saveas(gcf,'../VV_Laxity/VV_Laxity_LitCompare.fig');

%% plot vv torque vs ligament strength

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

ligs = {'aACL',4000;
        'pACL',4000;
		'aPCL',4000;
		'pPCL',1600;
		'LCL',3000;
        'PFL',2000;
		'CAPa',1500;
		'CAPl',2000;
		'CAPo',1500;
		'CAPm',2000;
		'aMCL',2000;
		'iMCL',2000;
        'pMCL',4000;
        'aCM',2000;
        'pCM',2000};
[force,stretch] = lig_properties2();
l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};

[m,n] = size(ap_angs);
for i = 1:m
    
    subplot(2,m,i)

    title({'Knee Flexed '; [num2str(-1*ap_angs(i)) ' deg']},'FontSize',14);
    
    [d,h] = load_mot(['../VV_Laxity/vv_' num2str(-1*ap_angs(i,1)) '.mot']);
    [df,hf] = load_sto(['../VV_Laxity/vv' num2str(-1*ap_angs(i,1)) '_sim_ForceReporter_forces.sto']);
    [d2,h2] = load_mot(['../VV_Laxity/vv' num2str(-1*ap_angs(i,1)) '_sim_states_degrees.mot']);
    tx_femur = d(:,strcmp('femur_r_torque_x',h));
    ty_femur = d(:,strcmp('femur_r_torque_y',h));
    force_t = d(:,strcmp('time',h));
    k_rot = d2(:,strcmp('knee_add_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    t_rot = [];
    
    for jj = 1:size(tx_femur,1)
        t_rot(jj,1) = -ty_femur(jj,1)/sind(-1*ap_angs(i));
    end
    if ap_angs(i) == 0
        t_rot = tx_femur;
    end

    for jj = 1:size(ligs,1)
        leg_entries{jj,1} = ligs{jj,1};
        lig_force = df(:,strcmp(ligs{jj,1},hf));
        lig_time = df(:,strcmp('time',hf));
        
        if size(t,1)>size(lig_time,1)
            time = lig_time;
            t_rot = interp1(t,t_rot,time);
        else
            time = t;
            lig_force = interp1(lig_time,lig_force,time);
        end
        
        lig_strain = [];
        for kk = 1:size(lig_force,1)
            lig_strain(kk) = interp1(force,stretch,lig_force(kk)/ligs{i,2})-1;
        end
                
        subplot(2,m,m+i);
        hold on;
        ii = find(time>2);
        plot(t_rot(ii),100*lig_strain(ii),l_type{jj});
        
        subplot(2,m,i);
        hold on;
        plot(t_rot(ii),lig_force(ii),l_type{jj});

    end
    
    if i==1
        lh = legend(leg_entries);
        set(lh,'EdgeColor','w');
    end
    
end

for i = 1:2*m
    
    subplot(2,m,i)
    set(gca,'box','off','FontSize',14);
    xlim([-10 10]);
    
    if i <= m
        ylim([0 250]);
    else
        ylim([0 12]);
    end
    
    if i>m
         xlabel({'Applied';'Torque (Nm)'});
    else
        set(gca,'XTickLabel',{' '});
    end
    
    if i == (m+1)
        ylabel('Ligament Strain (%)');
    elseif i == 1
        ylabel('Ligament Force (N)');
    end
    
    if i>(m+1) || (i>1 & i<=m)
        set(gca,'YTickLabel',{' '});
    end
end

saveas(gcf,'../VV_Laxity/Lig_Strains.bmp');
saveas(gcf,'../VV_Laxity/Lig_Strains.fig');

%% plot vv torque vs vv ligament torque

clc;

figure('color','w','units','normalized','outerposition',[0 0 1 1]);

ligs = {'aACL',4000;
        'pACL',4000;
		'aPCL',4000;
		'pPCL',1600;
		'LCL',3000;
        'PFL',2000;
		'CAPa',1500;
		'CAPl',2000;
		'CAPo',1500;
		'CAPm',2000;
		'aMCL',2000;
		'iMCL',2000;
        'pMCL',4000;
        'aCM',2000;
        'pCM',2000};
[force,stretch] = lig_properties2();
l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};

lims = [];

[m,n] = size(ap_angs);
for i = 1:m
    
    disp(['Working on torque-lig property of ' num2str(-1*ap_angs(i,1))]);
    
    subplot(2,m,i)

    title({'Knee Flexed '; [num2str(-1*ap_angs(i)) ' deg']},'FontSize',14);
    
    [d,h] = load_mot(['../VV_Laxity/vv_' num2str(-1*ap_angs(i,1)) '.mot']);
    [df,hf] = load_sto(['../VV_Laxity/vv' num2str(-1*ap_angs(i,1)) '_sim_ForceReporter_forces.sto']);
    [d2,h2] = load_mot(['../VV_Laxity/vv' num2str(-1*ap_angs(i,1)) '_sim_states_degrees.mot']);
    tx_femur = d(:,strcmp('femur_r_torque_x',h));
    ty_femur = d(:,strcmp('femur_r_torque_y',h));
    force_t = d(:,strcmp('time',h));
    k_rot = d2(:,strcmp('knee_add_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    t_rot = [];
    
    k_tx = d2(:,strcmp('knee_tx_r',h2));
    k_ty = d2(:,strcmp('knee_ty_r',h2));
    k_tz = d2(:,strcmp('knee_tz_r',h2));
    k_r3 = d2(:,strcmp('knee_angle_r',h2));
    k_r1 = d2(:,strcmp('knee_add_r',h2));
    k_r2 = d2(:,strcmp('knee_rot_r',h2));
    
    for jj = 1:size(tx_femur,1)
        t_rot(jj,1) = -ty_femur(jj,1)/sind(-1*ap_angs(i));
    end
    if ap_angs(i) == 0
        t_rot = tx_femur;
    end

    t_unit = [cosd(-1*ap_angs(i)) -sind(-1*ap_angs(i)) 0];
    
    if size(t,1)>size(df(:,strcmp('time',hf)),1)
    else
        k_tx2 = interp1(kine_t,k_tx,t);
        k_ty2 = interp1(kine_t,k_ty,t);
        k_tz2 = interp1(kine_t,k_tz,t);
        k_r32 = interp1(kine_t,k_r3,t);
        k_r12 = interp1(kine_t,k_r1,t);
        k_r22 = interp1(kine_t,k_r2,t);
    end
    
    lig_loa = calc_lig_LOA(k_tx2,k_ty2,k_tz2,k_r32,k_r12,k_r22);
    
    for jj = 1:size(ligs,1)
        leg_entries{jj,1} = ligs{jj,1};
        lig_force = df(:,strcmp(ligs{jj,1},hf));
        lig_time = df(:,strcmp('time',hf));
        
        if size(t,1)>size(lig_time,1)
            time = lig_time;
            t_rot = interp1(t,t_rot,time);
        else
            time = t;
            lig_force = interp1(lig_time,lig_force,time);
        end
        
        lig_strain = [];
        for kk = 1:size(lig_force,1)
            lig_strain(kk) = interp1(force,stretch,lig_force(kk)/ligs{i,2})-1;
        end
        
        %bottom row...plot ligament strain
        subplot(2,m,m+i);
        hold on;
        ii = find(time>2);
        plot(t_rot(ii),100*lig_strain(ii),l_type{jj});
        
        lig_loa_vec = lig_loa.(genvarname(ligs{jj,1})).loa(:,1:3);
        for kk = 1:size(lig_loa_vec,1)
            lig_force_dir(kk,1:3) = lig_loa_vec(kk,1:3).*lig_force(kk);
            tor = cross(lig_loa.(genvarname(ligs{jj,1})).tib_attach(kk,1:3)',lig_force_dir(kk,1:3)');
            lig_tor_vv(kk) = dot(tor,t_unit);
        end
        
        subplot(2,m,i);
        hold on;
        plot(t_rot(ii),-1*lig_tor_vv(ii),l_type{jj});
        
         lims = [lims;max(-1*lig_tor_vv(ii));min(-1*lig_tor_vv(ii))];

    end
    
    if i==1
        lh = legend(leg_entries);
        set(lh,'EdgeColor','w');
    end
    
end

for i = 1:2*m
    
    subplot(2,m,i)
    set(gca,'box','off','FontSize',14);
    xlim([-10 10]);
    
    if i <= m
        ylim([min(lims) max(lims)]);
    else
        ylim([0 12]);
    end
    
    if i>m
         xlabel({'Applied';'Torque (Nm)'});
    else
        set(gca,'XTickLabel',{' '});
    end
    
    if i == (m+1)
        ylabel('Ligament Strain (%)');
    elseif i == 1
        ylabel({'VV Ligament';'Torque (Nm)'});
    end
    
    if i>(m+1) || (i>1 & i<=m)
        set(gca,'YTickLabel',{' '});
    end
end

saveas(gcf,'../VV_Laxity/Lig_Strains2.bmp');
saveas(gcf,'../VV_Laxity/Lig_Strains2.fig');
