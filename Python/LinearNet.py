import torch
from torch import nn
from torch.nn import functional as  F


class LinearNet(nn.Module):

    def __init__(self):
        super(LinearNet, self).__init__()

        self.fc1 = nn.Linear(2 * 64, 64)
        self.fc2 = nn.Linear(64, 32)
        self.fc3 = nn.Linear(32, 16)
        self.fc4 = nn.Linear(16, 2)

    def forward(self, x):
        x = self.fc1(x)
        # x:[b,1,32,2]
        x = F.sigmoid(x)
        x = self.fc2(x)
        x = F.sigmoid(x)
        x = self.fc3(x)
        x = F.sigmoid(x)
        x = self.fc4(x)

        return x