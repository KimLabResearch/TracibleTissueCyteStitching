function xy_averaging_all(dir_temp, Number_of_cores)
if length(dir_temp)>2
    for kk = 2:length(dir_temp)-1
        dir_in = [dir_temp{kk} '\aberation'];
        
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
        hbar = parfor_progressbar(Folder_N,'Computing average...');  %create the progress bar
        
        
        for ii = 1:1:length(list)
            templateEven{ii} = 0;
            countingEven{ii} = 0;
            templateOdd{ii} = 0;
            countingOdd{ii} = 0;
            
        end
        
        parfor (ii = 1:1:length(list),Number_of_cores)
            if ~isempty(list{ii})
                if kk == 2
                    template = strcat(dir_in, '\', list{ii}(1).name, '\x_', sprintf('%01d',1),'_y_', sprintf('%01d',1),'.tif');
                    templateEven{ii} = zeros(size(imread(template)));
                    countingEven{ii} = zeros(size(imread(template)));
                    templateOdd{ii} = zeros(size(imread(template)));
                    countingOdd{ii} = zeros(size(imread(template)));
                    
                end
                listy = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*x_1_y*'));
                listx = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*y_1.*'));
                
                for jj = 1:length(list{ii})
                    for x = 1:length(listx)
                        for y = 1:length(listy)
                            template = strcat(dir_in, '\', list{ii}(jj).name, '\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                            if mod(x,2) == 0
                                tempImage = imread(template);
                                templateEven{ii} = templateEven{ii} + double(tempImage);
                                countingEven{ii} = countingEven{ii} + (tempImage>5);
                            else
                                tempImage = imread(template);
                                templateOdd{ii} = templateOdd{ii} + double(tempImage);
                                countingOdd{ii} = countingOdd{ii} + (tempImage>5);
                            end
                        end
                    end
                    hbar.iterate(1);   % update progress by one iteration
                end
            end
        end
        close(hbar);
        
    end
else
    for kk = 1:length(dir_temp)
        dir_in = [dir_temp{kk} '\aberation'];
        
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
        hbar = parfor_progressbar(Folder_N,'Computing average...');  %create the progress bar
        
        
        for ii = 1:1:length(list)
            templateEven{ii} = 0;
            countingEven{ii} = 0;
            templateOdd{ii} = 0;
            countingOdd{ii} = 0;
            
        end
        
        parfor (ii = 1:1:length(list),Number_of_cores)
            if ~isempty(list{ii})
                if kk == 2
                    template = strcat(dir_in, '\', list{ii}(1).name, '\x_', sprintf('%01d',1),'_y_', sprintf('%01d',1),'.tif');
                    templateEven{ii} = zeros(size(imread(template)));
                    countingEven{ii} = zeros(size(imread(template)));
                    templateOdd{ii} = zeros(size(imread(template)));
                    countingOdd{ii} = zeros(size(imread(template)));
                    
                end
                listy = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*x_1_y*'));
                listx = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*y_1.*'));
                
                for jj = 1:length(list{ii})
                    for x = 1:length(listx)
                        for y = 1:length(listy)
                            template = strcat(dir_in, '\', list{ii}(jj).name, '\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                            if mod(x,2) == 0
                                tempImage = imread(template);
                                tempImage(tempImage(:)>3000) = 0;
                                
                                templateEven{ii} = templateEven{ii} + double(tempImage);
                                countingEven{ii} = countingEven{ii} + (tempImage>5);
                            else
                                tempImage = imread(template);
                                tempImage(tempImage(:)>3000) = 0;

                                templateOdd{ii} = templateOdd{ii} + double(tempImage);
                                countingOdd{ii} = countingOdd{ii} + (tempImage>5);
                            end
                        end
                    end
                    hbar.iterate(1);   % update progress by one iteration
                end
            end
        end
        close(hbar);
        
    end
    
end



for ii = 1:30
    templateEven{ii} = templateEven{ii} ./ countingEven{ii};
    templateOdd{ii} = templateOdd{ii} ./ countingOdd{ii};
end



for kk = 1:length(dir_temp)
    
    
    dir_ref = [dir_temp{kk} '\averaging'];
    mkdir(dir_ref);
    parfor (ii = 1:1:length(list),Number_of_cores)
        if ~isempty(list{ii})
            imwrite(uint16(templateEven{ii}),strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_even.tif'));
            imwrite(uint16(templateOdd{ii}),strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_odd.tif'));
        end
    end
    
end