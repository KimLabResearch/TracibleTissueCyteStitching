function xy_ilumination_v2(Aberation_folder, Normalized_folder, Averaging_folder,Number_of_cores)


boost_ratio = 500.0;

dir_in = Aberation_folder;
dir_out = Normalized_folder;
dir_ref = Averaging_folder;


ii = 0;
Folder_N = 0;
for channel = 1:3
   for z = 0:9
       ii = ii + 1;
       list{ii} = dir(strcat(dir_in, '/*', sprintf('%d',z), '_*ch', sprintf('%02d',channel)));
       folder_index.channel(ii) = channel;
       folder_index.z(ii) = z;
       Folder_N = Folder_N + length(list{ii});
   end
end

hbar = parfor_progressbar(Folder_N,'Computing Normalization...');  %create the progress bar

listy = dir(strcat(list{2}(1).folder, '/', list{2}(1).name, '/*x_1_y*'));
listx = dir(strcat(list{2}(1).folder, '/', list{2}(1).name, '/*y_1.*'));



parfor (ii = 1:length(list), Number_of_cores)

    %parfor z = 1000:1000 
    %    for channel = 2:2
    %mkdir(strcat(dir_out, '\Z', sprintf('%03d',z),'_ch', sprintf('%02d',channel),'\'));

    for jj = 1:length(list{ii})
        imageFolder = strcat(dir_out, '\', list{ii}(jj).name, '\');
        mkdir(imageFolder);
        for x = 1:length(listx)
            for y = 1:length(listy)

                
                if mod(x,2) == 0
                    %template = strcat(dir_ref, '\OS10up_ch',sprintf('%02d',channel),'.tif');%dan version
                    template = strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_even.tif');

                else
                    %template = strcat(dir_ref, '\OS10down_ch', sprintf('%02d',channel),'.tif');%dan version
                    template = strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_odd.tif');

                end
                templateData = imread(template);
                image = strcat(dir_in, '\', list{ii}(jj).name, '\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                %image = strcat(dir_in, '\Z', sprintf('%03d',folder_index.z(ii)),'_ch', sprintf('%02d',folder_index.channel(ii)),'\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                imageData = imread(image);
                processedData = double(imageData)  ./ double(templateData).* boost_ratio ;
                imageout = strcat(dir_out, '\', list{ii}(jj).name, '\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                imwrite(uint16(processedData),imageout);


            end
        end
        hbar.iterate(1);   % update progress by one iteration

    end
end
    
close(hbar);



