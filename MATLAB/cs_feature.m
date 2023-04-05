function [feature_1,feature_0] = cs_feature(signal,SNR)
% Function for generating cyclestationary feature of received signal.

l = length(signal);
signal_sample = [];
for i =1:1:1280
    signal_sample = [signal_sample signal(l/2+i)];
end  
Signal = signal_sample';

l = length(Signal);
y_1 = awgn(Signal,SNR);
y_0 = y_1 - Signal;

y_1 = normalize(y_1);
y_0 = normalize(y_0);

[S_1,alpha_1,f_1] = commP25ssca(y_1,1,1/64,1/64);
[S_0,alpha_2,f_2] = commP25ssca(y_0,1,1/64,1/64);
figure(2)
commP25plot(S_1,alpha_1,f_1);
figure(3)
commP25plot(S_0,alpha_1,f_1);
index_alpha = find(alpha_1 == 0);
index_f = find(f_1 == 0);
S_alpha_1_alpha = S_1(:,index_alpha);
S_alpha_0_alpha = S_0(:,index_alpha);
S_f_1 = S_1(index_f,:);
S_f_0 = S_0(index_f,:);
cs_feature_1_alpha = [];
cs_feature_0_alpha = [];
cs_feature_1_f = [];
cs_feature_0_f = [];
for n = 1:1:64
    cs_feature_1_alpha = [cs_feature_1_alpha S_alpha_1_alpha(n+1)];
    cs_feature_0_alpha = [cs_feature_0_alpha S_alpha_0_alpha(n+1)];
    cs_feature_1_f = [cs_feature_1_f (S_f_1(2*n-1)+S_f_1(2*n))/2];
    cs_feature_0_f = [cs_feature_0_f (S_f_0(2*n-1)+S_f_0(2*n))/2];
end

feature_1 = [cs_feature_1_alpha;cs_feature_1_f]';
feature_0 = [cs_feature_0_alpha;cs_feature_0_f]';
feature = feature_1;

end

% filename = strcat('Signal_1_',num2str(j),'.mat');
% save(filename, 'feature');

%end
