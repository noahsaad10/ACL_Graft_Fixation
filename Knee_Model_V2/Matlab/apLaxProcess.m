%% define variables

clc; clear all; close all;
ap_angs = [0;-15;-30;-45;-60;-75;-90];

%% plot force-deflection curve and get a/p deflections

figure('color','w');

l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};

for i = 1:size(ap_angs,1)
    disp(['Working on force-deflection of ' num2str(-1*ap_angs(i,1))]);
% for i = 5;
    [d,h] = load_mot(['../AP_Laxity/ap_' num2str(-1*ap_angs(i,1)) '.mot']);
    [d2,h2] = load_sto(['../AP_Laxity/ap' num2str(-1*ap_angs(i,1)) '_sim_states.sto']);
    fx_femur = d(:,strcmp('femur_r_force_vx',h));
    fy_femur = d(:,strcmp('femur_r_force_vy',h));
    force_t = d(:,strcmp('time',h));
    k_tx = d2(:,strcmp('knee_tx_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    f_ap = [];
    for jj = 1:size(fx_femur,1)
        f_ap(jj,1) = fx_femur(jj,1)/cosd(-1*ap_angs(i));
    end
    if ap_angs(i) == -90
        f_ap(:,1) = -fy_femur;
    end
    if size(force_t,1)>size(kine_t,1)
        t = kine_t;
        f_ap = interp1(force_t,f_ap,kine_t);
    else
        t = force_t;
        k_tx = interp1(kine_t,k_tx,force_t);
    end
    ii = find(t>2);
    k_tx_neutral = k_tx(ii(1));
    
    leg_entries{i,1} = num2str(-1*ap_angs(i,1));
    hold on;
    plot(1000*(k_tx(ii)-k_tx_neutral),f_ap(ii),l_type{i})
    
    ant_trans(i,1) = max(1000*(k_tx(ii)-k_tx_neutral));
    post_trans(i,1) = min(1000*(k_tx(ii)-k_tx_neutral));

end

set(gca,'box','off','FontSize',14);
lh = legend(leg_entries);
set(lh,'EdgeColor','w','Location','BestOutside');
xlabel('Deflection (mm)');
ylabel('Force (N)');
title('+Anterior');
ylim([-100 100]);

set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../AP_Laxity/Force_Deflection_Curves.bmp');
save('../AP_Laxity/ap_results.mat','ant_trans','post_trans','ap_angs');

%% compare a/p deflections with literature

ang =             [0    10   15   20   30   45     60      75     90];

% 100N ant force
mar81_ant_trans = [2.7  NaN  NaN  4.5  NaN  NaN    NaN     NaN    NaN];  % Markolf 1981  
mar81_ant_e  =    [0.5  NaN  NaN   1   NaN  NaN    NaN     NaN    NaN];                  
mar76_ant_trans = [1.8  NaN  NaN  3.9  NaN  3      NaN     NaN    2.1];  % Markolf 1976  
mar76_ant_e  =    [0    NaN  NaN   0   NaN  0      NaN     NaN    0  ];                  
lev89_ant_trans = [4.5  NaN  6.4  NaN  5.8  5.9    5.4     5.2    4.8];  % Levy 1989     
lev89_ant_e  =    [0.9  NaN  3.0  NaN   1.7  2.2   1.7     1.6    0.9];                  
sul84_ant_trans = [3.5  NaN  NaN  NaN  5.9  NaN    4.7     NaN    4.4];  % Sullivan 1984 
sul84_ant_e  =    [1.2  NaN  NaN  NaN  2.6  NaN    1.7     NaN    1.4];                  
gol87_ant_trans = [4.5  NaN  5.5  NaN  5.7  5.9    5.4    4.7     4.7];  % Gollehon 1987 
gol87_ant_e  =    [1.9  NaN  2.7  NaN  2.1  1.9    1.7     1.5    2.5];                  
sho85_ant_trans = [2.2  NaN  NaN  5.5  NaN  NaN    NaN     NaN    NaN];  % Shoemaker 1985 
sho85_ant_e  =    [0    NaN  NaN   0   NaN  NaN    NaN     NaN    NaN];

% 100N post force
mar81_pos_trans = [2.8  NaN  NaN  4.6  NaN  NaN    NaN     NaN    NaN];  % Markolf 1981  
mar81_pos_e  =    [0.4  NaN  NaN   0.9 NaN  NaN    NaN     NaN    NaN];                  
mar76_pos_trans = [1.4  NaN  NaN  3.3  NaN  2.6    NaN     NaN    2.3];  % Markolf 1976  
mar76_pos_e  =    [0    NaN  NaN   0   NaN  0      NaN     NaN    0  ];                  
gol87_pos_trans = [5.3  NaN  6.1  NaN  6.1  5.5    5.2     5      4.8];  % Gollehon 1987 
gol87_pos_e  =    [1.7  NaN  2.1  NaN  2.6  2.3    1.6     2.0    1.5];                  
sho85_pos_trans = [3    NaN  NaN  3.4  NaN  NaN    NaN     NaN    NaN];  % Shoemaker 1985 
sho85_pos_e  =    [0    NaN  NaN   0   NaN  NaN    NaN     NaN    NaN];

figure;
set(gcf,'Color','white')
set(gcf, 'Position', get(0,'Screensize'));

subplot(2,1,1)
set(gca, 'Box','off');
set(gca,'FontSize',14)

hold on;
plot(ap_angs(1),ant_trans(1),'bh','MarkerSize',14,'MarkerFaceColor','b')

hold on;
mar81 = plot(ang,mar81_ant_trans,'ms','MarkerSize',14,'LineWidth',2);
mar81G = hggroup;
set(mar81,'Parent',mar81G);
set(get(get(mar81G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
mar76 = plot(ang,mar76_ant_trans,'kd','MarkerSize',14,'LineWidth',2);
mar76G = hggroup;
set(mar76,'Parent',mar76G);
set(get(get(mar76G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
lev89 = plot(ang,lev89_ant_trans,'bo','MarkerSize',14,'LineWidth',2);
lev89G = hggroup;
set(lev89,'Parent',lev89G);
set(get(get(lev89G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
sul84 = plot(ang,sul84_ant_trans,'c^','MarkerSize',14,'MarkerFaceColor','c');
sul84G = hggroup;
set(sul84,'Parent',sul84G);
set(get(get(sul84G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
gol87 = plot(ang,gol87_ant_trans,'go','MarkerSize',14,'MarkerFaceColor','g');
gol87G = hggroup;
set(gol87,'Parent',gol87G);
set(get(get(gol87G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

hold on;
sho85 = plot(ang,sho85_ant_trans,'rs','MarkerSize',14,'MarkerFaceColor','r');
sho85G = hggroup;
set(sho85,'Parent',sho85G);
set(get(get(sho85G,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');

h_legend = legend('Model','Markolf 1981','Markolf 1976','Levy 1989','Sullivan 1984','Gollehon 1987','Shoemaker 1985');
set(h_legend,'FontSize',13,'EdgeColor','w')
ylabel('Translation (mm)','FontSize',16);
title({'Anterior Force'},'FontSize',20)

hold on;
errorbar(ang,mar81_ant_trans,mar81_ant_e,'k.');
hold on;
errorbar(ang,mar76_ant_trans,mar76_ant_e,'k.');
hold on;
errorbar(ang,lev89_ant_trans,lev89_ant_e,'k.');
hold on;
errorbar(ang,sul84_ant_trans,sul84_ant_e,'k.');
hold on;
errorbar(ang,gol87_ant_trans,gol87_ant_e,'k.');
hold on;
errorbar(ang,sho85_ant_trans,sho85_ant_e,'k.');

subplot(2,1,2);
set(gca, 'Box','off');
set(gca,'FontSize',14)
ylabel('Translation (mm)','FontSize',16)
title({'Posterior Force'},'FontSize',20)
xlabel('Knee Angle (deg)','FontSize',16)

hold on;
plot(ang,mar81_pos_trans,'ms','MarkerSize',14,'LineWidth',2);
hold on;
plot(ang,mar76_pos_trans,'kd','MarkerSize',14,'LineWidth',2);
hold on;
plot(ang,gol87_pos_trans,'go','MarkerSize',14,'MarkerFaceColor','g');
hold on;
plot(ang,sho85_pos_trans,'rs','MarkerSize',14,'MarkerFaceColor','r');

hold on;
errorbar(ang,mar81_pos_trans,mar81_pos_e,'k.');
hold on;
errorbar(ang,mar76_pos_trans,mar76_pos_e,'k.');
hold on;
errorbar(ang,gol87_pos_trans,gol87_pos_e,'k.');
hold on;
errorbar(ang,sho85_pos_trans,sho85_pos_e,'k.');

subplot(2,1,1)
hold on;
plot(-1*ap_angs,ant_trans,'bh-','MarkerSize',14,'MarkerFaceColor','b')
xlim([-5 95]);
set(gca,'XTickLabel',{' '});

subplot(2,1,2)
hold on;
plot(-1*ap_angs,-post_trans,'bh-','MarkerSize',14,'MarkerFaceColor','b')
xlim([-5 95]);

saveas(gcf,'../AP_Laxity/AP_Laxity_LitCompare.bmp');
saveas(gcf,'../AP_Laxity/AP_Laxity_LitCompare.fig');

%% plot ap force vs ligament stretch

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
% for i = 1
    subplot(2,m,i)
    title({'Knee Flexed '; [num2str(-1*ap_angs(i)) ' deg']},'FontSize',14);

    [df,hf] = load_sto(['../AP_Laxity/ap' num2str(-1*ap_angs(i,1)) '_sim_ForceReporter_forces.sto']);
    [d,h] = load_mot(['../AP_Laxity/ap_' num2str(-1*ap_angs(i,1)) '.mot']);
    [d2,h2] = load_sto(['../AP_Laxity/ap' num2str(-1*ap_angs(i,1)) '_sim_states.sto']);
    fx_femur = d(:,strcmp('femur_r_force_vx',h));
    fy_femur = d(:,strcmp('femur_r_force_vy',h));
    force_t = d(:,strcmp('time',h));
    k_tx = d2(:,strcmp('knee_tx_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    f_ap = [];
    for jj = 1:size(fx_femur,1)
        f_ap(jj,1) = fx_femur(jj,1)/cosd(-1*ap_angs(i));
    end
    if ap_angs(i) == -90
        f_ap(:,1) = -fy_femur;
    end
    
    for jj = 1:size(ligs,1)
        leg_entries{jj,1} = ligs{jj,1};
        lig_force = df(:,strcmp(ligs{jj,1},hf));
        lig_time = df(:,strcmp('time',hf));
        
        if size(t,1)>size(lig_time,1)
            time = lig_time;
            f_ap = interp1(t,f_ap,time);
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
        plot(f_ap(ii),100*lig_strain(ii),l_type{jj});
        
        subplot(2,m,i);
        hold on;
        plot(f_ap(ii),lig_force(ii),l_type{jj});

    end
    
    if i==1
        lh = legend(leg_entries);
        set(lh,'EdgeColor','w');
    end
    
end

for i = 1:2*m
    
    subplot(2,m,i)
    set(gca,'box','off','FontSize',14);
    xlim([-100 100]);
    
    if i <= m
        ylim([0 300]);
    else
        ylim([0 13]);
    end
    
    if i>m
         xlabel('Applied Force (N)');
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

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../AP_Laxity/Lig_Strains.bmp');
saveas(gcf,'../AP_Laxity/Lig_Strains.fig');

%% plot ap force vs ligament stretch and ap lig force

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
% ligs = {'pACL',4000};
[force,stretch] = lig_properties2();
l_type = {'r-','b-','g-','k-','m-',...
    'r:','b:','g:','k:','m:',...
    'r.','b.','g.','k.','m.'};

lims = [];

[m,n] = size(ap_angs);
% go through each joint angle
for i = 1:m
% for i = 1;
    
    disp(['Working on force-lig property of ' num2str(-1*ap_angs(i,1))]);
    
    subplot(2,m,i)
    title({'Knee Flexed '; [num2str(-1*ap_angs(i)) ' deg']},'FontSize',14);

    [df,hf] = load_sto(['../AP_Laxity/ap' num2str(-1*ap_angs(i,1)) '_sim_ForceReporter_forces.sto']);
    [d,h] = load_mot(['../AP_Laxity/ap_' num2str(-1*ap_angs(i,1)) '.mot']);
    [d2,h2] = load_sto(['../AP_Laxity/ap' num2str(-1*ap_angs(i,1)) '_sim_states.sto']);
    fx_femur = d(:,strcmp('femur_r_force_vx',h));
    fy_femur = d(:,strcmp('femur_r_force_vy',h));
    force_t = d(:,strcmp('time',h));
    k_tx = d2(:,strcmp('knee_tx_r',h2));
    k_ty = d2(:,strcmp('knee_ty_r',h2));
    k_tz = d2(:,strcmp('knee_tz_r',h2));
    k_r3 = d2(:,strcmp('knee_angle_r',h2));
    k_r1 = d2(:,strcmp('knee_add_r',h2));
    k_r2 = d2(:,strcmp('knee_rot_r',h2));
    kine_t = d2(:,strcmp('time',h2));
    f_ap = [];
    for jj = 1:size(fx_femur,1)
        f_ap(jj,1) = fx_femur(jj,1)/cosd(-1*ap_angs(i));
    end
    if ap_angs(i) == -90
        f_ap(:,1) = -fy_femur;
    end
    
    f_unit = [cosd(-1*ap_angs(i)) -sind(-1*ap_angs(i)) 0];
    
    if size(t,1)>size(df(:,strcmp('time',hf)),1)
    else
        k_tx2 = interp1(kine_t,k_tx,t);
        k_ty2 = interp1(kine_t,k_ty,t);
        k_tz2 = interp1(kine_t,k_tz,t);
        k_r32 = interp1(kine_t,k_r3,t);
        k_r12 = interp1(kine_t,k_r1,t);
        k_r22 = interp1(kine_t,k_r2,t);
    end
    
    lig_loa = calc_lig_LOA(k_tx2,k_ty2,k_tz2,k_r32*(180/3.14),k_r12*(180/3.14),k_r22*(180/3.14));
    
    for jj = 1:size(ligs,1) % go through each ligament
        leg_entries{jj,1} = ligs{jj,1};
        lig_force = df(:,strcmp(ligs{jj,1},hf));
        lig_time = df(:,strcmp('time',hf));
        
        if size(t,1)>size(lig_time,1)
            time = lig_time;
            f_ap = interp1(t,f_ap,time);
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
        plot(f_ap(ii),100*lig_strain(ii),l_type{jj});
        
        lig_loa_vec = lig_loa.(genvarname(ligs{jj,1})).loa(:,1:3);
        lig_force_ap = [];
        for kk = 1:size(lig_loa_vec,1)
            lig_force_ap(kk) = dot(lig_loa_vec(kk,1:3).*lig_force(kk),f_unit);
        end
        
        %top row...plot ap ligament force
        subplot(2,m,i);
        hold on;
        plot(f_ap(ii),-1*lig_force_ap(ii),l_type{jj});
        
        lims = [lims;max(-1*lig_force_ap(ii));min(-1*lig_force_ap(ii))];

    end
    
    if i==1
        lh = legend(leg_entries);
        set(lh,'EdgeColor','w');
    end
    
end

for i = 1:2*m
    
    subplot(2,m,i)
    set(gca,'box','off','FontSize',14);
    xlim([-100 100]);
    
    if i <= m
        ylim([min(lims) max(lims)]);
    else
        ylim([0 13]);
    end
    
    if i>m
         xlabel('Applied Force (N)');
    else
        set(gca,'XTickLabel',{' '});
    end
    
    if i == (m+1)
        ylabel('Ligament Strain (%)');
    elseif i == 1
        ylabel({'AP Ligament';'Force (N)'});
    end
    
    if i>(m+1) || (i>1 & i<=m)
        set(gca,'YTickLabel',{' '});
    end
end

% set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,'../AP_Laxity/Lig_Strains2.bmp');
saveas(gcf,'../AP_Laxity/Lig_Strains2.fig');