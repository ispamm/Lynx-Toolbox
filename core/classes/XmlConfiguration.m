% XmlConfiguration - Handle the xml configuration
%   XmlConfiguration is used to handle the xml configuration of the
%   toolbox. To create the configuration file:
%
%   XmlConfiguration.createXmlConfiguration(root_folder), where
%   root_folder is the root folder of the toolbox.
%
%   To access a property denoted by 'field':
%
%   XmlConfiguration.readConfigValue(field);

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef XmlConfiguration
    
    properties
    end
    
    methods(Static)
        function createXmlConfiguration(root_folder)
            % Create the Xml configuration file
            docNode = com.mathworks.xml.XMLUtils.createDocument('config');
            XmlConfiguration.addChild(docNode, docNode.getDocumentElement, 'version', '0.7');
            XmlConfiguration.addChild(docNode, docNode.getDocumentElement, 'root_folder', root_folder);
            XmlConfiguration.addChild(docNode, docNode.getDocumentElement, 'libraries', '');
            xmlwrite(fullfile(root_folder, 'config.xml'), docNode);
        end
        
        function value = readConfigValue(field)
            % Read a value from the configuration file
            xDoc = xmlread('config.xml');
            xRoot = xDoc.getDocumentElement.getChildNodes;
            try
                value = char(xRoot.getElementsByTagName(field).item(0).getTextContent);
            catch
                value = [];
            end
        end
        
        function value = setConfigValue(field, value, fold)
            % Add a value to the configuration file
            if(nargin < 3)
                fold = XmlConfiguration.getRoot();
            end
            xDoc = xmlread(fullfile(fold, 'config.xml'));
            XmlConfiguration.addChild(xDoc, xDoc.getDocumentElement, field, value);
            xmlwrite(fullfile(fold, 'config.xml'), xDoc);
            XmlConfiguration.xmlRemoveExtraLines(fullfile(fold, 'config.xml')),
        end
        
        function r = getRoot()
            % Utility function for retrieving the root folder of the
            % toolbox
            r = XmlConfiguration.readConfigValue('root_folder');
        end
        
        function b = checkForConfigurationFile(root_folder)
            % Check if the configuration file exists
            b = (exist(fullfile(root_folder, 'config.xml'), 'file') == 2);
        end
        
        function found = checkForInstalledLibrary(lib_id)
            % Check that a library is installed
            xDoc = xmlread('config.xml');
            xRoot = xDoc.getDocumentElement.getChildNodes;
            value = xRoot.getElementsByTagName('libraries').item(0).getChildNodes.getElementsByTagName('id');
            found = false;
            for ii = 0:value.getLength-1
                id = char(value.item(ii).getTextContent);
                found = found | strcmpi(lib_id, id);
            end
        end
        
        function addLibrary(id, name, url, folder)
            % Add an installed library
            configFile_url = fullfile(XmlConfiguration.readConfigValue('root_folder'), 'config.xml');
            xDoc = xmlread(configFile_url);
            xRoot = xDoc.getDocumentElement.getChildNodes;
            value = xRoot.getElementsByTagName('libraries').item(0);
            
            curr_node = xDoc.createElement('library');
            XmlConfiguration.addChild(xDoc, curr_node, 'id', id);
            XmlConfiguration.addChild(xDoc, curr_node, 'name', name);
            XmlConfiguration.addChild(xDoc, curr_node, 'download_url', url);
            XmlConfiguration.addChild(xDoc, curr_node, 'folder', folder);
            
            value.appendChild(curr_node);
            
            xmlwrite(configFile_url, xDoc);
            XmlConfiguration.xmlRemoveExtraLines(configFile_url);
        end
        
        function xmlRemoveExtraLines(filePath)
            % Solves a bug in the current Xml reader of Matlab, see:
            % http://www.mathworks.com/matlabcentral/answers/94189-why-does-xmlread-introduce-extra-whitespace-into-my-xml-file
            % Read file.
            fId = fopen(filePath, 'r');
            fileContents = fread(fId, '*char')';
            fclose(fId);
            % Write new file.
            fId = fopen(filePath, 'w');
            % Remove extra lines.
            fwrite(fId, regexprep(fileContents, '\n\s*\n', '\n'));
            fclose(fId);
        end
    end
    
    methods(Static, Access=private)
        function addChild(docNode, node, param, value)
            % Add a child to the given node
            tmp = node.getElementsByTagName(param);
            if((tmp.getLength > 0))
                node.removeChild(tmp.item(0));
            end
            curr_node = docNode.createElement(param);
            curr_node.appendChild(docNode.createTextNode(value));
            node.appendChild(curr_node);
        end
    end
    
end

