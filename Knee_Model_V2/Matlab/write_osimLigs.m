function [] = write_osimLigs(f1,f2,lig_names,lig_sl,lig_pcsa)

% clc; clear all; close all;
% % original model to alter ligs properties on
% f1 = '../Model0/runner18_scaled.osim';
% % new model
% f2 = '../runner18_scaled.osim';
% ligs_nom = read_osimLigs(f1);
% for i = 1:size(ligs_nom,1)
%     lig_names{i,1} = ligs_nom{i,1};
% end
% lig_sl = str2double(ligs_nom(:,2));
% lig_pcsa = str2double(ligs_nom(:,3));

fid = fopen(f1,'r');
fid2 = fopen(f2,'w');
lig_flag = 0;
rl_flag = 0;
f_flag = 0;

count_lig = 0;

while ~feof(fid)
    tline = fgets(fid);
    A = sscanf(tline,'%s');
    if isempty(strfind(A,'<Ligamentname='))==0
        name = sscanf(A,'<Ligamentname=" %s ');
        ii = strfind(name,'">');
        lig_name = name(1:(ii-1));
        lig_flag = 1;
        jj1 = strcmp(lig_names,lig_name);
        jj = [];
        for kk = 1:size(jj1,1)
            if (jj1(kk)) == 1
                jj = kk;
            end
        end
        count_lig = count_lig + 1;
    end
    if (isempty(strfind(A,'<resting_length>'))==0) & (lig_flag == 1)
        rl_flag = 1;
        fprintf(fid2,['\t\t\t\t    <resting_length>' num2str(lig_sl(count_lig)) '</resting_length> \n']);
    elseif (isempty(strfind(A,'<pcsa_force>'))==0) & (lig_flag == 1)
        f_flag = 1;
        fprintf(fid2,['\t\t\t\t    <pcsa_force>' num2str(lig_pcsa(count_lig)) '</pcsa_force> \n']);
    else
        fwrite(fid2,tline);
    end
    if (lig_flag == 1) & (rl_flag == 1) & (f_flag == 1)
        lig_flag = 0;
        rl_flag = 0;
        f_flag = 0;
    end
end

fclose('all');