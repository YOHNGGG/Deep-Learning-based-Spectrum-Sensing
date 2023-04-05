function [ tt, Signal ] = QPSK( N ) 
%% Generate received analog QPSK modulated signal

Ts=1;          
N_sample=128;      
alpha=0.5;        
dt=Ts/N_sample; 
t=-3*Ts:dt:3*Ts;

ht=sinc(t/Ts).*(cos(alpha*pi*t/Ts))./(1-4*alpha^2*t.^2/Ts^2+eps);

gt_original = [1 zeros(1, N_sample/2-1)];
gt_IQ = [1 zeros(1, N_sample-1)];
RAN = round(rand(1, N)); 
seq_original=[];
seq_I = [];
seq_Q = [];
for i = 1 : N 
   if RAN(i)==1
       seq_original = [seq_original gt_original];
   else
       seq_original = [seq_original -1*gt_original];
   end
end

for i = 1 : N/2 
   if RAN(2*i)==1
       seq_I = [seq_I gt_IQ];
   else
       seq_I = [seq_I -1*gt_IQ];
   end
      if RAN(2*i-1)==1
       seq_Q = [seq_Q gt_IQ];
   else
       seq_Q = [seq_Q -1*gt_IQ];
   end
end

st_I=conv(seq_I,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;

st_Q=conv(seq_Q,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;

fc=10000;
I = 2 / sqrt(2) * cos(2*pi*fc*tt);
Q = -2 / sqrt(2) * sin(2*pi*fc*tt);
signal_complex = (st_I + 1j.*st_Q).*exp(1j*2*pi*fc*tt);

Fs=2000;    
Ts=1/Fs;        
Fd=50;            
tau=[0,0.001];      
pdb=[0,0];          
chan = rayleighchan(Ts, Fd, tau, pdb);

y = filter(chan,signal_complex);

Signal = real(y);
