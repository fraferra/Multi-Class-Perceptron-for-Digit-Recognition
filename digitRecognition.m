% Research Method / CW5 - F. Ferrari and B. Daullxhiu


clear all

%load data
train= load('../ziptrain.dat'); 
test= load('../ziptest.dat'); 

%train = load('../dtrain123.dat');
%test = load('../dtest123.dat');

limit=round(length(train)/3)*2;
%divide validation nad train for hold out method
T=train(1:limit,:);
V=train(limit+1:end,:);

%define initial values
nDigits=10;
epochs=5;
%test error table for graph
tableTestError=[[2:7]; 100*ones(1,6)];
digitsError=[];

fprintf('Calculating optimum value of d using Hold-out method\n\n')
%loop for different value of d
for d=2:7
    %initialize matrix with a coefficient to zero
    a=zeros(nDigits,length(T));
    fprintf('Calculating for d equal to %d\n\n', d)
    %calculate Ktrain and Ktest at the beginning to improve performance
    kernelMatrixTrain=kerneld(T(:,2:end),T(:,2:end), d);
    kernelMatrixTest=kerneld(V(:,2:end),T(:,2:end), d);
    
    %loop through different epochs
    for n=1:epochs
        %start time counting
        t=cputime;
        %call traingen method
        [train_mistakes,a]=traingen(T, a,nDigits, kernelMatrixTrain);
        trainT=cputime-t;
        fprintf('Training - Epoch %i required %d with %i mistakes out of %i items\n', [n trainT train_mistakes length(T)])

        t=cputime;
        [test_mistakes,a, tmpDigitsError]=testclassifiers(T,V, a, nDigits, kernelMatrixTest);
        testT=cputime-t;
        testPercent=test_mistakes/length(V)*100;
        fprintf('Testing - Epoch %i required %i with a test error of %.2f%% \n\n', [n testT testPercent ])
        %when final epoch print errors and confusion table
        if n==epochs
            tableTestError(2,d-1)=testPercent;
            tmpDigitsError
            
        end
        
    end
end
tableTestError
figure(1)
plot([2:7],tableTestError(2,:),'--o')
title('Finding optimal d using Hold-Out method')
xlabel('d')
ylabel('Test Error (%)')
grid on

[kk,minD]=min(tableTestError(2,:));
minD=minD+1;
fprintf('Optimal d= %d\n\n', minD)


%%

nDigits=10;
epochs=5;
tableTestError=[[2:7]; 100*ones(1,6)];
digitsError=[];
fprintf('Calculating optimum value of d using Test set\n\n')
for d=2:7
    a=zeros(nDigits,length(train));
    fprintf('Calculating for d equal to %d\n\n', d)
    %calculate Ktrain adn Ktest to save computational time
    kernelMatrixTrain=kerneld(train(:,2:end),train(:,2:end), d);
    kernelMatrixTest=kerneld(test(:,2:end),train(:,2:end), d);
    %create table to see which scanned digits have been misclassifed during
    %every epoch
    errorScannedDigits=zeros(length(test),2);
    
    for n=1:epochs
        t=cputime;
        [train_mistakes,a]=traingen(train, a,nDigits, kernelMatrixTrain);
        trainT=cputime-t;
        fprintf('Training - Epoch %i required %d with %i mistakes out of %i items\n', [n trainT train_mistakes length(train)])

        t=cputime;
        [test_mistakes,a, tmpDigitsError, errorScannedDigits]=testclassifiers(train,test, a, nDigits, kernelMatrixTest,errorScannedDigits);
        testT=cputime-t;
        testPercent=test_mistakes/length(test)*100;
        fprintf('Testing - Epoch %i required %i with a test error of %.2f%% \n\n', [n testT testPercent ])
        if n==epochs
            tableTestError(2,d-1)=testPercent;
            tmpDigitsError
            fprintf('Total of mistakes values from 0 to 9\n\n')
            
            sum(tmpDigitsError(2:end,3:end))
            %sort the hardest scanned digits to be recognized and print
            %their indexes 
            [Indexhardest5,numTimes]=sort(errorScannedDigits(:,2),1,'descend');
            [Indexhardest5(1:5) numTimes(1:5)]
        end
        
    end
end

tableTestError
figure(2)
plot([2:7],tableTestError(2,:),'--o')
title('Finding optimal d using Test set')
xlabel('d')
ylabel('Test Error (%)')
grid on

[kk,minD]=min(tableTestError(2,:));
minD=minD+1;
fprintf('Optimal d= %d\n\n using Test set', minD)


%%

%the index of the most mistaken digits have been hardcoded. We have looked
%at the indexes that were returned for optimal d=3
fprintf('Printing scanned digit for value= %i\n\n', test(18,1))
figure(10); 

subplot(2,3,1)

imagesc(reshape(test(18,2:end), 16, 16)'); colormap 'gray';

title('Scanned digit = 6')
subplot(2,3,2)

fprintf('Printing scanned digit for value= %i\n\n', test(28,1))
imagesc(reshape(test(28,2:end), 16, 16)'); colormap 'gray';

title('Scanned digit = 3')
subplot(2,3,3)

fprintf('Printing scanned digit for value= %i\n\n', test(123,1))
imagesc(reshape(test(123,2:end), 16, 16)'); colormap 'gray';

title('Scanned digit = 3')
subplot(2,3,4)

fprintf('Printing scanned digit for value= %i\n\n', test(135,1))
imagesc(reshape(test(135,2:end), 16, 16)'); colormap 'gray';

title('Scanned digit = 6')
subplot(2,3,6)

fprintf('Printing scanned digit for value= %i\n\n', test(146,1))
imagesc(reshape(test(146,2:end), 16, 16)'); colormap 'gray';

title('Scanned digit = 2')


