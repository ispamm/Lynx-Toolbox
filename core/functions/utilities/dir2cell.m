function [names, datenums, dates, bytes, isdirs] = dir2cell(arg)

%DIR2CELL Converts directory listing into a cell array.
%   NAMES = DIR2CELL converts the directory listing into a cell array in
%   alphabetical order.
%
%   NAMES = DIR2CELL(ARG) converts the directory listing based on argument
%   ARG, into a cell array in alphabetical order.  ARG may contain
%   wildcards.
%
%   [NAMES, DATENUMS, DATES, BYTES, ISDIRS] = DIR2CELL(ARG), also returns
%   the modification date as a MATLAB serial date number in double array
%   DATENUMS, the modification date in cell array DATES, the number of
%   bytes in double array BYTES, and a Boolean variable designating if is a
%   directory or not in logical array ISDIRS.
%
%   Example
%   -------
%       files = dir2cell('*.m');
%
%   See also DIR2STR, DIR, SORT, STRVCAT.
%
%   Version 1.3 - Kevin Crosby

% DATE      VER  NAME          DESCRIPTION
% 12-08-99  1.0  K. Crosby     First Release
% 05-18-07  1.1  K. Crosby     Adjusted for empty lists.
% 02-13-08  1.2  K. Crosby     Return more fields from DIR struct.
% 08-10-10  1.3  K. Crosby     Eliminated CELL2MAT references for speed.

% Contact: Kevin.L.Crosby@gmail.com


if ~exist('arg', 'var') || isempty(arg)
  d = dir;
else % if exist('arg', 'var') && ~isempty(arg)
  d = dir(arg);
end % if ~exist('arg', 'var') || isempty(arg)

if isempty(d)
  [names, dates] = deal({}); % make size equal 0
  [datenums, bytes, isdirs] = deal([]);
else % if ~isempty(d)
  names = {d.name}';
  datenums = [d.datenum]';
  dates = {d.date}';
  bytes = [d.bytes]';
  isdirs = [d.isdir]';
end % if isempty(d)  
