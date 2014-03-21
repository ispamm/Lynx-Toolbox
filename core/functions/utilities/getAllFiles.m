
% GETALLFILES

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function fileList = getAllFiles(dirName)

  dirData = dir(dirName);      
  dirIndex = [dirData.isdir];  
  fileList = {dirData(~dirIndex).name}';  
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  
  validIndex = ~ismember(subDirs,{'.','..'}); 
                                              
  for iDir = find(validIndex)                 
    nextDir = fullfile(dirName,subDirs{iDir});    
    fileList = [fileList; getAllFiles(nextDir)];  
  end

end