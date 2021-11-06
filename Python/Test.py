import torch
from torch.utils.data import DataLoader

from SignalLoader_Test import LoadSignal
from ConNet import ConNet


def main():
    SignalData = LoadSignal('Signal_Test/SNR-16')
    data_loader = DataLoader(SignalData, batch_size=32, shuffle=True,
                            num_workers=1)

    device = torch.device('cuda')

    net = ConNet().to(device)

    total_detection = 0
    total_falsealarm = 0
    y1 = 0
    y0 = 0
    net.load_state_dict(torch.load('model.mdl'))

    for x, label in data_loader:
        x, label = x.to(device), label.to(device)
        l = len(label)
        for i in range(l):
            # print('label[i]',label[i])
            if label[i] == 1:
                x_input = x[i]
                x_input = torch.unsqueeze(x_input, dim=0)
                out = net(x_input)
                pred_1 = out.argmax(dim=1)
                detection = pred_1.eq(label[i]).sum().float().item()
                # print('detection',detection,'pred',pred_1)
                total_detection += detection
                y1 += 1
            if label[i] == 0:
                x_input = x[i]
                x_input = torch.unsqueeze(x_input, dim=0)
                out = net(x_input)
                pred_0 = out.argmax(dim=1)
                falsealarm = pred_0.ne(label[i]).sum().float().item()
                # print(falsealarm,pred_0)
                total_falsealarm += falsealarm
                y0 += 1
    print('number of H1:', y1, 'number of H0:', y0)
    print('number of detection:', total_detection, 'number of false alarm:', total_falsealarm)
    Pd = total_detection / y1
    Pf = total_falsealarm / y0
    print('Pd:', Pd)
    print('Pf:', Pf)


if __name__ == '__main__':
    main()