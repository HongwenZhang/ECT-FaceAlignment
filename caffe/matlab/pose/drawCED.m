    %% displaying CED
    x = [0 : 0.0005 :0.35];
    cumsum = cell(8,1);
    cumsum{1} = zeros(length(x),1);
    cumsum{2} = zeros(length(x),1);
    cumsum{3} = zeros(length(x),1);
    cumsum{4} = zeros(length(x),1);
    cumsum{5} = zeros(length(x),1);
    cumsum{6} = zeros(length(x),1);
    cumsum{7} = zeros(length(x),1);
    cumsum{8} = zeros(length(x),1);
    
    resultFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Outputibug22000.txt');
    results = textscan(resultFile, '%f %f %f', 'delimiter', ' ');
    
    result300wFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Output300w22000.txt');
    results300w = textscan(result300wFile, '%f %f %f', 'delimiter', ' ');
    
    %resultnewFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Outputibug60000.txt');
    %resultsNew = textscan(resultnewFile, '%f %f %f', 'delimiter', ' ');
    
    resultPrjFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/OutputibugProject.txt');
    resultsPrj = textscan(resultPrjFile, '%f %f %f', 'delimiter', ' ');
    
    resultsupviFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Outputibugsupvi.txt');
    resultssupvi = textscan(resultsupviFile, '%f %f %f', 'delimiter', ' ');
    
    resultsupviFusFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/OutputibugsupviFus.txt');
    resultssupvifus = textscan(resultsupviFusFile, '%f %f %f', 'delimiter', ' ');
    
    resultPrj1File = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Outputibug3002sq.txt');
    resultsPrj1 = textscan(resultPrj1File, '%f %f %f', 'delimiter', ' ');
    
    resultPrj300wFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Output300w1501sq.txt');
    resultsPrj300w = textscan(resultPrj300wFile, '%f %f %f', 'delimiter', ' ');
    
        
    resultPrj300wfullFile = fopen('/home/hongwen.zhang/FaceDataset/300w_ysq_crp/ibugOur.txt');
    resultsPrj300wfull = textscan(resultPrj300wfullFile, '%f', 'delimiter', ' ');
    
    resultPrj300wfullpupilFile = fopen('/home/hongwen.zhang/Projects/RspMapFitting/menpofit-master/Output300wfullpupil1501sq.txt');
    resultsPrj300wfullpupil = textscan(resultPrj300wfullpupilFile, '%f %f %f', 'delimiter', ' ');
   
    %nhelen = length(LBF_Helen_ERR);
    %nlfpw = length(LBF_LFPW_ERR);
    nImg = length(resultsPrj300wfullpupil{1});
    c = 0;

    for thres = x

        c = c + 1;
         idx1 = find(resultsPrj300wfullpupil{1} <= thres);
         cumsum{1}(c) = length(idx1)/nImg;
         
         idx2 = find(resultsPrj300wfullpupil{2} <= thres);
         cumsum{2}(c) = length(idx2)/nImg; 
        
        %idx3 = find(resultsPrj300wfull{1} <= thres);
        %cumsum{3}(c) = length(idx3)/nImg; 
%         
%         idx4 = find(SDM_LFPW_err <= thres);
%         cumsum{4}(c) = length(idx4)/nlfpw; 
        
%         idx5 = find(LBF_IBUG_208 <= thres);
%         cumsum{5}(c) = length(idx5)/nIBUG; 
%         
%         idx6 = find(SDM_IBUG_err136 <= thres);
%         cumsum{6}(c) = length(idx6)/nIBUG; 
%         
%         idx7 = find(LBF_IBUG_119 <= thres);
%         cumsum{7}(c) = length(idx7)/nIBUG; 
%         
%         idx8 = find(SDM_IBUG_err130 <= thres);
%         cumsum{8}(c) = length(idx8)/nIBUG;    
%         
%         idx4 = find(LBF_IBUG_145 <= thres);
%         cumsum{4}(c) = length(idx4)/nIBUG; 
        
        
    end

    DengResfile = fopen('/home/hongwen.zhang/FaceDataset/300w_ysq_crp/Dengcurve.txt');
    %cumDeng = textscan(DengResfile, '%f %f', 'delimiter', ' ');
    
    FanResfile = fopen('/home/hongwen.zhang/FaceDataset/300w_ysq_crp/FanCurve.txt');
    %cumFan = textscan(FanResfile, '%f %f', 'delimiter', ' ');
    
    
    figure;
    %plot( x, cumsum, 'LineWidth', 2 , 'MarkerEdgeColor','^r');
    plot( x, cumsum{1}, '-.b',x, cumsum{2}, '-.r',x, cumsum{3}, '-g',x, cumDeng{2},'-.c', x,cumFan{2},'-c');  %,x, cumsum{8}, '-r'
    title('Alignment Accuracy on ibug Dataset')   %LFPW  Helen  IBUG
    xlabel('Mean Normalized Error')
    ylabel('Data Proportion')
    grid on;

    axis([0 0.35 0 1]);

legend('Ours','Ours-fit to PDM','Location','southeast');