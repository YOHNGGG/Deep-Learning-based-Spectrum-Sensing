import torch
from torch.nn import functional as  F
from torch import optim
from torch.utils.data import DataLoader

from SignalDataLoader import LoadSignal

from LinearNet import LinearNet
from utils import one_hot


def main():
    signal_train = LoadSignal('dataset',mode='train')
    signal_test = LoadSignal('dataset', mode='test')
    signal_val = LoadSignal('dataset', mode='val')
    train_loader = DataLoader(signal_train, batch_size=16, shuffle=True,
                              num_workers=1)
    test_loader = DataLoader(signal_test, batch_size=16, shuffle=True,
                              num_workers=1)
    val_loader = DataLoader(signal_val, batch_size=16, shuffle=True,
                             num_workers=1)

    net = LinearNet()
    optimizer = optim.SGD(net.parameters(),lr=0.01,momentum=0.9)
    train_loss = []

    for epoch in range(15):

        for batch_idx,(x,y) in enumerate(train_loader):

            #print(x.shape,y.shape)

            x = x.view(x.size(0), 64*2)
            #[b,1,32,2] - [b,32*2]
            out = net(x)
            y_onehot = one_hot(y)
            #print(y.shape,y_onehot.shape,out.shape)
            loss = F.mse_loss(out,y_onehot)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            train_loss.append(loss.item())
            if batch_idx % 5 ==0:
                print(epoch,batch_idx,loss.item())

        total_correct = 0
        for x,y in val_loader:
            x = x.view(x.size(0),64*2)
            out = net(x)
            # [b,2]
            pred = out.argmax(dim=1)
            correct = pred.eq(y).sum().float().item()
            print('val','pred',pred,'y',y)
            total_correct += correct
        total_num= len(val_loader.dataset)
        print(total_correct,total_num)
        acc = total_correct / total_num
        print('val accuracy:',acc)

    total_detection = 0
    total_falsealarm = 0
    y1 = 0
    y0 = 0
    for x,y in test_loader:
        print(x.shape,y.shape,y)
        l = len(y)
        for i in range(l):
            print('y[i]',y[i])
            if y[i] == 1:
                x_input = x[i].view(64*2)
                out = net(x_input)
                pred_1 = out.argmax()
                detection = pred_1.eq(y[i]).sum().float().item()
                print('detection',detection,'pred',pred_1)
                total_detection += detection
                y1 += 1
            if y[i] == 0:
                x_input = x[i].view(64*2)
                out = net(x_input)
                pred_0 = out.argmax()
                falsealarm = pred_0.ne(y[i]).sum().float().item()
                print(falsealarm,pred_0)
                total_falsealarm += falsealarm
                y0 += 1
    print(y1,y0)
    print(total_detection,total_falsealarm)
    Pd = total_detection/y1
    Pf = total_falsealarm/y0
    print('Pd:', Pd)
    print('Pf:', Pf)

if __name__ == '__main__':
    main()