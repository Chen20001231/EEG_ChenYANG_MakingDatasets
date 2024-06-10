%% INFO
% PD data info: 16 bit +/- 10mV range 328nV Lsb
% 250Hz sampling rate, 1 second records.
% Chopped and high cutoff at ~70Hz. low cutoff at 0.5Hz single order
% Noise floor below -125dB and rolling off at about 10dB/decade

%% MAKING TRAINING DATASET and TESTING DATASET
% 4-second window with a 75% overlap
% 4*250 = 1000

%% 3 classes
clc,clear,close all; 

number_of_episode = 4;


filename= {};
addpath 'PD patient Frontal'\
for i = 1:number_of_episode
    filename_temp = string(['Episode_', num2str(i),'.xlsx']);
    filename{end+1} = filename_temp;
end

counter = 1;
t_name = {};
t_category = {};
t_description = {};
for j = 1:number_of_episode
    excel_table = readtable(filename{j});
    num_of_rows = height(excel_table);
    edf_filename = string(excel_table.Var1(1));
    dataRead = edfread(edf_filename);
    dataMat = cell2mat(dataRead{:,:});
    for k = 1:num_of_rows
        EEGdata = dataMat(excel_table.Var2(k):excel_table.Var3(k),:);
        savepath = 'data'; 
        savename =  ['x',num2str(counter)];
        save(fullfile(savepath, savename), 'EEGdata');
        counter = counter + 1;
        t_name{end+1} = [savename, '.mat'];
        t_description{end+1} = ['episode_',num2str(j),'_',num2str(k)];
        t_category{end+1} = excel_table.Var4(k);
    end
end

%%
t_index = 1:(counter-1);
% 将数据放入表格中
T = table(t_index', t_name', t_description', t_category', 'VariableNames', {'Index', 'FileName', 'Description', 'Category'});
% 指定Excel文件的名称
filename2 = 'data\0_segments.xlsx';
% 将表格写入Excel文件
writetable(T, filename2);
% 显示完成信息
disp(['Data written to ', filename2]);


