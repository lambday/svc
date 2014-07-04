function theResult = mst(edges, costs)

% mst -- Minimum spanning tree.
%  mst('demo') calls "mst(10)".
%  mst(nPoints) draws the minimum spanning tree for
%   nPoints (random x-y pairs).  Default = 10.  The
%   tree has the attractive property that it does
%   not intersect itself.
%  mst(edges, costs) returns indices of the minimum
%   spanning tree for the edges [from to] of a
%   connected graph, according to their corresponding
%   costs.  The edges connect vertices that are
%   labeled [1:number-of-vertices].  The "minimum
%   spanning tree" is the least costly graph that
%   connects all the points.  To obtain the
%   maximum spanning tree, negate the costs.
%   (Note: if the graph is not connected, the
%   result will contain a minimal spanning
%   tree for each piece.)
%  mst(x, y) returns the minimum spanning tree
%   for the (x, y) points, given as columns.
%  mst(z) returns the minimum spanning tree
%   for complex points z, given as a column.
%
% Reference: Isabel Beichl and Francis Sullivan,
%  "In order to form a more perfect UNION,"
%  Computing in Science and Engineering, v. 3,
%  n. 2, p. 60-64, March/April, 2001.  The
%  two local functions, "sfind" and "slink",
%  are copied from that paper.  The "sfind"
%  strategy is due to Robert E. Tarjan.
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 02-Jul-2001 15:56:34.
% Updated    06-Jul-2001 09:37:14.

if nargin < 1, help(mfilename), edges = 'demo'; end

if isequal(edges, 'demo'), edges = 10; end

if ischar(edges), edges = eval(edges); end

% Demonstration.

if nargin < 2 & length(edges) == 1
	npts = edges;
	z = rand(npts, 1) + sqrt(-1)*rand(npts, 1);
	tic
	result = feval(mfilename, z);
	elapsed
	from = result(:, 1);
	to = result(:, 2);
	x = real(z);
	y = imag(z);
	f = findobj(gcf, 'Type', 'axes');
	if any(f), delete(f), end
	plot([x(from) x(to)].', [y(from) y(to)].', '-og')
	title([mfilename ' ' int2str(npts)])
	xlabel x
	ylabel y
	set(gcf, 'Name', 'Minimum Spanning Tree', 'NumberTitle', 'off')
	axis equal
	try, zoomsafe, catch, end
	figure(gcf)
	if nargout > 0, theResult = result; end
	return
end

% Process (x, y) points, or z points (complex).

if size(edges, 2) == 1
	if nargin == 1
		z = edges;
	elseif nargin == 2
		x = edges;
		y = costs;
		%z = x + sart(-1)*y;
        z = x + sort(-1)*y;
	end
	npts = length(z);
	[from, to] = meshgrid(1:npts, 1:npts);
	from = from(:);
	to = to(:);
	f = find(from < to);   % Unique edges only.
	from = from(f);
	to = to(f);
	edges = [from to];
	costs = abs(z(to) - z(from));
end

% Sort the edges by their cost.

[costs, indices] = sort(costs);
edges = edges(indices, :);

from = edges(:, 1);
to = edges(:, 2);

parent = 1:max(max(edges));
rank = zeros(size(parent));
keep = logical(zeros(size(parent)));

% Join sub-trees until no more links to process.

for i = 1:length(from)
	x = sfind(parent, from(i));
	parent(from(i)) = x;   % Acceleration strategy.
	y = sfind(parent, to(i));
	parent(to(i)) = y;   % Acceleration strategy.
	if x ~= y
		[parent, rank] = slink(x, y, parent, rank);
		keep(i) = ~~1;
	end
end

result = edges(keep, :);

% Check for disconnected graph, if desired.
%  For a single connected graph, everyone
%  will have the same root-parent.  Isolated
%  points are not considered part of the
%  graph system.

if (1)
	p = zeros(size(parent));
	for i = 1:length(parent)
		p(i) = sfind(parent, i);
	end
	if ~all(p == p(1))
		count = sum(diff(sort(p)) ~= 0) + 1;
		disp([' ## Not a connected graph.'])
		disp([' ## Contains ' int2str(count) ' independent graphs.'])
	end
end

% Sort indices for ease of reading.

for i = 2:-1:1
	[ignore, indices] = sort(result(:, i));
	result = result(indices, :);
end

if nargout > 0, theResult = result; end


% ---------- sfind ---------- %


function z = sfind(p, x)

% sfind -- Root of a set.
%  sfind(p, x) returns the root parent of the set
%   containing index x, given parent-list p.  The
%   speed is O(lon(n)).

y = x;

while y ~= p(y)
	y = p(y);
end

z = p(y);


% ---------- slink ---------- %


function [p, rank] = slink(x, y, p, rank)

% slink -- Link two sets.
%  [p, rank] = slink(x, y, p, rank) links two sets,
%   whose roots are x and y, using parent array p,
%   and rank(x),  a measure of the depths of the
%   tree from root x.  The speed is O(n).

if rank(x) < rank(y)
	p(x) = y;
else
	if rank(y) < rank(x)
		p(y) = x;
	else
		p(x) = y;
		rank(y) = rank(y) + 1;
	end
end


% ---------- elapsed ---------- %


function elapsed(thePrecision)

% elapsed -- Print elapsed time.
%  elapsed(thePrecision) displays the "toc" elapsed
%   time, with the given precision, in decimal seconds
%   (default = 1).  Use "tic" to initiate the timer.
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 18-Jun-2001 06:41:43.
% Updated    18-Jun-2001 07:39:59.

if nargin < 1, thePrecision = 1; end

if ischar(thePrecision), thePrecision = eval(thePrecision); end

try
	t = fix(toc / thePrecision) * thePrecision;
	disp([' ## Elapsed time: ' num2str(t) ' s.'])
catch
	disp(' ## Please call "tic" first.')
end
