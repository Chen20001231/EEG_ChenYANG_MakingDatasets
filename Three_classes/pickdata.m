%% INFO
% PD data info: 16 bit +/- 10mV range 328nV Lsb 
% 250Hz sampling rate, 1 second records. 
% Chopped and high cutoff at ~70Hz. low cutoff at 0.5Hz single order
% Noise floor below -125dB and rolling off at about 10dB/decade

%% MAKING TRAINING DATASET and TESTING DATASET
% 4-second window with a 75% overlap
% 4*250 = 1000

%% 2 classes
clc,clear,close all; 

addpath 'PD patient Frontal'\
filename = {'SeizureDataIndex.xlsx';'NonSeizureDataIndex.xlsx';'PreSeizureDataIndex.xlsx'};
label = {'Seizure';'NonSeizure';'PreSeizure'};
index = 0;
t_name = {};
t_category = {};
num = [4, 3, 4];% How many sections are there in each index file
counter = 1;
for k = 1:3
    startAt = 1;
    for i = 1:num(k)
    
        filenameIndex = ['A',num2str(startAt),':A',num2str(startAt)];
        FileName = cell2mat(readcell(filename{k},"Sheet","Sheet1", 'Range', filenameIndex));
        
        endIndex = ['B',num2str(startAt),':B',num2str(startAt)];
        endAt = cell2mat(readcell(filename{k},"Sheet","Sheet1", 'Range', endIndex));
        
        startIndex = ['A',num2str(startAt+1),':A',num2str(endAt)];
        endIndex = ['B',num2str(startAt+1),':B',num2str(endAt)];
        
        dataStartIndex = cell2mat(readcell(filename{k},"Sheet","Sheet1", 'Range', startIndex));
        dataEndIndex = cell2mat(readcell(filename{k},"Sheet","Sheet1", 'Range', endIndex));
        
        dataRead = edfread(FileName);
        for j = 1:length(dataStartIndex)
            dataMat = cell2mat(dataRead{:,:});
            EEGdata = dataMat(dataStartIndex(j):dataEndIndex(j),:);
            savepath = 'data'; 
            savename =  ['x',num2str(counter)];
            counter = counter + 1;
            %savename =  [label{k},'_',num2str(i),'_',num2str(j)];
            savename_2 =  [label{k},'_',num2str(i),'_',num2str(j)];
            save(fullfile(savepath, savename), 'EEGdata');
            t_name{end+1} = savename_2;
            t_category{end+1} = label{k};
        end
        index = index + length(dataStartIndex);
        startAt = endAt+1;
    end
end
t_index = 1:index;
%%
% 将数据放入表格中
T = table(t_index', t_name', t_category', 'VariableNames', {'Index', 'FileName', 'Category'});

% 指定Excel文件的名称
filename2 = 'data\0_segments.xlsx';

% 将表格写入Excel文件
writetable(T, filename2);

% 显示完成信息
disp(['Data written to ', filename2]);

%disp(raw);
%}
