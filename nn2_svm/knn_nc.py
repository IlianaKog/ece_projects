#Iliana Kogia - 10090
#Cifar-10 dataset

import numpy as np

from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

from sklearn.neighbors import NearestCentroid
from sklearn.metrics import classification_report

def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        dict = pickle.load(fo, encoding='bytes')
    return dict

#load batches, we need the dataset in the same file as the .py file
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
#X_train=((X_train/255)*2)-1
X_train /= 255

X_test = X_test.astype('float32')
#X_test=((X_test/255)*2)-1
X_test /= 255

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
    #y_selected[ y_selected == 0] = -1
    #y_selected[ y_selected == 1] = +1

    return X_selected, y_selected

#binary problem of 2 class 
X_train, y_train = binaryClassData(X_train, y_train)
X_test, y_test = binaryClassData(X_test, y_test)

print('------ k-NN Classifier------')
for k in range(1,4,2): #k hyper-parameter
    knn_classifier = KNeighborsClassifier(n_neighbors=k)
    knn_classifier.fit(X_train, y_train)

    y_pred = knn_classifier.predict(X_test)

    accuracy = accuracy_score(y_test, y_pred)
    print(f'Accuracy for k = {k} : {accuracy * 100:.2f}%')
    print(f'Model classification report for k = {k} : \n {classification_report(y_test, y_pred)}')
    

print('------ Nearest Centroid Classifier ------')

nc_clf = NearestCentroid()
nc_clf.fit(X_train, y_train)

y_pred = nc_clf.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)

print(f'Test-set score/Accuracy: {nc_clf.score(X_test, y_test) * 100:.2f}%')
print(f'Model classification report : \n {classification_report(y_test, y_pred)}')

cm = confusion_matrix(y_test, y_pred)

print('Confusion Matrix - Nearest Centroid')
rows = len(cm)
cols = len(cm)
print("   " + " ".join(f"{j:<4}" for j in range(cols)))
for i in range(rows):
    print(f"{i}: " + " ".join(f"{cm[i][j]:<4}" for j in range(cols)))
