clc; clear all; close all;

%% write motion file with prescribed knee angle function

t_trans = 2;
t_end = 40;
ang_max = 100;
freq = 20;
t0 = 0:0.01:t_trans;
t1 = t_trans+0.01:0.01:t_end;
t = [t0';t1'];

for i = 1:size(t,1)
    if t(i) <t_trans
        k_flex(i,1) = 0;
    else
        k_flex(i,1) = -(ang_max/2)+(ang_max/2)*cos((1/freq)*pi*(t(i)-t_trans));
    end
end

figure('color','w');
plot(t,k_flex);
set(gca,'box','off');
xlabel('Time (s)');
ylabel('Angle (deg)');
title('Knee Flexion Angle to Track');
saveas(gcf,'../Passive_Flexion/prescribed_flexion_ang.bmp');

[m,n] = size(k_flex);
headers = {'time';'knee_angle_r';'knee_add_r';     'knee_rot_r';     'knee_tx_r';       'knee_ty_r';    'knee_tz_r'};
data =    [  t       k_flex       0*ones(m,n)        0*ones(m,n)  -0.006*ones(m,n)   -0.450*ones(m,n)  zeros(m,n) ];
write_motion('../Passive_Flexion/flexion_ang.mot',data,headers)

%% write osim model file with prescribed knee angle function

fid = fopen('../runner18_scaled.osim');
fid2 = fopen('../runner18_scaled_passiveFlex.osim','w');

while ~feof(fid)
    tline = fgets(fid);
    A = sscanf(tline,'%s');
    fwrite(fid2,tline);
    
    if strcmp(A,'<Coordinatename="knee_angle_r">')
        for i = 1:13
            tline = fgets(fid);
            A = sscanf(tline,'%s');
            fwrite(fid2,tline);
        end
        for i = 1:3
            tline = fgets(fid); 
        end
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t <prescribed_function> \n');
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t\t <SimmSpline> \n');
        fprintf(fid2,['\t\t\t\t\t\t\t\t\t\t\t\t <x>' num2str(t') '</x>\n']);
        fprintf(fid2,['\t\t\t\t\t\t\t\t\t\t\t\t <y>' num2str((3.14/180)*k_flex') '</y>\n']);
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t\t </SimmSpline> \n');
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t </prescribed_function> \n');
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t <!--Flag--> \n');
        fprintf(fid2,'\t\t\t\t\t\t\t\t\t\t <prescribed>true</prescribed> \n');
    end
    
end
fclose('all');






