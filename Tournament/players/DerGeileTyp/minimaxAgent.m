function [ move ] = minimaxAgent( b, color, depth, w)
% Berechnet den move eines Minimax Agenten
% TODO: NOCH NICHT FERTIG 

    Node = struct('Parent',{},'Children',{} ,'isLeafe', {}, ...
                  'hVal', {}, 'move', {}, 'b_tmp', {},'Visited', {},...
                  'turn',{},'depth',{});
              
    Layer = struct('Nodes', {}, 'Type', {});
    
    flag = true;
    
    opponent = color*-1;
   
    possibleMoves = allPossible(b,color);
    
    if ~isempty(possibleMoves)
        
        % Node 1 bescheibt aktuellen Zustand
        Node(1).Children = allPossible(b,color);
        Node(1).nChildren = length(Node(1).Children);
        Node(1).Parent = 0;
        Node(1).b_tmp = b;
        Node(1).turn = color;
        Node(1).depth = 1;
        Node(1).Visited = false;
        
        Layer(1).Nodes = Node(1);
        Layer(1).Type = 'max';
        
        reps = 1;
        
        while (flag)
            
            if ~(Node(reps).Visited) % und kein Leaf ist
                selectedNode = Node(reps);
                Node(reps).Visited = true;
            end
            
            for idx =1:length(selectedNode.Children)
                
                nNodes = length(Node)+1;
                
                Node(nNodes).Parent = selectedNode;
                Node(nNodes).turn = -1*selectedNode.turn;
                Node(nNodes).b_tmp = simulateMove(selectedNode.b_tmp,selectedNode.turn,selectedNode.Children(idx));
                Node(nNodes).Children = allPossible(Node(nNodes).b_tmp,Node(nNodes).turn);
                Node(nNodes).Visited = false;
                Node(nNodes).move = selectedNode.Children(idx);
                Node(nNodes).depth = selectedNode.depth + 1;
                if Node(nNodes).depth == depth
                    Node(nNodes).isLeaf = true;
                end
               % TODO hVal und ParentID

            end
            
            
            % Stop wen alle visited oder leaf sind
            

            reps = reps + 1;
        end

    else
        move = [];
    end

end





























%         % Initialisierung der Ersten Node
%         Node(1).b_tmp = b;
%         Node(1).Children = possibleMoves;
%         Node(1).move = 0;
%         Layer(1,1).Nodes = Node(1);
%         Layer(1,1).Type = 'max';
% 
%         for idx = 1:depth
%             for jdx = 1:length(Layer(idx).Nodes)                    %Layer
%                     if logical(mod(idx,2))  % Ungerade Tiefe
%                         turn = color;
%                         noturn = opponent;
%                         type = 'max';
%                     else
%                         turn = opponent;    % Gerade Tiefe
%                         noturn = color;
%                         type = 'min';
%                     end
%                 for kdx=1:length(Layer(idx,jdx).Nodes(jdx).Children)    %Node
%                     
%                     
%                     
%                     node = Layer(idx,jdx).Nodes(jdx).Children(kdx);
%                     
%                     
%                     
%                     
%                     
%                     
%                     
%                     
%                     
% 
%                     % TODO: add hVal
%                     node = Layer(idx).Nodes(jdx).Children(kdx);     % Move der zugehörigen Node
%                     b_tmp = simulateMove(Layer(idx).Nodes(jdx).b_tmp,turn,node);
%                     possibleMoves = allPossible(b_tmp,noturn);
%                     
%                     nNodes = length(Node)+1;
%                     
%                     Node(nNodes).Parent = Layer(idx).Nodes(jdx).move;
%                     Node(nNodes).Children = possibleMoves;
%                     Node(nNodes).move = node;
%                     Node(nNodes).b_tmp = b_tmp;
%                 end
%                 Layer(idx+1,jdx).Nodes = Node(end-length(Layer(idx).Nodes(jdx).Children)+1:end);
%                 Layer(idx+1,jdx).Type = type;
%                         
%             end     
%         end
