#Iliana Kogia - 10090
import numpy as np 
import matplotlib.pyplot as plt
import time
#import matplotlib.ticker as mticker
from sklearn.metrics.pairwise import rbf_kernel
from sklearn.preprocessing import StandardScaler
#from sklearn.metrics import accuracy_score
from sklearn.cluster import KMeans


def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        dict = pickle.load(fo, encoding='bytes')
    return dict

#load batches
batch1 = unpickle('cifar-10-batches-py/data_batch_1')
batch2 = unpickle('cifar-10-batches-py/data_batch_2')
batch3 = unpickle('cifar-10-batches-py/data_batch_3')
batch4 = unpickle('cifar-10-batches-py/data_batch_4')
batch5 = unpickle('cifar-10-batches-py/data_batch_5')
batchT = unpickle('cifar-10-batches-py/test_batch')

X_train = np.concatenate([batch1[b'data'], batch2[b'data'], batch3[b'data'], batch4[b'data'], batch5[b'data']])
y_train = np.concatenate([batch1[b'labels'], batch2[b'labels'], batch3[b'labels'], batch4[b'labels'], batch5[b'labels']])

X_test = batchT[b'data']
y_test = np.array(batchT[b'labels'])


def softmax(x):
    return np.exp(x) / sum(np.exp(x))

def binaryClassData(X, y):
    # take 2 classes: airplane / automobile : 0 / 1 
    class1_images = np.where(y == 0)[0]
    class2_images = np.where(y == 1)[0]
    
    selected_i = np.concatenate([class1_images, class2_images])
    X_selected = X[selected_i]
    y_selected = y[selected_i]
    
    #shuffle the data of these 2 classes
    shuffle_i = np.random.permutation(len(selected_i))
    
    X_selected = X_selected[shuffle_i]
    y_selected = y_selected[shuffle_i]
    
    return X_selected, y_selected

def delta_rule_training(X_train, y_train, X_test, y_test, Weights, softmax, learning_rate=0.01, epochs=100, num_classes=10):

    num_trsamples = X_train.shape[0]
    accuracy_train = []
    loss_train = []
    accuracy_test = []
    loss_test = []
    
    for epoch in range(epochs):
        correct_count = 0
        entropy = []
        for i in range (0, num_trsamples):
            
            x = X_train[i,:] #input a sample-image = 1 row, num_cluster features
            
            x = x.reshape(-1,1)
            
            label = y_train[i] #correct class {0,...,9}
            #one hot encoding
            d = np.zeros(num_classes)
            d[label] = 1
            d = d.reshape(-1,1)
            
            y_L = softmax(Weights @ x) #forward
            y_pred = np.argmax(y_L) # one hot decoding 
            
            correct_count += (y_pred == label)
            
            e = d - y_L #error in output layer   
            
            entropy.append(- np.sum(d * np.log(y_L)))
            
            Weights += learning_rate * e * x.T
        
        
        accuracy = correct_count / num_trsamples
        accuracy_train.append(accuracy)
        loss_train.append(np.mean(entropy))
        
        accuracyts, y_predTS, entropyts = predict(X_test, y_test, Weights, softmax) 
        accuracy_test.append(accuracyts)
        loss_test.append(np.mean(entropyts))
        
    return Weights, accuracy_train, accuracy_test, loss_train, loss_test

def predict(X_test, y_test, Weights, softmax):
    correct_count = 0
    test_entropy = []
    for x, y in zip(X_test, y_test):
        x = x.reshape(-1,1)
        y_L = softmax(Weights @ x)
        y_pred = np.argmax(y_L) # one hot decoding 
        
        correct_count += (y_pred == y)
        d = np.zeros(10)
        d[y] = 1
        d = d.reshape(-1,1)

        test_entropy.append(- np.sum(d * np.log(y_L)))
        
    accuracy_ts = correct_count / len(X_test)
    return accuracy_ts, y_pred, test_entropy


#-------------------------------RBF Neural Network----------------------------

# #binary problem of 2 class 
# X_train, y_train = binaryClassData(X_train, y_train)
# X_test, y_test = binaryClassData(X_test, y_test)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

start_time = time.time() #start time

#calculate centers with k-Means
num_clusters = 250 #select
kmeans = KMeans(n_clusters = num_clusters, random_state=42, n_init='auto')
kmeans.fit(X_train)
centers = kmeans.cluster_centers_

# #random centers
# num_clusters = 250
# hidden_neurons = num_clusters
# index = np.random.choice(X_train.shape[0], hidden_neurons, replace=False)
# centers = X_train[index]

# calculate rbf activations
gamma = 0.001 #select
rbf_activations_train = rbf_kernel(X_train, centers, gamma=gamma)
rbf_activations_test = rbf_kernel(X_test, centers, gamma=gamma)

#Train hidden to output layer
max_epoch = 100 #select
learning_rate=0.1 #select

num_classes = 10

#initialize weights
Weights_init = np.random.rand(num_classes, num_clusters) - 0.5 
#delta rule training
function_L = softmax
Weights, accuracy_train, accuracy_test, loss_train, loss_test = delta_rule_training(rbf_activations_train, y_train, rbf_activations_test, y_test, Weights_init, function_L, learning_rate, max_epoch, num_classes)

execution_time = time.time() - start_time    #stop time


#Plots
plt.figure()
epochs = list(range(1, len(accuracy_train) + 1))
plt.plot(epochs, accuracy_train, marker='', linestyle='-', label = 'train acc')
plt.plot(epochs, accuracy_test, marker='', linestyle='-', label = 'test acc')
plt.title(f'Accuracy\n k: {num_clusters}, gamma: {gamma}, Learning Rate: {learning_rate}')
plt.xlabel('Epochs\n\n t: {} s' .format(execution_time))
plt.legend()
plt.grid(True)

plt.figure()
plt.plot(epochs, loss_train, marker='', linestyle='-', label = 'train loss')
plt.plot(epochs, loss_test, marker='', linestyle='-', label = 'test loss')
plt.title(f'Loss\n k: {num_clusters}, gamma: {gamma}, Learning Rate: {learning_rate}')
plt.xlabel('Epochs')
plt.legend()
plt.grid(True)


