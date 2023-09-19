clc;
clear;
close all;
format compact;

dbstop if error;
dbstop if warning;

NodesList={'Arad';'Bucharest';'Craiova';'Dobreta';'Eforie';'Fagaras';'Giurgiu';'Hirsova';'Iasi';'Lugoj';'Mehadia';'Neamt';'Oradea';'Pitesti';'Rimnicu Vilcea';'Sibiu';'Timisoara';'Urziceni';'Vaslui';'Zerind'};
hList=[366;0;160;242;161;178;77;151;226;244;241;234;380;100;193;253;329;80;199;374];

LinksList={
    'Arad','Sibiu',140
    'Sibiu','Arad',140
    'Arad','Zerind',75
    'Zerind','Arad',75
    'Arad','Timisoara',118
    'Timisoara','Arad',118
    'Zerind','Oradea',71
    'Oradea','Zerind',71
    'Oradea','Sibiu',151
    'Sibiu','Oradea',151
    'Sibiu','Fagaras',99
    'Fagaras','Sibiu',99
    'Sibiu','Rimnicu Vilcea',80
    'Rimnicu Vilcea','Sibiu',80
    'Timisoara','Lugoj',111
    'Lugoj','Timisoara',111
    'Lugoj','Mehadia',70
    'Mehadia','Lugoj',70
    'Mehadia','Dobreta',75
    'Dobreta','Mehadia',75
    'Dobreta','Craiova',120
    'Craiova','Dobreta',120
    'Craiova','Rimnicu Vilcea',146
    'Rimnicu Vilcea','Craiova',146
    'Craiova','Pitesti',138
    'Pitesti','Craiova',138
    'Rimnicu Vilcea','Pitesti',97
    'Pitesti','Rimnicu Vilcea',97
    'Fagaras','Bucharest',211
    'Bucharest','Fagaras',211
    'Pitesti','Bucharest',101
    'Bucharest','Pitesti',101
    'Bucharets','Giurgiu',90
    'Giurgiu','Bucharest',90
    'Bucharest','Urziceni',85
    'Urziceni','Bucharest',85
    'Urziceni','Hirsova',98
    'Hirsova','Urziceni',98
    'Hirsova','Eforie',86
    'Eforei','Hirsova',86
    'Urziceni','Vaslui',142
    'Vaslui','Urziceni',142
    'Vaslui','Iasi',92
    'Iasi','Vaslui',92
    'Iasi','Neamt',87
    'Neamt','Iasi',87
    };

Start={'Arad'};
Goal=NodesList(hList==0);

OpenList={};
ClosedList={};

n=length(NodesList);
gList=zeros(n,1);
fList=Inf(n,1);
ParentList=repmat({''},n,1);

T=table(gList,fList,ParentList,'RowNames',NodesList,'VariableNames',{'g','f','parent'});

c=Start;

g=table2array(T(c,'g'));
f=g;
T(c,'f')=array2table(f);

disp('Frontier: ')
disp(['   '  cell2mat(c) '(' num2str(f) ',' '-' ')'])
disp('Selection: ')
disp(['   '  cell2mat(c)])

while ~ismember(Goal,c)
    AdjNodesG=LinksList(strcmp(LinksList(:,1),c),1:3);
    for i=1:size(AdjNodesG,1)
        v=AdjNodesG(i,2);
        if ~ismember(v,ClosedList)
            g_this=AdjNodesG{i,3};
            g_parent=table2array(T(c,'g'));
            g=g_parent+g_this;
            
            f=g;

            f_current=table2array(T(v,'f'));
            if f<f_current
                if ~ismember(v,OpenList)
                    OpenList=[OpenList,v];
                end
                T(v,'g')=array2table(g);
                T(v,'f')=array2table(f);
                T(v,'parent')=c;
            end
        end
    end

    ClosedList=[ClosedList,c];
    OpenList=setdiff(OpenList,c);
    [~,SortIdx]=sortrows(table2array(T(OpenList,{'f'})));
    c=OpenList(SortIdx(1));

    disp('                    ')
    
    disp('Frontier: ')

    for i=1:length(NodesList)
        v=NodesList(i);
        if ismember(v,OpenList)
            a=append('   ' , cell2mat(v) , '(', num2str(table2array(T(v,'f'))), ',', table2array(T(v,'parent')) , ')');
            disp(['' cell2mat(a)])
        end
    end

    disp('Selection: ') 
    disp(['   '  cell2mat(c)])

    OpenList;
    ClosedList;
    T;
    c;

end

disp('                    ')
disp('Finished!')
Path=c;
Cost=table2array(T(c,'f'));

while ~isempty(cell2mat(table2array(T(c,'parent'))))
    Path=[table2array(T(c,'parent')) ' -> ' Path];
    c=table2array(T(c,'parent'));
end

disp(['Path: ' cell2mat(Path)])
disp(['Cost: ' num2str(Cost)])


