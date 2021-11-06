function [S_1, S_0] = spectrum(signal,SNR)
% [t,signal] = QPSK_3(400);
% plot(t, signal);grid on;axis([0 10 -4 4]);title('QPSK');
% SNR = 10;
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

% figure(1)
% pwelch(y_1);
% figure(2)
% pwelch(y_0);