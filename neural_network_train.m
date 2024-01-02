%this is the command lines used to train and predict the results
%read the age of all samples
age = csvread('train_age.csv',1,1);

%these are the numbers of the data that is unavailable after segmentation
miss = [3,5,8,15,16,17,19,20,21,22,26,31,33,34,36,37,41,43,44,47,54,...
    58,61,62,63,68,69,70,71,72,73,74,77,80,82,84,87,90,...
    91,94,96,97,98,99,102,103,108,109,110,111,112,114,...
    117,118,119,120,121,123,125,126,127,130,131,132,134,...
    135,137,138,147,149,150,151,153,156,157,160,161,162,...
    163,164,168,169,172,174,175,176,177,178,179,181,183,...
    184,187,188,192,195,196,198,199,200,201,202,203,207,...
    211,212,213,214,215,217,218,219,220,223,224,225,226,...
    227,228,229,230,231,234,235,237,239,240,241,242,243,...
    244,245,247,249,251,252,253,254,256,257,258,259,260,261,265,266,268];

%calculates the volume of the 209 brain regions respectively
vol = volume_rec;

%remove the unavailable datasets' corresponding age
new_age = takeoutmiss(miss, age);

%find the gray and white matter volume from the original dataset
[gm,wm] = GWseg;

%remove the unavailable datasets' corresponding grey/white matter volume
gm = takeoutmiss(miss,gm);
wm = takeoutmiss(miss,wm);

%split the remaining 123 samples into 100 training samples and 23
%validation samples
train_age = new_age(1:100);
test_age = new_age(101:123);

%the total feature matrix contains 123 samples and 209 features
%set the first row to be the volume of grey matter, the second one white
%matter, the rest are labelled brain regions
features = zeros(123,209);
features(:,1) = gm;
features(:,2) = wm;
features(:,3:209) = vol(:,2:208);
trainf = features(1:100,:);
testf = features(101:123,:);
train_age = train_age';

%neural network construction
%note eventually we have the training features to be 100 x 209
%and the outcome (age) is 100 x 1
layer = featureInputLayer(209);
layers = [layer; fullyConnectedLayer(10);batchNormalizationLayer
    reluLayer; fullyConnectedLayer(1);regressionLayer];
Igraph = layerGraph(layers);
XValidation = testf;
YValidation = test_age';
opts = trainingOptions('sgdm', ...
    'MaxEpochs',1000, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'InitialLearnRate',1e-4, ...
    'Verbose',false,...
    'ValidationData',{XValidation,YValidation});

%network training
net = trainNetwork(trainf, train_age, Igraph, opts);

%network prediction (example), the input should be a 209 x 1 vector;
predict(net, features(1,:))

%%regression with bad results (didn't adapt)
%x = ones(30,210);
%x(:,2:210) = features;
%y = new_age;
%y = y';
%b = regress(y,x);
%error = x* b - y;