% Run the function to generating dataset for training

for SNR=-20:1:5
    for i=1:1:100
        [t,signal] = QPSK(400);
        figure(1)
        plot(t, signal);grid on;axis([0 10 -4 4]);title('QPSK');

        [energy_feature_0,energy_feature_1] = energy_feature(signal,SNR);
        [power_feature_1,power_feature_0] = spectrum(signal,SNR);
        [cs_feature_1,cs_feature_0] = cs_feature(signal,SNR);

        feature_1 = [energy_feature_1 power_feature_1 cs_feature_1];
        feature_0 = [energy_feature_0 power_feature_0 cs_feature_0];
        
        feature = feature_1;
        filename = strcat('SNR_',num2str(SNR),'_Signal1_',num2str(i),'.mat');
        save(['C:\Users\DELL\Desktop\Project\matlab\Signal features\dataset\signal1\',filename], 'feature');
        
        feature = feature_0;
        filename = strcat('SNR_',num2str(SNR),'_Signal0_',num2str(i),'.mat');
        save(['C:\Users\DELL\Desktop\Project\matlab\Signal features\dataset\signal0\',filename], 'feature');
    end
end
        

