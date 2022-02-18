function fiji_suto_waitbar(Normalized_folder, Boosting_folder, Batch_stitching_folder, Number_of_cores)


par_partitions = 80;
hbar = parfor_progressbar(par_partitions,'Stitching...');  %create the progress bar
file_reg = 'TileConfiguration.registered.txt';
dir_reg = Boosting_folder;
dir_in = Normalized_folder;
dir_out = Batch_stitching_folder;
%dir_in = 'D:\20190408_practice\fiji_auto_in';
%dir_out = 'D:\20190408_practice\fiji_auto_out';
%dir_reg = 'D:\20190408_practice\fiji_auto';
%file_reg = 'TileConfiguration.registered.txt';

list = dir(strcat(dir_in, '\Z*'));

for ii = 1:par_partitions
    sub_in_folder{ii} = strcat(dir_in, '\par_', sprintf('%d',ii));
    mkdir(sub_in_folder{ii});
    
    sub_out_folder{ii} = strcat(dir_out, '\par_', sprintf('%d',ii));
    mkdir(sub_out_folder{ii});    
    copyfile(strcat(dir_reg, '\', file_reg), sub_out_folder{ii}); 
    copyfile('stitch.ijm', sub_out_folder{ii}); 

end

for ii = 1:length(list)
    movefile(strcat(dir_in, '\', list(ii).name), sub_in_folder{mod(ii,par_partitions)+1}); 
end

for ii = 1:par_partitions
    fid = fopen(strcat(sub_out_folder{ii}, '\', 'stitch.ijm'),'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);

    % Change cell A
    A{8} = strcat('path_to_template = "', strrep(sub_out_folder{ii},'\','\\'),'\\' ,file_reg,'"; ');
    A{10} = strcat('dir2 = "', strrep(sub_in_folder{ii},'\','\\'),'"; ');
    A{12} = strcat('dir_output = "', strrep(sub_out_folder{ii},'\','\\'),'"; ');
    
    
    % Write cell A into txt
    fid = fopen(strcat(sub_out_folder{ii}, '\', 'stitch.ijm'),'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end 
    fclose(fid);
    why_on_earth{ii} = strcat('D:\Fiji.app\ImageJ-win64 -batch', {' '},sub_out_folder{ii}, '\stitch.ijm');
end
    
parfor (ii = 1: par_partitions, Number_of_cores)
    if ~isempty(dir(strcat(sub_in_folder{ii}, '\Z*')))
    [~, ~] = dos( why_on_earth{ii}{1} );
    end
    hbar.iterate(1);
end
list_to_move = dir(strcat(Batch_stitching_folder, '\*\*\Z*.tif'));
for ii = 1:length(list_to_move)
    movefile(strcat(list_to_move(ii).folder, '\', list_to_move(ii).name ), Batch_stitching_folder);
end
list_to_remove = dir(strcat(Batch_stitching_folder, '\par*'));
for ii = 1:length(list_to_remove)
rmdir(strcat(list_to_remove(ii).folder, '\', list_to_remove(ii).name ),'s');
end

list_to_move = dir(strcat(Normalized_folder, '\*\Z*'));
for ii = 1:length(list_to_move)
    movefile(strcat(list_to_move(ii).folder, '\', list_to_move(ii).name ), Normalized_folder);
end
list_to_remove = dir(strcat(Normalized_folder, '\par*'));
for ii = 1:length(list_to_remove)
rmdir(strcat(list_to_remove(ii).folder, '\', list_to_remove(ii).name ),'s');
end





mkdir(strcat(Batch_stitching_folder, '\ch1'));
mkdir(strcat(Batch_stitching_folder, '\ch2'));
mkdir(strcat(Batch_stitching_folder, '\ch3'));

list_to_move = dir(strcat(Batch_stitching_folder, '\*ch01*'));
for ii = 1:length(list_to_move)
    movefile(strcat(list_to_move(ii).folder, '\', list_to_move(ii).name ), strcat(Batch_stitching_folder, '\ch1'));
end

list_to_move = dir(strcat(Batch_stitching_folder, '\*ch02*'));
for ii = 1:length(list_to_move)
    movefile(strcat(list_to_move(ii).folder, '\', list_to_move(ii).name ), strcat(Batch_stitching_folder, '\ch2'));
end

list_to_move = dir(strcat(Batch_stitching_folder, '\*ch03*'));
for ii = 1:length(list_to_move)
    movefile(strcat(list_to_move(ii).folder, '\', list_to_move(ii).name ), strcat(Batch_stitching_folder, '\ch3'));
end







close(hbar);









