function shrink_image(Batch_stitching_folder, Shrinking_folder, Number_of_cores, Case_Name)

shrink_ratio2 = 0.1;

dir_in = Batch_stitching_folder;
dir_out = Shrinking_folder;

list = dir(strcat(dir_in, '/*.tif'));

hbar = parfor_progressbar(length(list),'Resizing...');  %create the progress bar
              
list = dir(strcat(dir_in, '/*/*ch01.tif'));


mkdir(strcat(Shrinking_folder, '\ch1'));
mkdir(strcat(Shrinking_folder, '\ch2'));
mkdir(strcat(Shrinking_folder, '\ch3'));

              
parfor (ii = 1:length(list),Number_of_cores)
    if mod(ii,2) == 0
    template = strcat(list(ii).folder, '\', list(ii).name);
	imageData = imread(template);
    imageData = imresize(imageData,shrink_ratio2)
    template = strcat(dir_out, '\ch1\p10_', list(ii).name);
	imwrite(imageData,template);
	hbar.iterate(1);   % update progress by one iteration
    end
end
list_to_read = dir(strcat(Shrinking_folder, '\*\*ch01*'));

for (ii = length(list_to_read))
    shrinkedPile(:,:,ii) = imread(strcat(list_to_read(ii).folder, '\', list_to_read(ii).name ));
end
imwritestack(shrinkedPile,[Shrinking_folder '\' Case_Name '_p10_ch01.tif']);
clear shrinkedPile



list = dir(strcat(dir_in, '/*/*ch02.tif'));

              
parfor (ii = 1:length(list),Number_of_cores)
    if mod(ii,2) == 0
    template = strcat(list(ii).folder, '\', list(ii).name);
	imageData = imread(template);
    imageData = imresize(imageData,shrink_ratio2)
    template = strcat(dir_out, '\ch2\p10_', list(ii).name);
	imwrite(imageData,template);
	hbar.iterate(1);   % update progress by one iteration
    end
end

list_to_read = dir(strcat(Shrinking_folder, '\*\*ch02*'));

for (ii = length(list_to_read))
    shrinkedPile(:,:,ii) = imread(strcat(list_to_read(ii).folder, '\', list_to_read(ii).name ));
end
imwritestack(shrinkedPile,[Shrinking_folder '\' Case_Name '_p10_ch02.tif']);
clear shrinkedPile




list = dir(strcat(dir_in, '/*/*ch03.tif'));

              
parfor (ii = 1:length(list),Number_of_cores)
    if mod(ii,2) == 0
    template = strcat(list(ii).folder, '\', list(ii).name);
	imageData = imread(template);
    imageData = imresize(imageData,shrink_ratio2)
    template = strcat(dir_out, '\ch3\p10_', list(ii).name);
	imwrite(imageData,template);
	hbar.iterate(1);   % update progress by one iteration
    end
end                    


list_to_read = dir(strcat(Shrinking_folder, '\*\*ch03*'));

for (ii = length(list_to_read))
    shrinkedPile(:,:,ii) = imread(strcat(list_to_read(ii).folder, '\', list_to_read(ii).name ));
end
imwritestack(shrinkedPile,[Shrinking_folder '\' Case_Name '_p10_ch03.tif']);
clear shrinkedPile



close(hbar);


