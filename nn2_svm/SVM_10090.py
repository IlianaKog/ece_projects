#Iliana Kogia - 10090
import numpy as np
import cvxopt 
import matplotlib.pyplot as plt
import time
#import matplotlib.ticker as mticker
from sklearn import metrics 
from sklearn.metrics.pairwise import linear_kernel as Gram_Linear
from sklearn.metrics.pairwise import rbf_kernel as Gram_RBF
from sklearn.metrics.pairwise import polynomial_kernel as Gram_poly

from sklearn.metrics import accuracy_score

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
X_train=((X_train/255)*2)-1


X_test = X_test.astype('float32')
X_test=((X_test/255)*2)-1


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
    
    # y: {-1,1}
    y_selected[ y_selected == 0] = -1
    y_selected[ y_selected == 1] = +1

    return X_selected, y_selected


def kernel_function(x, xi, gamma, const, degree, kernel_ID):
    if kernel_ID == 1: #linear
        K = np.dot(x, xi)
    elif kernel_ID == 2: #RBF
        dist = np.linalg.norm(x - xi)
        K = np.exp( - gamma * dist**2 )
    else:               #Poly
        K = (np.dot(x,xi) + const)**degree
    return K

def computeKernelMatrix(X, kernel_ID, gamma, degree, constant): #Gram Matrix from sklearn
    n = X.shape[0]
    K = np.zeros((n,n))
    if kernel_ID == 1:
        K = Gram_Linear(X,Y = None)
    elif kernel_ID == 2:
        K = Gram_RBF(X,Y = None, gamma=gamma)
    else:
        K = Gram_poly(X,Y = None, gamma=gamma, degree = degree, coef0= constant)
    return K

def predict(X, b, alphas, sv, sv_y, gamma, const, degree, kernel_ID):
    y_pred = np.zeros(X.shape[0])
    for j in range(X.shape[0]):
        s = 0
        for i in range(len(alphas)):
            s += alphas[i] * sv_y[i] * kernel_function(X[j], sv[i], gamma, const, degree, kernel_ID)
        y_pred[j] = s
        
    y_pred = np.sign(y_pred + b)
    return y_pred

def SVM_training(X_train, y_train, X_test, y_test, C, gamma, degree, constant, kernel_ID):
    start_time = time.time()
    K = computeKernelMatrix(X_train, kernel_ID = kernel_ID, gamma=gamma, degree=degree, constant=constant)
    n = len(y_train)

    y_train = y_train.reshape(-1,1) #reshape for the following QP problem
    #find Q matrix
    Q = np.outer(y_train,y_train) * K
    
    #Quadratic Programming solution
    P = cvxopt.matrix(Q)
    q = cvxopt.matrix( - np.ones((n,1)))
    A = cvxopt.matrix(y_train, (1,n), "d")
    b = cvxopt.matrix(0.0)
    #soft margin with C
    G = cvxopt.matrix(np.vstack((np.diag(np.ones(n) * -1), np.identity(n))))
    h = cvxopt.matrix(np.hstack(( np.zeros(n), np.ones(n) * C)))
    
    qp_solution = cvxopt.solvers.qp(P, q, G, h, A, b)
    
    alphas = np.ravel(qp_solution['x'])
    
    sv_indices = (alphas > 1e-4) 
    
    sv = X_train[sv_indices] 
    sv_y = y_train[sv_indices]
    alphas = alphas[sv_indices]
    number_support_vec = len(alphas)
    
    sv_y = sv_y.astype('float64')
    b = 0
    for n in range(len(alphas)):
        s = 0
        for m in range(len(alphas)):
            s += alphas[m] * sv_y[m] * kernel_function(sv[m], sv[n], gamma = gamma , const = constant, degree = degree, kernel_ID = kernel_ID)
        b += sv_y[n] - s
    b /= len(alphas)
    
    alphas = alphas.reshape(-1,1)
    y_pred = predict(X_test, b, alphas, sv, sv_y, gamma, constant, degree, kernel_ID)
    accuracy = accuracy_score(y_test, y_pred)
    
    y_pred_train = predict(X_train, b, alphas, sv, sv_y, gamma, constant, degree, kernel_ID)
    accuracy_train = accuracy_score(y_train, y_pred_train)

    
    execution_time = time.time() - start_time
    print("--- %s seconds ---" % (execution_time))
    return accuracy, y_pred, accuracy_train, y_pred_train, execution_time, number_support_vec


#-------------------------------SVM----------------------------
#binary problem of 2 class 
X_train, y_train = binaryClassData(X_train, y_train)
X_test, y_test = binaryClassData(X_test, y_test)

accTs_list = []
accTr_list = []
y_predTs = []
y_predTr = []
exe_time = []
support = []

##------Kernel_ID: 1 linear, 2 rbf, 3 poly 

# kernel_ID = 2

# #train SVM
# listgamma = [0.0004]
# listC = [10]
# for gamma in listgamma:
#     for C in listC:
#         accuracy, y_pred, accuracy_train, y_pred_train, execution_time, number_support_vec = SVM_training(X_train, y_train, X_test, y_test, C=C, gamma=gamma, degree = None, constant = None, kernel_ID = kernel_ID)
        
#         accTs_list.append(accuracy)
#         accTr_list.append(accuracy_train)
#         y_predTs.append(y_pred)
#         y_predTr.append(y_pred_train)
#         exe_time.append(execution_time)
#         support.append(number_support_vec)

kernel_ID = 1  
listC = [1]     
for C in listC:
    accuracy, y_pred, accuracy_train, y_pred_train, execution_time, number_support_vec = SVM_training(X_train, y_train, X_test, y_test, C=C, gamma=None, degree = None, constant = None, kernel_ID = kernel_ID)
        
    accTs_list.append(accuracy)
    accTr_list.append(accuracy_train)
    y_predTs.append(y_pred)
    y_predTr.append(y_pred_train)
    exe_time.append(execution_time)
    support.append(number_support_vec)
 
    
# confusion_matrix = metrics.confusion_matrix(y_test, y_pred)
# cm_display = metrics.ConfusionMatrixDisplay(confusion_matrix = confusion_matrix, display_labels = ['airplane', 'car'])
# cm_display.plot()
# plt.show()



