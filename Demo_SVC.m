%==========================================================================
%   SVC demo script
%   
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

clear all;
clc;

load ring.mat;
data.X=input';   % data.X: p x N input patterns

options=struct('method','CG','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

options=struct('method','DD','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

options=struct('method','MST','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

options=struct('method','KNN','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

options=struct('method','SEP-CG','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

options=struct('method','E-SVC','ker','rbf','arg',0.5,'C',0.1);
[model]=svc(data,options); 
plotsvc(data,model);

