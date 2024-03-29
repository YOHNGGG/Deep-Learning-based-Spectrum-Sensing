function [S_1, S_0] = spectrum(signal,SNR)
% Function for generating power feature of received signal;

l = length(signal);
signal_sample = [];
for i =1:1:1280
    signal_sample = [signal_sample signal(l/2+i)];
end  
y_1 = signal_sample;

y_1 = awgn(y_1,SNR);
y_0 = y_1 - signal_sample;

y_1 = normalize(y_1);
y_0 = normalize(y_0);

nfft=126;
fs=100;

[S_1, f_1] = pwelch(y_1,hanning(nfft),nfft/2,nfft,fs);
[S_0, f_0] = pwelch(y_0,hanning(nfft),nfft/2,nfft,fs);
S_1 = S_1 * 100;
S_0 = S_0 * 100;

end
