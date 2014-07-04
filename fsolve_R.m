%==========================================================================
%
%   Calculating function value and gradient of 
%   the trained kernel radius function
%
%
%   June 12, 2008
%   Implemented by Daewon Lee, PhD
%   Dept. of Empirical Inference
%   MPI for Biological Cybernetics
%   WWW: http://www.kyb.mpg.de/~daewon
%==========================================================================


function [F,J]=fsolve_R(x,model)

d=size(x,2);
n=model.nsv;

q=1/(2*model.options.arg^2);
K=kernel(model.sv.X,x',model.options.ker,model.options.arg);    % NSV x 1
F=4*q*model.Alpha'*(repmat(K,1,d).*(repmat(x,n,1)-model.sv.X'));  % assuming a Gaussian kernel

if nargout>1
    const=model.Alpha.*K;   % nsv x 1
    J=[];
    for i=1:d
        J=[J -8*q^2*sum(repmat(const',d,1).*(repmat(x(i),d,n)-repmat(model.sv.X(i,:),d,1)).*(repmat(x',1,n)-model.sv.X),2)];
    end
    J=J+eye(d)*4*q*(model.Alpha'*K);
end



