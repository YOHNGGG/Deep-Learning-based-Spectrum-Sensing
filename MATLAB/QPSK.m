function [ tt, Signal ] = QPSK( N ) %N为码元数

Ts=1;           %码元周期
N_sample=128;   %单个码元抽样点数      
alpha=0.5;        %滚降系数    %码元数
dt=Ts/N_sample; %时间分辨率
t=-3*Ts:dt:3*Ts;

% t1=0:dt:(N/2*N_sample-1)*dt;%序列传输时间

%1 升余弦滚降滤波器的冲激响应h(t)函数

ht=sinc(t/Ts).*(cos(alpha*pi*t/Ts))./(1-4*alpha^2*t.^2/Ts^2+eps);


% figure(1)
% plot(t,ht,'LineWidth',1.5);
% grid on;
% axis([-3 3 -0.2 1.2]);
% xlabel('时间(s)');ylabel('电压值(V)'); 
% title('升余弦滤波器的冲激响应h(t)');

%2 基带脉冲信号
gt_original = [1 zeros(1, N_sample/2-1)];
gt_IQ = [1 zeros(1, N_sample-1)];
RAN = round(rand(1, N)); % 随机0 1序列
seq_original=[];
seq_I = [];
seq_Q = [];
for i = 1 : N % 生成序列
   if RAN(i)==1
       seq_original = [seq_original gt_original];
   else
       seq_original = [seq_original -1*gt_original];
   end
end
for i = 1 : N/2 % 生成序列
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
% figure(2)
% subplot(311)
% plot(t1,seq_original,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('时间(s)');ylabel('电压值(V)'); 
% title('基带脉冲信号时域波形图');
% subplot(312)
% plot(t1,seq_I,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('时间(s)');ylabel('电压值(V)'); 
% title('I路时域波形图');
% subplot(313)
% plot(t1,seq_Q,'LineWidth',1.5);
% axis([0 20 -1.2 1.2]);
% grid on;
% xlabel('时间(s)');ylabel('电压值(V)'); 
% title('Q路时域波形图');


%3 基带脉冲成形
% figure(3);

st_I=conv(seq_I,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;
% subplot(211)
% plot(tt,st_I,'LineWidth',1.5);
% grid on
% axis([0 20 -2 2]);  
% xlabel('时间(s)');title('I路信号成型信号时域波形图');

st_Q=conv(seq_Q,ht);
tt=-3*Ts:dt:(N/2+3)*N_sample*dt-dt;
% subplot(212)
% plot(tt,st_Q,'LineWidth',1.5);
% grid on
% axis([0 20 -2 2]);  
% xlabel('时间(s)');title('Q路信号成型信号时域波形图');

fc=10000;
I = 2 / sqrt(2) * cos(2*pi*fc*tt);
Q = -2 / sqrt(2) * sin(2*pi*fc*tt);
%Signal = st_I.*I + st_Q.*Q;
signal_complex = (st_I + 1j.*st_Q).*exp(1j*2*pi*fc*tt);

Fs=2000;            %采样频率
Ts=1/Fs;            %采样间隔
Fd=50;             %Doppler频偏，Hz
tau=[0,0.001];       %多径延时向量，s
pdb=[0,0];          %多径信道增益向量，dB
chan = rayleighchan(Ts, Fd, tau, pdb);

y = filter(chan,signal_complex);

Signal = real(y);
% figure(4)
% plot(tt, Signal);grid on;axis([0 10 -2 2]);title('QPSK');











