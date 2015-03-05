% Research Method / CW5 - F. Ferrari and B. Daullxhiu

function [ mistakes, a, confusionTable, errorScannedDigits ] = testclassifiers( trainSet, testSet, a, nDigits, c,errorScannedDigits )
% Test perceptron 
% Algorithm similar to traingen but without the update step.
% it returns the number of mistakes, the coefficient matrix a, a confusion
% table that dislays which digits were confused with others and an updated
% version of errorScannedDigits, a matrix that tells which specific scanned
% digit was misclassified during each epoch.


mistakes=0;
errorTable=[[0 0:9]' zeros(11,1)];
confusionTable=[errorTable [[0:9];zeros(10,10)]];
for i=1:length(testSet)
    realY=testSet(i,1);
    x=testSet(i,2:end);
    y=-1;
    maxi=0;
    
    errorScannedDigits(i,1)=i;
    
    preds =zeros(1,nDigits);
    updateKernel=gaussianKernel(x,trainSet(:,2:end),c);
    for j=1:nDigits
        preds(j)= classpredk(updateKernel,a(j,:));
    end

    maxc=-10^9;
    for j=0:nDigits-1
        if realY==j
            y=1;
        else
            y=-1;
        end
        
        if preds(j+1)>maxc
            maxc=preds(j+1);
            maxi=j;
        end
        
    end
    if maxi~=realY
        confusionTable(realY+2,2)=confusionTable(realY+2,2)+1;
        confusionTable(realY+2,maxi+3)=confusionTable(realY+2,maxi+3)+1;
        mistakes=mistakes+1;
        
        errorScannedDigits(i,2)=errorScannedDigits(i,2)+1;
    end
end
end

