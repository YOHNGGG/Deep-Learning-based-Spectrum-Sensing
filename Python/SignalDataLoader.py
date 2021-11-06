import torch
import os, glob
import random
import csv
from torch.utils.data import Dataset,DataLoader
from torchvision import transforms
from scipy.io import loadmat

class LoadSignal(Dataset):

    def __init__(self,root,mode):
        super(LoadSignal, self).__init__()

        self.root = root

        self.name2label = {} #signal0
        for name in sorted(os.listdir(os.path.join(root))):
            if not os.path.isdir(os.path.join(root, name)):
                continue
            self.name2label[name] = len(self.name2label.keys())

        #print(self.name2label)

        # data,label
        self.signals,self.labels = self.load_csv('signal.csv')

        if mode == 'train':
            self.signals = self.signals[:int(0.6*len(self.signals))]
            self.labels = self.labels[:int(0.6*len(self.labels))]
        elif mode == 'val':
            self.signals = self.signals[int(0.6*len(self.signals)):int(0.8*len(self.signals))]
            self.labels = self.labels[int(0.6*len(self.labels)):int(0.8*len(self.labels))]
        else:
            self.signals = self.signals[int(0.8*len(self.signals)):]
            self.labels = self.labels[int(0.8*len(self.labels)):]

    def load_csv(self,filename):

        if not os.path.exists(os.path.join(self.root,filename)):
            signals=[]
            for name in self.name2label.keys():
                signals += glob.glob(os.path.join(self.root,name,'*.mat'))

            #print(len(signals),signals)

            random.shuffle(signals)
            with open(os.path.join(self.root,filename),mode='w',newline='') as f:
                writer = csv.writer(f)
                for sig in signals:
                    name = sig.split(os.sep)[-2]
                    label = self.name2label[name]
                    writer.writerow([sig,label])


        signals = []
        labels = []
        with open(os.path.join(self.root,filename)) as f:
            reader = csv.reader(f)
            for row in reader:
                sig,label = row
                label = int(label)
                signals.append(sig)
                labels.append(label)

        assert len(signals) == len(labels)

        return signals, labels


    def __len__(self):
        return len(self.signals)

    def __getitem__(self, idx):
        #img:root label:0/1
        sig,label = self.signals[idx],self.labels[idx]
        sig = torch.from_numpy(loadmat(sig)['feature'])
        sig = sig.type(torch.FloatTensor)
        sig = torch.unsqueeze(sig, dim=0)
        label = torch.tensor(label)

        return sig,label



def main():
    db = LoadSignal('dataset','test')
    train_loader = DataLoader(db, batch_size=16, shuffle=True,
                              num_workers=1)

    a=0
    for x,y in train_loader:
        x = x.view(x.size(0), 64 * 2)
        print(x.shape,y.shape,y)
        l = len(y)
        for i in range(l):
            if y[i] == 1:
                input = x[i]
                input = input.view(64*2)
                print(input,input.shape)

        print(a)
        break



    #x,y = next(iter(train_loader))
    #print(x,x.shape,y,y.shape)


if __name__ == '__main__':
    main()
