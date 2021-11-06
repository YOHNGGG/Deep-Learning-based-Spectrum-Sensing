function [energy_feature_0,energy_feature_1] = energy_feature(signal,SNR)

% SNR = -5;
energy_feature_1 = [];
energy_feature_0 = [];
% [t,signal] = QPSK_3(400);
l = length(signal);
signal_sample = [];
for i =1:1:1280
    signal_sample = [signal_sample signal(l/2+i)];
end  


y_1 = signal_sample;

y_1 = awgn(y_1,SNR);
y_0 = y_1 - signal_sample;

% y_1 = normalize(y_1);
% y_0 = normalize(y_0);

% figure(1)
% plot(y_1)
% figure(2)
% plot(y_0)

% Signal 1
% energy feature
Nsample = length(y_1) / 64;
for n = 1: 1 : 64
    k = 1 + (n-1)*Nsample;
    S_sample_energy_1 = 0;
    for i=k:1:k+(Nsample-1)
    S_sample_energy_1 = S_sample_energy_1 + abs(y_1(i))^2;
    end
    S_sample_energy_1 = S_sample_energy_1 / Nsample;
    energy_feature_1 = [energy_feature_1 S_sample_energy_1];     
end

% Signal 0
Nsample = length(y_0) / 64;
for n = 1: 1 : 64
    k = 1 + (n-1)*Nsample;
    S_sample_energy_0 = 0;
    for i=k:1:k+(Nsample-1)
    S_sample_energy_0 = S_sample_energy_0 + abs(y_0(i))^2;
    end
    S_sample_energy_0 = S_sample_energy_0 / Nsample;
    energy_feature_0 = [energy_feature_0 S_sample_energy_0];     
end

energy_feature_0 = energy_feature_0';
energy_feature_1 = energy_feature_1';

end



%feature matrix
% feature_1 = [energy_feature_1;cs_feature_1]';
% feature_0 = [energy_feature_0;cs_feature_0]';
% 
% feature = feature_1;
% 
% filename = strcat('Signal_1_',num2str(j),'.mat');
% save(filename, 'feature');

% end
