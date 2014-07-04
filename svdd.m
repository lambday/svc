function model = svdd(X,options)
% SVDD Minimal enclosing ball in kernel feature space. 
%
%  Dual of SVDD model
%  min 0.5*x'(2*K)x - x'*diag(K)
%  s.t. 0<=x<=options.C
%
%  Support vector: 0<x<options.C
%  Bounded support vector: x=options.C 
%
%
% Synopsis:
%  model = svdd(X)
%  model = svdd(X,options)
%  (Test)
%  squaredR=kdist2(testX,model)
%
%
% Description:
%  It computes center and radius of the minimal sphere
%  enclosing data X mapped into a feature space induced 
%  by a given kernel. The problem leads to a special instance 
%  of the Quadratic Programming task which is solved by the 
%  QPSSVM solver (see 'help qpssvm').
%
% Input:
%  X [dim x num_data] Input data.
%  options [struct] Control parameters:
%   .ker [string] Kernel identifier (default 'linear'). See 'help kernel'.
%   .arg [1 x nargs] Kernel arguments.
%   .C [1x1] Regularization constant (default, C=1); 
%    If C = 0 (or C=1, default), it is hard margin, that is, 
%       the model do not allow the bounded support vectors
%
% Output:
%  model [struct] Center of the ball in the kernel feature space:
%   .sv.X [dim x nsv] Data determining the center. (SV + BSV)
%   .Alpha [nsv x 1] Data weights. (SV + BSV)
%   .r [1x1] squared radius of the minimal enclosing ball. i.e. R^2
%   .b [1x1] Squared norm of the center equal to Alpha'*K*Alpha.
%   .sv_ind [nsv2 x 1] index of corresponding SV among X
%   .bsv_ind [nbsv x 1] index of corresponding BSV among X
%   .inside_ind [num_data-nbsv x 1] index of point inside the sphere
%   .options [struct] Copy of used options.
%   .stat [struct] Statistics about optimization:
%     .access [1x1] Number of requested columns of matrix H.
%     .t [1x1] Number of iterations.
%     .UB [1x1] Upper bound on the optimal value of criterion. 
%     .LB [1x1] Lower bound on the optimal value of criterion. 
%     .LB_History [1x(t+1)] LB with respect to iteration.
%     .UB_History [1x(t+1)] UB with respect to iteration.
%     .NA [1x1] Number of non-zero entries in solution.
%
% Example:
%  data = load('riply_trn');
%  options = struct('ker','rbf','arg',0.4,'C',0.1);
%  model = svdd(data.X,options);
%  [Ax,Ay] = meshgrid(linspace(-5,5,100),linspace(-5,5,100));
%  dist = kdist2([Ax(:)';Ay(:)'],model);
%  figure; hold on; 
%  ppatterns(data.X); 
%  ppatterns(data.X(:,model.sv_ind),'ro',12);   % plot SV
%  ppatterns(data.X(:,model.bsv_ind),'bo',12);  % plot BSV
%  contour( Ax, Ay, reshape(dist,100,100),[model.r model.r]);
%  legend('Points','SVs','BSV (outliers)','Location','SouthEast');
%
%==========================================================================
% January 13, 2009
% Implemented by Daewon Lee
% WWW: http://sites.google.com/site/daewonlee/
%==========================================================================

% process input arguments
%-----------------------------------------
if nargin < 2, options = []; else options=c2s(options); end
if ~isfield(options,'ker'), options.ker = 'rbf'; end
if ~isfield(options,'arg'), options.arg = 1; end
if ~isfield(options,'solver'), options.solver = 'imdm'; end
if ~isfield(options,'C'), options.C = 1; end  % do not allow BSVs (bounded SVs)


[dim,num_data] = size(X);

% set up QP problem
%-----------------------------------------

K = kernel( X, options.ker, options.arg );
f = -diag(K);
H=2*K;
b=options.C;
I=[1:1:num_data]';
[Alpha,fval,stat] = qpssvm(H,f,b,I);

inx= find(Alpha > 0);
model.Alpha = Alpha(inx);
model.sv_ind=find(Alpha > 0&Alpha < options.C-10^(-7));
model.bsv_ind=find(Alpha >= options.C-10^(-7));
model.inside_ind=find(Alpha < options.C-10^(-7));
model.b = Alpha(inx)'*K(inx,inx)*Alpha(inx);

% setup model
%---------------------
model.sv.X= X(:,inx);   % including both of SV and BSV (bounded support vectors)
model.sv.inx = inx;
model.nsv = length(inx);
model.options=options;
model.stat = stat;
model.fun = 'kdist2';
model.r = max(kdist2(X(:,model.sv_ind),model));

return;
% EOF

