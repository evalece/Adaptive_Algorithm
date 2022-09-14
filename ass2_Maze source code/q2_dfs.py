
import sys
sys.setrecursionlimit(500000000)
# This is a 2D list in Python. (Given resource)
# '1' indicates that the node is blocked, '0' indicates that it is free

maze = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0]]

#using linked list node [][] to back track solution path
class Nodes:

    def __init__( self, parent_x, parent_y, node_x, node_y):
        self.parent_x=parent_x #parent's position
        self.parent_y=parent_y

        self.posx= node_x #its own position
        self.posy= node_y


class Nodebfs: 
        
    fifo_que = []
    close_que = []
    back_track= []

    sol_path=[] #the solution path, conditonally exisitance (i.e. if goal and start node are reachable)
  
    def __init__(self, s_x, s_y, e_x, e_y): #initialization: create queue, start and goal node
           # holding deque x and y point, for expand dequeue function loop
        self.current_x =s_x #initially -1
        self.current_y =s_y
        self.s_x= s_x #starting node, x position
        self.s_y= s_y #starting node, y position
        self.e_x= e_x #ending node, x position
        self.e_y= e_y #ending node, y position
        fifo_que=[] # empy the fifo queue array, array of selected maze node
        close_que=[] #closing queue for tracking, array of selected maze node
        back_track= [] 


################### Maze moving functions ################
       # print ("expand",x_po,y_po)  
        # rule of expansion: maze!= 1
        # rule of enqueue: maze!= 2, maze!=1   
        # when needing to assign maze =2, means need to assign parent 
        # assume repeated node (nodes that are on open or closed list) are not expanded again
    #moveing current maze up a position, append and back track accordingly
    def up_m (self, x_po, y_po):
        if maze[x_po+1][y_po]!= 1:
            if maze[x_po+1][y_po]!= 2: #this node has been added to open list but not yet expanded, first node that
                #expanded this child node becomes the parent and, thus the solution parent in back tracking
                # thus, adding back track info for back tracking solution path once the goal node is found.
                self.back_track.append(Nodes(x_po,y_po,x_po+1,y_po))
                #print( "maze[x_po+1][y_po]=",x_po+1,y_po)
                maze[x_po+1][y_po]= 2 
                self.fifo_que.insert(0,[x_po+1,y_po])  
    
    def down_m (self, x_po, y_po):
        if maze[x_po-1][y_po]!= 1:
            if maze[x_po-1][y_po]!= 2: #this node has been added to open list but not yet expanded
                #adding back track info 
                self.back_track.append(Nodes(x_po,y_po,x_po-1,y_po))
                #print( "maze[x_po-1][y_po]=",x_po-1,y_po)
                maze[x_po-1][y_po]= 2 
                self.fifo_que.insert(0,[x_po-1,y_po])  

    def right_m (self, x_po, y_po):
        if(maze[x_po][y_po+1]!=1):
            if (maze[x_po][y_po+1]!= 2):
                #adding back track info 
                self.back_track.append(Nodes(x_po,y_po,x_po,y_po+1))
               # print( "maze[x_po][y_po+1]=",x_po,y_po+1)
                maze[x_po][y_po+1]= 2
                self.fifo_que.insert(0,[x_po,y_po+1]) 
    
    def left_m (self, x_po, y_po):
        if maze[x_po][y_po-1]!=1:
                if(maze[x_po][y_po-1]!=2): 
                  #  print( "maze[x_po][y_po-1]=",x_po,y_po-1)
                    maze[x_po][y_po-1]= 2 
                    #adding back track info 
                    self.back_track.append(Nodes(x_po,y_po,x_po,y_po-1))
                    self.fifo_que.insert(0,[x_po,y_po-1]) 
###################End of Maze moving functions ################

    #this function checks the current x,y postion to determine the movement (up, down, left right) to make 
    def expand_enqueue(self, x_pos, y_pos): 


        x_po=x_pos
        y_po=y_pos


        if maze[x_pos][y_pos]!=1: #reachable
            #if maze[x_pos][y_pos]!=2: #not yet been explored
            self.close_que.append((x_pos,y_pos)) #keep track on closed nodes

            if(y_po>0):
                self.left_m(x_po,y_po)
            if(x_po>0):
                self.down_m(x_po,y_po)
            if(x_po<24):
                self.up_m(x_po,y_po)
            if(y_po<24):
                self.right_m(x_po,y_po)

    
    #breath first search iterationç
    def bfs_search(self): 
       
        # print ("found",self.e_x,self.e_y)
          
         while(self.current_x!=self.e_x)| (self.current_y!=self.e_y): # if current x and y not goal node
             #continue search
           # if (len(self.fifo_que)!=0):
            self.expand_enqueue(self.current_x,self.current_y)
            if(len(self.fifo_que)>0):
                self.current_x= self.fifo_que[0][0]
                self.current_y= self.fifo_que[0][1]
                #pop front
                self.fifo_que.pop(0)

    # back tracking to return solution path O(n), linear search on parent node, input: goal and start nodes
    def back_tracker(self, s_x, s_y, cu_x, cu_y):  #cu_x and cu_y are current a and y during back tracking
    #linear search loop, store parent on sol_path[], using e_x e_y as current and start node, s_x and s_y be ending node
        if(cu_x !=s_x) | (cu_y!=s_y):
            #not reaching ending yet, continue linear search
            len_loop = range(len(self.back_track))
            for i in len_loop:
                if(self.back_track[i].posx==cu_x) & (self.back_track[i].posy ==cu_y): # found its tracking record
                    #their parent node bceome one of the solution path 
                    self.sol_path.insert(0,[self.back_track[i].posx,self.back_track[i].posy])
                    #setting next loop
                    self.back_tracker(s_x, s_y,self.back_track[i].parent_x, self.back_track[i].parent_y)
        else: # assume reaching starting node
            self.sol_path.insert(0,[s_x,s_y])
                           
       
#print ("maze24",maze[24][24])


###### hard coding start and goal node here
x_start= 0
y_start= 0
x_goal= 24
y_goal= 24


######
if(maze[x_start][y_start]!=1):
    bfs1 =Nodebfs(x_start,y_start,x_goal,y_goal) #place start and end node
    bfs1.expand_enqueue(x_start, y_start) #place start node
    if(maze[bfs1.e_x][bfs1.e_y]!=1): #goal is reachable
        bfs1.bfs_search() # call search iteration
        bfs1.back_tracker(x_start,y_start,x_goal,y_goal)
        print("path:", bfs1.sol_path)

    else: 
        print("goal not reachable")
    print("cost= ",len(bfs1.sol_path))
    print("number of nodes explore= ", len(bfs1.close_que)) 
    #print(" nodes explore= ", bfs1.close_que)
else: 
     print("start node not reachable")

