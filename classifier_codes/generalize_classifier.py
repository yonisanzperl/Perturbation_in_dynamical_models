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

with open('C:/Users/yonis/Documents/Laburo/Work_c_Carla/Propofol_dataset_car/clasificador_WP_I_77_1000.p', 'rb') as f:
   cargado  = pickle.load(f)

       
trust = []
trustS = []
CM = []
CMS = []
            
set1=genfromtxt("C:/Users/yonis/Documents/Laburo/Work_c_Carla/Propofol_dataset_car/Multi_WP_77.txt",delimiter=",")

set2=genfromtxt('C:/Users/yonis/Documents/Laburo/Work_c_Carla/Propofol_dataset_car/Multi_S_77.txt',delimiter=',')
    
target1 = np.zeros(set1.shape[0])
target2 = np.ones(set2.shape[0])
    
target = np.concatenate((target1, target2), axis=0)
data = np.concatenate((set1,set2), axis=0)

clfs = cargado["clasificador"]
clfsS = cargado["clasificadorS"]

for n in np.arange(len(clfs)):
    
    print(n)
    clf  = clfs[n]
    clfS  = clfsS[n]

    preds =  clf.predict(data)
    predsS =  clfS.predict(data)
    
    probasS = clfS.predict_proba(data)
    probas = clf.predict_proba(data)
    
    # evaluar no shuffleado
    
    preds_thr = np.zeros(len(target))
    thr_final = get_optimal_thr_diagonal_cm(probas[:,1], target, 0.01)
    preds_thr[np.where(probas[:,1]>thr_final)[0]] = 1
    cm = confusion_matrix(target, preds_thr).astype(float)
    cm[0,:] = cm[0,:]/float(sum(cm[0,:])) # obtener matricz de confusion normalizada
    cm[1,:] = cm[1,:]/float(sum(cm[1,:]))
            
        
    fpr, tpr, thresholds = roc_curve(target,   probas[:,1]) # obtener la curva ROC
    
    print(auc(fpr,tpr)) # area de la curva ROC
    
    trust.append(auc(fpr,tpr))
    CM.append(cm)
    
    # evaluar shuffleado
    
    preds_thrS = np.zeros(len(target))
    thr_finalS = get_optimal_thr_diagonal_cm(probasS[:,1], target, 0.01)
    preds_thrS[np.where(probasS[:,1]>thr_finalS)[0]] = 1
    cmS = confusion_matrix(target, preds_thrS).astype(float)
    cmS[0,:] = cmS[0,:]/float(sum(cmS[0,:])) # obtener matricz de confusion normalizada
    cmS[1,:] = cmS[1,:]/float(sum(cmS[1,:]))
            
        
    fprS, tprS, thresholdsS = roc_curve(target,  probasS[:,1]) # obtener la curva ROC
    
    print(auc(fprS,tprS)) # area de la curva ROC
    
    trustS.append(auc(fprS,tprS))
    CMS.append(cmS)
    

    
guardar = { 'CM': CM, 'CMS': CMS, 'AUC': trust, 'AUCS': trustS}

pickle.dump(guardar,  open('C:/Users/yonis/Documents/Laburo/Work_c_Carla/Propofol_dataset_car/generalizado_I_a_S.p', 'wb') )



