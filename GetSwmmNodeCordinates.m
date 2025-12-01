function coordinates = GetSwmmNodeCordinates(inpFile)
%GETSWMMNODECOORDINATES Parse node coordinate data from a SWMM input file.
%   coordinates = GETSWMMNODECOORDINATES(inpFile) reads the [COORDINATES]
%   section of the provided SWMM .inp file and returns a cell array with one
%   row per node: {nodeName, xCoordinate, yCoordinate}. Coordinates are
%   returned in the same units as the input file.
%
%   Inputs
%       inpFile - Path to a SWMM .inp file containing a [COORDINATES] block.
%
%   Outputs
%       coordinates - Cell array of node names and their X/Y coordinates.

    % Open the input file and move the cursor to the [COORDINATES] section.
    fileId = fopen(inpFile, 'r');
    currentLine = fgetl(fileId);
    isCoordinatesSection = false;
    while ischar(currentLine) && ~isCoordinatesSection
        if strcmp(currentLine, '[COORDINATES]')
            isCoordinatesSection = true;
        else
            currentLine = fgetl(fileId);
        end
    end

    % Read coordinate lines until the section terminates with a blank line.
    coordinates = {};
    currentLine = fgetl(fileId);
    while ischar(currentLine) && ~isempty(currentLine)
        if currentLine(1) ~= ';'   % Skip comment rows that start with ';'
            tokens = strsplit(strtrim(currentLine));
            nextIndex = size(coordinates, 1) + 1;
            coordinates{nextIndex, 1} = tokens{1};
            coordinates{nextIndex, 2} = str2double(tokens{2});
            coordinates{nextIndex, 3} = str2double(tokens{3});
        end
        currentLine = fgetl(fileId);
    end

    fclose(fileId);
end

