import torch
from torch import nn


class ConNet(nn.Module):

    def __init__(self):
        super(ConNet, self).__init__()

        self.conv_unit = nn.Sequential(
            # [b,1,64,4]
            nn.Conv2d(1,4,kernel_size=2,stride=1,padding=1),

            nn.MaxPool2d(kernel_size=2,stride=1,padding=0),

            nn.Conv2d(4,8,kernel_size=2,stride=2,padding=1),
            #
            nn.MaxPool2d(kernel_size=2,stride=1,padding=0),
            # # [b,8,32,2]
        )

        # tmp = torch.randn(2, 1, 64, 4)
        # out = self.conv_unit(tmp)
        # print('layer 1',out.shape)

        #fully connect
        self.fc_unit = nn.Sequential(
            nn.Linear(8*32*2,128),
            nn.Sigmoid(),
            nn.Linear(128,84),
            nn.Sigmoid(),
            nn.Linear(84, 48),
            nn.Sigmoid(),
            nn.Linear(48,2)
        )

    def forward(self,x):

        batchsz = x.size(0)
        #[b,1,64,4]
        x=self.conv_unit(x)
        #[b,8,32,2]
        x = x.view(batchsz,8*32*2)
        #[b,8*32]
        x = self.fc_unit(x)

        return x

def main():
    net = ConNet()
    tmp = torch.randn(2,1,64,4)
    out = net(tmp)
    print('conv out',out.shape)
    print(net)


if __name__ == '__main__':
    main()


