# -*- coding: utf-8 -*-

import numpy as np
from sklearn.model_selection import StratifiedKFold
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix
from sklearn.metrics import roc_curve, auc
import matplotlib.pyplot as plt
import pickle
from numpy import genfromtxt
from sklearn.feature_selection import SelectPercentile, f_classif
from sklearn import preprocessing
from random import shuffle

# funcion para elegir el umbral que resulte en valores balanceados en la diagonal    
def get_optimal_thr_diagonal_cm(probs, target, step): 
    difference = np.zeros((len(np.arange(0,1,step))))
    n=-1
    for thr in np.arange(0,1,step):
        preds_thresholded = np.zeros(len(probs))
        n=n+1
        preds_thresholded[np.where(probs>thr)[0]] = 1
        cm = confusion_matrix(target, preds_thresholded).astype(float)
        cm[0,:] = cm[0,:]/float(sum(cm[0,:]))
        cm[1,:] = cm[1,:]/float(sum(cm[1,:]))
        difference[n] = abs(cm[0,0] - cm[1,1])
    loc = np.where( difference==min(difference))[0]
    return np.arange(0,1,step)[loc][0]
    
# funcion para expandir las matrices en una lista y tomar la parte triangular superior    
def unfold_data(data_list): 
    output = np.zeros((len(data_list), len(data_list[0][np.triu_indices(data_list[0].shape[0],1)])))
    for i,matrix in enumerate(data_list):
        output[i,:] = matrix[np.triu_indices(data_list[0].shape[0],1)]
    return output
    
trust = np.array([])
trustS = np.array([]) 
CM = []
CMS = []
            
importance = []
importanceS = []

CLF1 = []
CLFS = []            
for jj in range(0,1000):    
    n_estimators = 1000 # cantidad de arboles
    n_folds = 5 # cantidad de folds
    print(jj)
    
    
    set1=genfromtxt('/home/krlita/Documents/Post-doc/Machine_learning/KETA/Mat_CorrelAll_PCB.txt',delimiter=',')
    set2=genfromtxt('/home/krlita/Documents/Post-doc/Machine_learning/KETA/Mat_CorrelAll_KET.txt',delimiter=',')
    
    
    
    target1 = np.zeros(set1.shape[0])
    target2 = np.ones(set2.shape[0])
    
   	
    target = np.concatenate((target1, target2), axis=0)
    targetScr = np.concatenate((target1, target2), axis=0)
    shuffle(targetScr)
    data = np.concatenate((set1,set2), axis=0)
    
    
    
    min_max_scaler = preprocessing.MinMaxScaler()
    data = min_max_scaler.fit_transform(data)
    
    
    cv = StratifiedKFold(n_splits=n_folds) # crear objeto de cross validation estratificada
        
    cv_target = np.array([])
    cv_prediction = np.array([])
    cv_probas = np.array([])
    cv_importances = np.zeros((n_folds, data.shape[1] ))

    
    contador = -1
               
    for train, test in cv.split(data,target):
            
            
        contador = contador + 1

        X_train = data[train] # crear sets de entrenamiento y testeo para el fold
        X_test = data[test]
        y_train = target[train]
        y_test = target[test]
        
        selector = SelectPercentile(f_classif, percentile=100)
        selector.fit(X_train, y_train)
        X_train_fs = selector.transform(X_train)
        X_test_fs = selector.transform(X_test)
    
        
        clf = RandomForestClassifier(n_estimators=n_estimators) # crear y luego predecir la probabilidad de estar en 0 o en 1 para cada elemento del train set
        clf = clf.fit(X_train_fs, y_train)
        preds = clf.predict(X_test_fs)
        probas = clf.predict_proba(X_test_fs)
            
        cv_target = np.concatenate((cv_target, y_test), axis=0) # concatenar los resultados
        cv_prediction = np.concatenate((cv_prediction, preds), axis=0)
        cv_probas = np.concatenate((cv_probas, probas[:,1]), axis=0)

    
    preds_thr = np.zeros(len(cv_target))
    thr_final = get_optimal_thr_diagonal_cm(cv_probas, cv_target, 0.01)
    preds_thr[np.where(cv_probas>thr_final)[0]] = 1
    cm = confusion_matrix(cv_target, preds_thr).astype(float)
    cm[0,:] = cm[0,:]/float(sum(cm[0,:])) # obtener matricz de confusion normalizada
    cm[1,:] = cm[1,:]/float(sum(cm[1,:]))
            
        
    fpr, tpr, thresholds = roc_curve(cv_target,  cv_probas) # obtener la curva ROC
    
    print(auc(fpr,tpr)) # area de la curva ROC
    
    T = np.array([auc(fpr,tpr)])
    trust = np.concatenate((trust,T ), axis=0)
    CM.append(cm)
    importance.append(cv_importances)
    #plt.plot(fpr,tpr) # plotear curva ROC
    
    # entrenar y seleccionar en todos datos
    
    selector = SelectPercentile(f_classif, percentile=100)
    selector.fit(data, target)
    data_fs = selector.transform(data)
    
    clf = RandomForestClassifier(n_estimators=n_estimators) # crear y luego predecir la probabilidad de estar en 0 o en 1 para cada elemento del train set
    clf = clf.fit(data_fs, target)
    CLF1.append(clf)
    
    cv_targetS = np.array([])
    cv_predictionS = np.array([])
    cv_probasS = np.array([])
    cv_importancesS = np.zeros((n_folds, data.shape[1] ))
    contador = -1
    for train, test in cv.split(data,targetScr):
        contador = contador + 1
        X_trainS = data[train] # crear sets de entrenamiento y testeo para el fold
        X_testS = data[test]
        y_trainS = targetScr[train]
        y_testS = targetScr[test]
        
        selectorS = SelectPercentile(f_classif, percentile=100)
        selectorS.fit(X_trainS, y_trainS)
        X_train_fsS = selectorS.transform(X_trainS)
        X_test_fsS = selectorS.transform(X_testS)
    
        
        clfS = RandomForestClassifier(n_estimators=n_estimators) # crear y luego predecir la probabilidad de estar en 0 o en 1 para cada elemento del train set
        clfS = clfS.fit(X_train_fsS, y_trainS)
        predsS = clfS.predict(X_test_fsS)
        probasS = clfS.predict_proba(X_test_fsS)
            
        cv_targetS = np.concatenate((cv_targetS, y_testS), axis=0) # concatenar los resultados
        cv_predictionS = np.concatenate((cv_predictionS, predsS), axis=0)
        cv_probasS = np.concatenate((cv_probasS, probasS[:,1]), axis=0)
        cv_importancesS[contador,:] = clfS.feature_importances_
            
    
    preds_thrS = np.zeros(len(cv_targetS))
    thr_finalS = get_optimal_thr_diagonal_cm(cv_probasS, cv_targetS, 0.01)
    preds_thrS[np.where(cv_probasS>thr_finalS)[0]] = 1
    cmS = confusion_matrix(cv_targetS, preds_thrS).astype(float)
    cmS[0,:] = cmS[0,:]/float(sum(cmS[0,:])) # obtener matricz de confusion normalizada
    cmS[1,:] = cmS[1,:]/float(sum(cmS[1,:]))
            
        
    fprS, tprS, thresholdsS = roc_curve(cv_targetS,  cv_probasS) # obtener la curva ROC
    
    print(auc(fprS,tprS)) # area de la curva ROC
    
    TS = np.array([auc(fprS,tprS)])
    trustS = np.concatenate((trustS, TS), axis=0)
    CMS.append(cmS)
    importanceS.append(cv_importancesS)
    #CMS = np.concatenate((CMS,cmS ))
    #importanceS =  np.concatenate((importanceS,cv_importancesS ))
    
    #plt.plot(fpr,tpr) # plotear curva ROC
    CLFS.append(clfS)
    # entrenar y seleccionar en todos datos

plt.hist(trust, bins='auto')    
plt.hist(trustS, bins='auto')      

plt.show()      
                
###selector = SelectPercentile(f_classif, percentile=100)
###selector.fit(data, target)
###data_fs = selector.transform(data)

####clf = RandomForestClassifier(n_estimators=n_estimators) # crear y luego predecir la probabilidad de estar en 0 o en 1 para cada elemento del train set
###clf = clf.fit(data_fs, target)

# generalizar a otro dataset

###set1=genfromtxt('/home/krlita/Documents/Post-doc/Datos/fMRI/Drogas/LSD_raw/LSD_SCANS_part1/Mat_CorrelAll_PCB.txt',delimiter=',')

###set2=genfromtxt('/home/krlita/Documents/Post-doc/Datos/fMRI/Drogas/LSD_raw/LSD_SCANS_part1/Mat_CorrelAll_LSD.txt',delimiter=',')



###target1 = np.zeros(set1.shape[0])
###target2 = np.ones(set2.shape[0])

###target_gen = np.concatenate((target1, target2), axis=0)
###data_gen = np.concatenate((set1,set2), axis=0)

###min_max_scaler = preprocessing.MinMaxScaler()
###data = min_max_scaler.fit_transform(data_gen)

###data_gen_fs = selector.transform(data_gen)


###preds = clf.predict(data_gen_fs)
###probas = clf.predict_proba(data_gen_fs)

###preds_thr = np.zeros(len(target_gen))

###thr_final = get_optimal_thr_diagonal_cm(probas[:,1], target_gen, 0.01)

###preds_thr[np.where(probas[:,1]>thr_final)[0]] = 1

###cm = confusion_matrix(target_gen, preds_thr).astype(float)
###cm[0,:] = cm[0,:]/float(sum(cm[0,:])) # obtener matricz de confusion normalizada
###cm[1,:] = cm[1,:]/float(sum(cm[1,:]))
        
    
###fpr, tpr, thresholds = roc_curve(target_gen,  probas[:,1]) # obtener la curva ROC

###print(auc(fpr,tpr)) # area de la curva ROC

###plt.plot(fpr,tpr) # plotear curva ROC



######

guardar = {'clasificador': CLF1, 'clasificadorS': CLFS, 'importances': importance, 'importancesS': importanceS, 'CM': CM, 'CMS': CMS, 'AUC': trust, 'AUCS': trustS}

pickle.dump(guardar,  open('/home/krlita/Documents/Post-doc/Machine_learning/KETA/clasificador_KET_1000.p', 'wb') )

#cargado = pickle.load(open('C:\Carla\Machine_learning\MDMA\clasificador_MDMA.p', 'rb') )

