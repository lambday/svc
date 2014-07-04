%==========================================================================
%
%   Calculating function value and gradient of 
%   the trained kernel radius function
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

function [f,g,H]=my_R(x,model)

d=size(x,2);
n=model.nsv;
[f] = kdist2(x', model);     % x: 1 x dim

q=1/(2*model.options.arg^2);
if nargout>1
    K=kernel(model.sv.X,x',model.options.ker,model.options.arg);    % NSV x 1
    g=4*q*model.Alpha'*(repmat(K,1,d).*(repmat(x,n,1)-model.sv.X'));  % assuming a Gaussian kernel
end

if nargout>2
    const=model.Alpha.*K;   % nsv x 1
    H=[];
    for i=1:d
        H=[H -8*q^2*sum(repmat(const',d,1).*(repmat(x(i),d,n)-repmat(model.sv.X(i,:),d,1)).*(repmat(x',1,n)-model.sv.X),2)];
    end
    H=H+eye(d)*4*q*(model.Alpha'*K);
end


