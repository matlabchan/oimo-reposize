%MKGRID Create grid of points
%
% P = MKGRID(D, S, OPTIONS) is a set of points (3 x D^2) that define a DxD planar
% grid of points with side length S.  The points are the columns of P.
% If D is a 2-vector the grid is D(1)xD(2) points.  If S is a 2-vector the 
% side lengths are S(1)xS(2).
%
% By default the grid lies in the XY plane, symmetric about the origin.
%
% Options::
% 'pose',T   The pose of the grid coordinate frame is defined by the homogeneous transform T,
%            allowing all points in the plane to be translated or rotated.


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function p = mkgrid(N, s, varargin)
    
    opt.pose = [];

    [opt,args] = tb_optparse(opt, varargin);
    
    if ~isempty(args) && ishomog(args{1})
        % compatible with legacy call
        opt.pose = args{1};
    end
    if length(s) == 1
        sx = s; sy = s;
    else
        sx = s(1); sy = s(2);
    end

    if length(N) == 1
        nx = N; ny = N;
    else
        nx = N(1); ny = N(2);
    end


    if N == 2
        % special case, we want the points in specific order
        p = [-sx -sy 0
             -sx  sy 0
              sx  sy 0
              sx -sy 0]'/2;
    else
        [X, Y] = meshgrid(1:nx, 1:ny);
        X = ( (X-1) / (nx-1) - 0.5 ) * sx;
        Y = ( (Y-1) / (ny-1) - 0.5 ) * sy;
        Z = zeros(size(X));
        p = [X(:) Y(:) Z(:)]';
    end
    
    % optionally transform the points
    if ~isempty(opt.pose)
        % WJ: this call was stripping the translation p = SE3.check(opt.pose) * p;
        p = opt.pose * p;
    end
