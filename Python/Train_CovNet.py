import torch
from torch import nn
from torch.nn import functional as  F
from torch import optim
from torch.utils.data import DataLoader
from torch.optim import lr_scheduler

from SignalDataLoader import LoadSignal
from ConNet import ConNet

def main():

    signal_train = LoadSignal('dataset',mode='train')
    signal_test = LoadSignal('dataset', mode='test')
    signal_val = LoadSignal('dataset', mode='val')
    train_loader = DataLoader(signal_train, batch_size=32, shuffle=True,
                              num_workers=1)
    test_loader = DataLoader(signal_test, batch_size=32, shuffle=True,
                              num_workers=1)
    val_loader = DataLoader(signal_val, batch_size=32, shuffle=True,
                             num_workers=1)

    #print(x,x.shape,y,y.shape)
    device = torch.device('cuda')
    net = ConNet().to(device)
    criteon = nn.CrossEntropyLoss().to(device)
    optimizer = optim.SGD(net.parameters(), lr=0.01, momentum=0.9)
    scheduler = lr_scheduler.StepLR(optimizer, step_size=20, gamma=0.1)

    best_acc,best_epoc =0,0

    for epoch in range(50):

        net.train()
        for batch_idx, (x,label) in enumerate(train_loader):

            x, label = x.to(device),label.to(device)

            logits = net(x)

            loss = criteon(logits,label)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

        print('epoch:',epoch,'loss:',loss.item())
        scheduler.step()

        net.eval()
        with torch.no_grad():
            total_correct = 0
            total_num = 0
            for x,label in val_loader:

                x,label = x.to(device),label.to(device)

                logits = net(x)

                pred = logits.argmax(dim=1)

                total_correct += torch.eq(pred,label).float().sum().item()
                total_num += x.size(0)

            accuracy = total_correct/total_num

            if accuracy>best_acc:
                best_epoc = epoch
                best_acc = accuracy

                torch.save(net.state_dict(),'model.mdl')

        print('best_epoch:',best_epoc,'best_accuracy:',best_acc)




    total_detection = 0
    total_falsealarm = 0
    y1 = 0
    y0 = 0
    net.load_state_dict(torch.load('model.mdl'))
    for x,label in test_loader:
        x,label = x.to(device),label.to(device)
        l = len(label)
        for i in range(l):
            #print('label[i]',label[i])
            if label[i] == 1:
                x_input = x[i]
                x_input = torch.unsqueeze(x_input, dim=0)
                out = net(x_input)
                pred_1 = out.argmax(dim=1)
                detection = pred_1.eq(label[i]).sum().float().item()
                #print('detection',detection,'pred',pred_1)
                total_detection += detection
                y1 += 1
            if label[i] == 0:
                x_input = x[i]
                x_input = torch.unsqueeze(x_input, dim=0)
                out = net(x_input)
                pred_0 = out.argmax(dim=1)
                falsealarm = pred_0.ne(label[i]).sum().float().item()
                #print(falsealarm,pred_0)
                total_falsealarm += falsealarm
                y0 += 1
    print('number of H1:',y1,'number of H0:',y0)
    print('number of detection:',total_detection,'number of false alarm:',total_falsealarm)
    Pd = total_detection/y1
    Pf = total_falsealarm/y0
    print('Pd:', Pd)
    print('Pf:', Pf)

if __name__ == '__main__':
    main()
