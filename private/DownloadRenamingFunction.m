function     DownloadRenamingFunction( DownloadRenaming_folder)

NNNN = dir([DownloadRenaming_folder '\Mosaic_*.txt']);
[Project] = readMosaic([DownloadRenaming_folder '\' NNNN(1).name]);
dirTree = dir([DownloadRenaming_folder '\' Project.name '*']);
snake = buildingSnake(Project);

if length(dirTree)~=Project.sections
warning('number of directries not matching mosaic file')
end




for ii = 1:length(dirTree)
    dirTif = dir([dirTree(ii).folder '\' dirTree(ii).name '\*.tif']  );
    C = [];
    for jj = 1:length(dirTif)
        C(jj,:)=  str2double(strsplit(dirTif(jj).name,{'-','_','.'}));
    end
    kk = 1;
    C = sortrows(C,3);
    cOneOneMinusOne = C(1,:);
    cOneOneMinusOne(3) = cOneOneMinusOne(3)-1;  %Assuming the first file is not missing
    cOneOneMinusOne(4) = 0;        
    
        
    for jj = 1:Project.mrows.*Project.mcolumns.*Project.channels.*Project.layers
        [channelNum, filenNum] = ind2sub([Project.channels, Project.mrows.*Project.mcolumns.*Project.layers],jj);
        tempFIleName{jj} = [dirTree(ii).folder, '\', ...
                            dirTree(ii).name, '\', ...
                            num2str(cOneOneMinusOne(1),'%08d'), '-', ...
                            num2str(cOneOneMinusOne(2),'%04d'), '-', ...
                            num2str(cOneOneMinusOne(3)+filenNum), '_', ...
                            num2str(cOneOneMinusOne(4)+channelNum,'%02d'), '.tif'];
        if C(kk,3)~=cOneOneMinusOne(3)+filenNum || C(kk,4)~=cOneOneMinusOne(4)+channelNum
            warning(['file: ' num2str(cOneOneMinusOne(3)+filenNum) ' channel: ' ...
                     num2str(cOneOneMinusOne(4)+channelNum) ...
                     ' is missing. This programe will try to fix it with dummy image']);

            
            imwrite(uint16(zeros(Project.columns, Project.rows)), tempFIleName{jj});
        else
            kk = kk+1;
         end
    end
    for jj = 1:Project.channels 
        for kk = 1:Project.layers
        newFolder = [DownloadRenaming_folder '\Z' num2str((ii-1).*Project.layers+kk, '%03d') '_ch' num2str(jj, '%02d')   ];
        mkdir(newFolder)
            for ll = 1:Project.mrows.*Project.mcolumns
                newFileName = [newFolder, '\x_', ...
                       num2str(snake(ll).x), '_y_', ...
                       num2str(snake(ll).y), '.tif'];
                movefile(tempFIleName{jj+(ll-1).*Project.channels+(kk-1).*Project.mrows.*Project.mcolumns.*Project.channels}, newFileName, 'f');
            end
        end
    end
    rmdir( [dirTree(ii).folder '\' dirTree(ii).name], 's');

end

rmdir( [DownloadRenaming_folder '\trigger'], 's');
delete ( [DownloadRenaming_folder '\Mosaic_*.txt'])




