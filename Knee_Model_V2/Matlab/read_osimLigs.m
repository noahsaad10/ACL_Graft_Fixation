function ligs = read_osimLigs(fname)

% clc; clear all; close all;
% fname = '../runner18_scaled.osim';

fid = fopen(fname);
lig_flag = 0;
rl_flag = 0;
f_flag = 0;
count = 0;

while ~feof(fid)
    tline = fgets(fid);
    A = sscanf(tline,'%s');
    if isempty(strfind(A,'<Ligamentname='))==0
        name = sscanf(A,'<Ligamentname=" %s ');
        ii = strfind(name,'">');
        lig_name = name(1:(ii-1));
        lig_flag = 1;
    end
    if isempty(strfind(A,'<resting_length>'))==0
        s_length = sscanf(A,'<resting_length>%f</resting_length>');
        rl_flag = 1;
    end
    if isempty(strfind(A,'<pcsa_force>'))==0
        iso_force = sscanf(A,'<pcsa_force>%f</pcsa_force>');
        f_flag = 1;
    end
    if (lig_flag == 1) & (rl_flag == 1) & (f_flag == 1)
%         disp(['Ligament ' lig_name ' has slack length ' num2str(s_length) ' and isometric force ' num2str(iso_force)]);
        lig_flag = 0;
        rl_flag = 0;
        f_flag = 0;
        count = count + 1;
        ligs{count,1} = lig_name;
        ligs{count,2} = num2str(s_length);
        ligs{count,3} =  num2str(iso_force);
    end
    
end
fclose('all');