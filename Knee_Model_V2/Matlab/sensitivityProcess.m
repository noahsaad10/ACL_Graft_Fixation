%% start clean

clc; clear all; close all;

%% load results

model_nom = '../Model4/';
load([model_nom 'Sensitivity/param_change.mat'])
load([model_nom 'Sensitivity/headers.mat'])
ap_results_nom = load([model_nom 'ap_results.mat']);
ie_results_nom = load([model_nom 'ie_results.mat']);

%% proces results

n_sim = size(headers,1);

sens_results = nan(n_sim,4);

for i = 1:n_sim
    results_change = load([model_nom 'Sensitivity/results' num2str(i) '.mat']);
    sens_results(i,1) = results_change.ant_trans(1)-ap_results_nom.ant_trans(1);
    sens_results(i,2) = results_change.ant_trans(2)-ap_results_nom.ant_trans(4);
    sens_results(i,3) = -results_change.post_trans(1)+ap_results_nom.post_trans(1);
    sens_results(i,4) = -results_change.post_trans(2)+ap_results_nom.post_trans(4);
    sens_results(i,5) = results_change.int_rot(1)-ie_results_nom.int_rot(1);
    sens_results(i,6) = results_change.int_rot(2)-ie_results_nom.int_rot(4);
    sens_results(i,7) = -results_change.ext_rot(1)+ie_results_nom.ext_rot(1);
    sens_results(i,8) = -results_change.ext_rot(2)+ie_results_nom.ext_rot(4);
end

%% plot ap results

figure('color','w')

subplot(2,2,1)
bar(sens_results(:,1))
set(gca,'box','off','FontSize',8);
title('Ant 0');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',{' '},'XTick',1:1:n_sim);
y1 = ylim;
ylabel('Perturbed - Nominal (mm)');

subplot(2,2,2)
bar(sens_results(:,3))
set(gca,'box','off','FontSize',8);
title('Post 0');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',{' '},'XTick',1:1:n_sim);
set(gca,'YTickLabel',{' '});
y2 = ylim;

subplot(2,2,3)
bar(sens_results(:,2))
set(gca,'box','off','FontSize',8);
title('Ant 45');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',headers,'XTick',1:1:n_sim);
rotateXLabels(gca,90);
y3 = ylim;
ylabel('Perturbed - Nominal (mm)');

subplot(2,2,4)
bar(sens_results(:,4))
set(gca,'box','off','FontSize',8);
title('Post 45');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',headers,'XTick',1:1:n_sim);
set(gca,'YTickLabel',{' '});
rotateXLabels(gca,90);
y4 = ylim;

subplot(2,2,1)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,2)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,3)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,4)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);

ii = find((sens_results(:,1) > 0) & (sens_results(:,2) > 0) & (sens_results(:,3) > 0) & (sens_results(:,4) > 0));
if ~isempty(ii)
    text(0.5,max([y1 y2 y3 y4])-0.1,['Loosen ' headers{ii}],'Color','r','FontSize',12);
else
    text(0.5,max([y1 y2 y3 y4])-0.1,'No tuning suggestions for AP','Color','r','FontSize',12);
end

set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,[model_nom 'Sensitivity/AP_Results.bmp']);

%% plot ie results

figure('color','w')

subplot(2,2,1)
bar(sens_results(:,5))
set(gca,'box','off','FontSize',8);
title('Int 0');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',{' '},'XTick',1:1:n_sim);
y1 = ylim;
ylabel('Perturbed - Nominal (deg)');

subplot(2,2,2)
bar(sens_results(:,7))
set(gca,'box','off','FontSize',8);
title('Ext 0');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',{' '},'XTick',1:1:n_sim);
set(gca,'YTickLabel',{' '});
y2 = ylim;

subplot(2,2,3)
bar(sens_results(:,6))
set(gca,'box','off','FontSize',8);
title('Int 45');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',headers,'XTick',1:1:n_sim);
rotateXLabels(gca,90);
y3 = ylim;
ylabel('Perturbed - Nominal (deg)');

subplot(2,2,4)
bar(sens_results(:,8))
set(gca,'box','off','FontSize',8);
title('Ext 45');
xlim([0.5 n_sim+0.5]);
set(gca,'XTickLabel',headers,'XTick',1:1:n_sim);
set(gca,'YTickLabel',{' '});
rotateXLabels(gca,90);
y4 = ylim;

subplot(2,2,1)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,2)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,3)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);
subplot(2,2,4)
ylim([min([y1 y2 y3 y4]) max([y1 y2 y3 y4])]);

ii = find((sens_results(:,5) > 0) & (sens_results(:,6) > 0) & (sens_results(:,7) > 0) & (sens_results(:,8) > 0));
if ~isempty(ii)
    text(0.5,max([y1 y2 y3 y4]-0.1),['Loosen ' headers{ii}],'Color','r','FontSize',12);
else
    text(0.5,max([y1 y2 y3 y4]-0.1),'No tuning suggestions for IE','Color','r','FontSize',12);
end

set(gcf, 'Position', get(0,'Screensize'));
saveas(gcf,[model_nom 'Sensitivity/IE_Results.bmp']);

%% recommend changes to make

%            a0, a45, p0, p45, i0, i45, e0, e45
des_change = [1   1    0   0    1   0   0   -1];
ii_p = (1:1:size(sens_results,1))';
ii_c = [];

for i = 1:size(sens_results,2)
    if des_change(1,i) > 0
        ii_c = find(sens_results(:,i) > 0);
    elseif des_change(1,i) < 0
        ii_c = find(sens_results(:,i) < 0);
    end
    ii_p = intersect(ii_c,ii_p);
end
disp('Loosen ');
disp(headers(ii_p));

