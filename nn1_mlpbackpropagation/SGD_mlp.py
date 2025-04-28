import numpy as np
import matplotlib.pyplot as plt
import time
import matplotlib.ticker as mticker


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

#normalize
X_train = X_train.astype('float32')
X_train /= 255
X_test = X_test.astype('float32')
X_test /= 255


def sigmoid(x):
    return 1.0 / (1.0 + np.exp(-x))

def d_sigmoid(x):
    return sigmoid(x) * (1 - sigmoid(x))

def softmax(x):
    return np.exp(x) / sum(np.exp(x))


def forward(L, W, x, L_softmax):
    Z=[]
    Z.append(x) # Z[0] = x input
    for l in range(1,L+1): #l = 1, ..., L
        if l < L: #hidden layers
            
            a_in = W[l-1] @ Z[l-1]
            net_o = sigmoid(a_in)
            net_o = np.append(net_o, 1).reshape(-1,1) #add bias for the next layer input
            
            Z.append(net_o)
            
        else: #output layer l==L
            if L_softmax == True:
                Z.append(softmax(W[l-1] @ Z[l-1])) 
            else:
                Z.append(sigmoid(W[l-1] @ Z[l-1])) 
            y_L = Z[-1]
            
    return y_L, Z

def backward(L, W, Z, e, L_softmax):
    deltas = [] #init in every backward computation
    for l in range(L,0,-1): #l = L, .., 1
    
        if l == L: #output layer
            if L_softmax == False:
                back = e * (d_sigmoid(W[L-1] @ Z[L-1])) 
            else:
                back = e
            deltas.append(back)
            
        else: #hidden layers
            w = W[l] 
            w = w[:,:-1] #exclude last column with bias
            
            back1 = w.T @ deltas[-1]
            back2 = d_sigmoid(W[l-1] @ Z[l-1]) #f'
            
            back = back1 * back2
            
            deltas.append(back)
    
    return deltas

def prediction(L, W, val_x, val_y,L_softmax):
    correct_counter = 0
    test_errors = []
    test_entropy = []
    for x, y in zip(val_x, val_y):
        
        x = np.append(x, 1).reshape(-1,1)
        y_L, Z = forward(L, W, x, L_softmax)
        y_pred = np.argmax(y_L) # one hot decoding 
        correct_counter += y_pred == y
        
        d = np.zeros(10)
        d[y] = 1
        d = d.reshape(-1,1)
        
        e = d - y_L
        #test_errors.append(np.sum( np.sum((e) ** 2,axis=0)))
        test_entropy.append(- np.sum(d * np.log(y_L)))
        
    val_accuracy = correct_counter / len(val_x)
    
    return val_accuracy, test_errors, test_entropy

#Initialize MLP
N_in = 3072 
N_out = 10  

N = [N_in, 50 , N_out]

L_softmax = True
alpha = 0.01
num_trsamples = len(X_train)
max_epoch = 10

L = len(N) - 1 #layers - 1, L=0 input layer L = 2 output layer

dimensions = [(N[i], N[i - 1] + 1) for i in range(1, len(N))]
W = [np.random.uniform(-0.5 , 0.5, size = dim) for dim in dimensions] #init weights between layers
sum_grads = [np.zeros(dim) for dim in dimensions]

acc_values = []
test_acc_values = []
test_mse = []
t_crossentropy = []
mse = []
cross_entropy_loss = []

correct_count = 0
epoch = 1
start_time = time.time()
while epoch <= max_epoch:
    print(f'Epoch: {epoch}')
    
    #shuffle training data for every epoch
    index = np.arange(len(X_train))
    np.random.shuffle(index)
    X_train = X_train[index]
    y_train = y_train[index]
    
    #-----init in every epoch-----
    errors = []
    entropy = []
    correct_count = 0 
            
    for i in range (0, num_trsamples): #every batch has the same number of images
        
        x = X_train[i,:] #input a sample-image = 1 row, 3072 features
        
        x = np.append(x, 1).reshape(-1,1) #epauksimeno, bias +1 in the end 
        
        label = y_train[i] #correct class {0,...,9}
        #one hot encoding
        d = np.zeros(10)
        d[label] = 1
        d = d.reshape(-1,1)
        
        #---------------Forward Computation----------------
        y_L, Z = forward(L, W, x, L_softmax)
        
        y_pred = np.argmax(y_L) # one hot decoding 
        correct_count += y_pred == label
            
        e = d - y_L #error in output layer     
        #errors.append(np.sum( np.sum((e) ** 2,axis=0)))    
        
        entropy.append(- np.sum(d * np.log(y_L)))
 
        #--------------Backward Computation---------------
        deltas = backward(L, W, Z, e, L_softmax)
        
        deltas = list(reversed(deltas))
        
        #-------------find grad and update---------------------
        for l in range(0,L):
            
            z = Z[l].transpose()
            delta = deltas[l]
            grad = delta @  z
            
            W[l] = W[l] + alpha * grad
         
    accuracy = correct_count / num_trsamples
    acc_values.append(accuracy)    
    print('accuracy ', accuracy)
    
    tacc, t_errors, t_entropy = prediction(L, W, X_test, y_test, L_softmax)
    test_acc_values.append(tacc)
    
    # mse.append(np.mean(errors))
    # test_mse.append(np.mean(t_errors))
    
    cross_entropy_loss.append( np.mean(entropy) )
    t_crossentropy.append(np.mean(t_entropy))
    

    epoch += 1


execution_time = time.time() - start_time
print("--- %s seconds ---" % (execution_time))


countplots = 36

# Plots
plt.figure()
epochs = list(range(1, len(acc_values) + 1))

plt.plot(epochs, acc_values, marker='', linestyle='-', label = 'train acc')
plt.legend(['train_acc'])
plt.plot(epochs, test_acc_values, marker='', linestyle='-', label = 'test acc')
plt.xlabel('Epochs\n\n t: {} s' .format(execution_time))
plt.ylabel('Accuracy')
plt.title(f'DNN: L = {L}, hd layers = {L-1}, hd neurons: {N[1:-1]}, learning rate: {alpha} \n Accuracy')
plt.legend()
plt.grid(True)
#plt.savefig('accuracy_plot{}.png' .format(countplots), bbox_inches='tight')
plt.show()

# plt.figure()
# plt.plot(epochs, mse, marker='', linestyle='-', label = 'train mse')
# plt.xlabel('Epochs')
# plt.ylabel('MSE')
# plt.title(f'DNN: L = {L}, hd layers = {L-1}, hd neurons: {N[1:-1]}, learning rate: {alpha}\n')
# plt.plot(epochs, test_mse, marker='', linestyle='-', label = 'test_mse')
# plt.legend()
# plt.grid(True)
# plt.savefig('mse{}.png'.format(countplots), bbox_inches='tight')
# plt.show()

plt.figure()
plt.plot(epochs, cross_entropy_loss, marker='', linestyle='-', label = 'train loss')
plt.xlabel('Epochs')
plt.ylabel('Cross entropy')
plt.title(f'DNN: L = {L}, hd layers = {L-1}, hd neurons: {N[1:-1]}, learning rate: {alpha}\n')
plt.plot(epochs, t_crossentropy, marker='', linestyle='-', label = 'test loss')
plt.legend()
plt.grid(True)
#plt.savefig('crossentropy{}.png'.format(countplots), bbox_inches='tight')
plt.show()


