% Research Method / CW5 - F. Ferrari and B. Daullxhiu

clear all
train= load('../../ziptrain.dat'); 
test= load('../../ziptest.dat'); 

%train = load('../../dtrain123.dat');
%test = load('../../dtest123.dat');

limit=round(length(train)/3)*2;

T=train(1:limit,:);
V=train(limit+1:end,:);


nDigits=10;
epochs=3;

digitsError=[];

c=[1 0.1 0.01 0.001]
tableTestError=[c; 100*ones(1,length(c))];
%%
fprintf('Calculating optimum value of d using Test set\n\n')
for d=1:length(c)
    a=zeros(nDigits,length(T));
    fprintf('Calculating for c equal to %d\n\n', c(d))
    
    errorScannedDigits=zeros(length(V),2);
    
    for n=1:epochs
        t=cputime;
        [train_mistakes,a]=traingen(T, a,nDigits, c(d));
        trainT=cputime-t;
        fprintf('Training - Epoch %i required %d with %i mistakes out of %i items\n', [n trainT train_mistakes length(T)])

        t=cputime;
        [test_mistakes,a, tmpDigitsError, errorScannedDigits]=testclassifiers(T,V, a, nDigits, c(d),errorScannedDigits);
        testT=cputime-t;
        testPercent=test_mistakes/length(V)*100;
        fprintf('Testing - Epoch %i required %i with a test error of %.2f%% \n\n', [n testT testPercent ])
        if n==epochs
            %print confusion table and get the hardest sanned digits to
            %recognize
            tableTestError(2,d)=testPercent;
            tmpDigitsError
            fprintf('Total of mistakes values from 0 to 9\n\n')
            sum(tmpDigitsError(2:end,3:end))
            [Indexhardest5,numTimes]=sort(errorScannedDigits(:,2),1,'descend');
            Indexhardest5=Indexhardest5(1:5);
            numTimes=numTimes(1:5);
            [Indexhardest5 numTimes]
        end
        
    end
end

tableTestError
figure(2)
plot(log10(c),tableTestError(2,:),'--o')
title('Finding optimal c using Hold-out method')
xlabel('Log10(c)')
ylabel('Test Error (%)')
grid on

[kk,minD]=min(tableTestError(2,:));
minD=minD+1;
fprintf('Optimal d= %d\n\n using Test set', minD)



%%
fprintf('Calculating optimum value of c using Test set\n\n')
for d=1:length(c)
    a=zeros(nDigits,length(train));
    fprintf('Calculating for c equal to %d\n\n', c(d))
    
    errorScannedDigits=zeros(length(test),2);
    
    for n=1:epochs
        t=cputime;
        [train_mistakes,a]=traingen(train, a,nDigits, c(d));
        trainT=cputime-t;
        fprintf('Training - Epoch %i required %d with %i mistakes out of %i items\n', [n trainT train_mistakes length(train)])

        t=cputime;
        [test_mistakes,a, tmpDigitsError, errorScannedDigits]=testclassifiers(train,test, a, nDigits, c(d),errorScannedDigits);
        testT=cputime-t;
        testPercent=test_mistakes/length(test)*100;
        fprintf('Testing - Epoch %i required %i with a test error of %.2f%% \n\n', [n testT testPercent ])
        if n==epochs
            tableTestError(2,d)=testPercent;
            tmpDigitsError
            fprintf('Total of mistakes values from 0 to 9\n\n')
            sum(tmpDigitsError(2:end,3:end))
            [Indexhardest5,numTimes]=sort(errorScannedDigits(:,2),1,'descend');
            Indexhardest5=Indexhardest5(1:5);
            numTimes=numTimes(1:5);
            [Indexhardest5 numTimes]
        end
        
    end
end

tableTestError
%%
figure(2)
plot(log10(c),tableTestError(2,:),'--o')
title('Finding optimal c using Test set')
xlabel('Log10(c)')
ylabel('Test Error (%)')
grid on

[kk,minD]=min(tableTestError(2,:));
minD=minD+1;
fprintf('Optimal c= %d\n\n using Test set', minD)


%%
numTimes=[18 123 135 146 161];
%the index of the most mistaken digits have been hardcoded. We have looked
%at the indexes that were returned for optimal d=3
fprintf('Printing scanned digit for value= %i\n\n', test(18,1))
figure(10); 

subplot(2,3,1)

imagesc(reshape(test(numTimes(1),2:end), 16, 16)'); colormap 'gray';

str=sprintf('Scanned digit = %i',test(numTimes(1),1));
title(str)
subplot(2,3,2)

fprintf('Printing scanned digit for value= %i\n\n', test(28,1))
imagesc(reshape(test(numTimes(2),2:end), 16, 16)'); colormap 'gray';

str=sprintf('Scanned digit = %i',test(numTimes(2),1));
title(str)
subplot(2,3,3)

fprintf('Printing scanned digit for value= %i\n\n', test(123,1))
imagesc(reshape(test(numTimes(3),2:end), 16, 16)'); colormap 'gray';

str=sprintf('Scanned digit = %i',test(numTimes(3),1));
title(str)
subplot(2,3,4)

fprintf('Printing scanned digit for value= %i\n\n', test(135,1))
imagesc(reshape(test(numTimes(4),2:end), 16, 16)'); colormap 'gray';

str=sprintf('Scanned digit = %i',test(numTimes(4),1));
title(str)
subplot(2,3,6)

fprintf('Printing scanned digit for value= %i\n\n', test(146,1))
imagesc(reshape(test(numTimes(5),2:end), 16, 16)'); colormap 'gray';

str=sprintf('Scanned digit = %i',test(numTimes(5),1));
title(str)


