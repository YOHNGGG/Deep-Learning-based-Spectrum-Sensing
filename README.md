# Deep-Learning-based-Spectrum-Sensing
The codes for the method that uses feature extraction and deep learning to do spectrum sensing for cognitive radio.

The codes in MATLAB are used to simulate QPSK signal sequenses that pass through frequency-selective Rayleigh fading channel and AWGN channel.Then the signal feature matrixes with different SNR are generated. Use the two types of signal feature matrix as dataset to train CNN model.

The codes in Python are used to load the dataset generated by MATLAB and train CNN networks. We set up both linear network and convolutional network(CNN), and it can be evaluated that the performance of CNN is better. Use Train_CovNet to train a model based on the dataset generated and use Test_CovNet to test the probability of detection and probability of false alarm.
