
%% ===============================
% MACHINE LEARNING SETTLEMENT MODEL
% ================================

clear; clc; close all;
data = readtable('C:\Users\Srijan\Downloads\Consolidation\soil_settlement.xlsx');
data.Properties.VariableNames = ...
{'Sigma_z','Dr','H','D','SandType','D10','D30','D60','Settlement','CU','CC','Br'};
data.Properties.VariableNames
data.SandType = categorical(data.SandType);
data = rmmissing(data);
data.Cu_calc = data.D60 ./ data.D10;
data.Cc_calc = (data.D30.^2) ./ (data.D10 .* data.D60);
numVars = varfun(@isnumeric,data,'OutputFormat','uniform');
data{:,numVars} = normalize(data{:,numVars});
X = data(:,{'Sigma_z','Dr','H','D','D10','D30','D60','Cu_calc','Cc_calc','SandType'});

Y = data.Settlement;
cv = cvpartition(height(data),'HoldOut',0.2);

Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));

Xtest = X(test(cv),:);
Ytest = Y(test(cv));
model_rf = fitrensemble(Xtrain,Ytrain,'Method','Bag');
Ypred = predict(model_rf,Xtest);

rmse = sqrt(mean((Ytest - Ypred).^2));
mae = mean(abs(Ytest - Ypred));
R2 = 1 - sum((Ytest - Ypred).^2) / sum((Ytest - mean(Ytest)).^2);

scatter(Ytest,Ypred)
xlabel('Actual Settlement')
ylabel('Predicted Settlement')
grid on

residuals = Ytest - Ypred;
plot(residuals)
title('Residual Plot')

model_cv = fitrensemble(X,Y,'KFold',5);
loss = kfoldLoss(model_cv)


model_opt = fitrensemble(Xtrain,Ytrain,'Method','Bag', ...
'OptimizeHyperparameters','auto');

