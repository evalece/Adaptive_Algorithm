classdef pso < handle
    %PSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%%%%    user input,    %%%% 

        %termination condition:
        max_t= 100; % max iteration

         % swarm population :
          
         swarm_num= 30;

         % problem: 

% z= (4-2.1.*x.^2+(x.^4)./3).*x.^2+x.*y+(-4+4.*y.^2).*y.^2

          %  range of 2d grid; assume problem space is 2D square; i.e,
          %  xmax=ymax, xmin=ymin
        xmax= 2; 
        xmin= -2;
        ymax= 2;
        ymin= -2;

        c1=1; % c1= c2 uausally 
        c2=1; 
        w=1; % convergence rule: 2w -c +2>0
    

%%%%           end of user define input             %%%% 
     
        digitsOld;
        r1;
        r2;
        
%%%%         data storage       %%%%
        swarm % each swarm holds position, velocity, pbest, nbest
    % structure:[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10)]
        %bests % matrix storiing all nbests and their x,y. column= max iternation
fitness % first row: average, second row, best of all so far, column num= iternation

    end
    
    methods(Static)

        

        function init(obj) % precisions etc
            obj.digitsOld = digits(8); % 8 decimal num

           %obj.bests= zeros(3,obj.max_t);

        end

        % precisions etc
        function destrutor_(obj) 
            digits(obj.digitsOld)

        end

        % initialize swarm population
        function init_swarm(obj) 

            obj.fitness=zeros(2,obj.max_t);


          % assume problem space is 2D square  
          % structure:[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10) xv+1(11) yv+1(12) xp+1(13) yp+1(14)]
            init_po= vpa(obj.xmax+(obj.xmin-obj.xmax).*rand(2,obj.swarm_num)); %initial position
            init_v= zeros(2, obj.swarm_num); % initial velocity set to zero

            rest= zeros(9,obj.swarm_num);
            obj.swarm= [vpa(init_po); init_v;init_v;rest]; 

            %filling Pbest using initial points 
            for i= 1: obj.swarm_num
              obj.swarm(5,i)=  obj.formula_(obj.swarm(1,i),obj.swarm(2,i));             

              %Nbest = pbest for now 
              obj.swarm(6,i)=obj.swarm(5,i);
              obj.swarm(7,i)=obj.swarm(1,i);
              obj.swarm(8,i)=obj.swarm(2,i);

            end

        end


        % problem equation 
        function solution =formula_(x, y) 

            solution= ((4-2.1.*x.^2+(x.^4)./3).*x.^2+x.*y+(-4+4.*y.^2).*y.^2); % vpa to increase decimal places 

        end 

        function r1_r2_gen(obj) %generation of c1 and c2, simple and linear differs here

            %r1 r2 E (0,1)
            obj.r1=randi(100)/100; %two decimal precison
            obj.r2=randi(100)/100; %two decimal precison

        end


         % structure:[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10) xv+1(11) yv+1(12) xp+1(13) yp+1(14)]
         function next_v(obj, p) % next velocity, called after c1 c2 generation each iteration
            % x compnent: 
          obj.swarm(11,p)= vpa(obj.w.* obj.swarm(11,p)+ obj.c1.*obj.r1.*(obj.swarm(9,p)-obj.swarm(1,p))+ obj.c2.*obj.r2.*(obj.swarm(7,p)-obj.swarm(1,p)));
             % y compnent: 
          obj.swarm(12,p)= vpa(obj.w.* obj.swarm(11,p)+ obj.c1.*obj.r1.*(obj.swarm(10,p)-obj.swarm(2,p))+ obj.c2.*obj.r2.*(obj.swarm(8,p)-obj.swarm(2,p)));

       end


       function next_pos(obj, p) %next position, usually called after next_v.
               % x component 
            obj.swarm(13,p)= vpa(obj.swarm(1,p)+obj.swarm(11,p));

               % y component 
            obj.swarm(14,p)= vpa(obj.swarm(2,p)+obj.swarm(12,p));

       end 

       function  next_pos_ass(obj, p) % position t = position t+1  v t= v t+1

            obj.swarm(1,p)= vpa(obj.swarm(13,p));
            obj.swarm(2,p)= vpa(obj.swarm(14,p));

            obj.swarm(3,p)= vpa(obj.swarm(11,p));
            obj.swarm(4,p)= vpa(obj.swarm(12,p));


       end

       %[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10) xv+1(11) yv+1(12) xp+1(13) yp+1(14)]
       function use_formula(obj, p) % new position get, now evaluate z and update pbest

           temp_sol=obj.formula_(obj.swarm(1,p),obj.swarm(2,p));
           %check if pbest
           if temp_sol <= obj.swarm(5,p)
              obj.swarm(9,p) =obj.swarm(1,p);
              obj.swarm(10,p) =obj.swarm(2,p);

              obj.swarm(5,p)= temp_sol; %update pbest

              %if pbest is updated, check nbest
              if obj.swarm(10,p)<= obj.swarm(6,p)
                  obj.swarm(6,p)= obj.swarm(10,p); % update nbest with pbest
                  obj.swarm(7,p)= obj.swarm(9,p);
                  obj.swarm(6,p)= obj.swarm(5,p);

              end
           end
       end 

        
        % compare nbest in ring buffer, (making column num a ring)
        function compare_neibour(obj,p) %p= paticle, one column per particle in swarm=[] 
            p1=0;
            p2=0;
            % swarm: [xp yp xv yv pbest nbest]
            if p==obj.swarm_num
                % compare 1 and obj.swarm_num-1
                p1= 1;
                p2= obj.swarm_num-1;
            elseif p==1
                p1=2;
                p2= obj.swarm_num;
            else 
                p1=p-1;
                p2=p+1;
            end 
                if obj.swarm(6,p1)<= obj.swarm(6,p)
                    if obj.swarm(6,p1)<= obj.swarm(6,p2)
                                obj.copy_nbest(obj,p2,p1);
                                obj.copy_nbest(obj,p,p1);                          
                    else % obj.swarm(5,obj.swarm_num-1) <= obj.swarm(5,1)
                         obj.copy_nbest(obj,p,p2);
                         obj.copy_nbest(obj,p1,p2);                     
                    end 
                else % obj.swarm(6,obj.swarm_num) <= obj.swarm(6,1)
                    if obj.swarm(6,p)<= obj.swarm(6,p2)
                         obj.copy_nbest(obj,p2,p);
                         obj.copy_nbest(obj,p1,p);
                    else   % obj.swarm(6,obj.swarm_num) >= obj.swarm(6,1)
                         obj.copy_nbest(obj,p,p1);
                        obj.copy_nbest(obj,p2,p1);
                    end
                end 
        end  % end of neightbour function
            % structure:[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10) xv+1(11) yv+1(12) xp+1(13) yp+1(14)]
        function copy_nbest(obj, p2, p1) % copy p1's value into p2, i.e. p1 is nbest

            obj.swarm(6,p2)= vpa(obj.swarm(6,p1)); % evaluated value based on nbest x and y
            obj.swarm(7,p2)= vpa(obj.swarm(7,p1)); % nbest x 
            obj.swarm(8,p2)= vpa(obj.swarm(8,p1)); % nbest y

        end


        function lpso(obj) % running async linear pso 
            obj.init(obj);
            iteration=0;
            obj.init_swarm(obj);

            while(iteration~= obj.max_t)
                   % obj.r1_r2_gen(obj); %  simple pso
                for i= 1:obj.swarm_num
                   obj.r1_r2_gen(obj); % obj.r1_r2_gen(obj); % linear psp r1 r2 generated 
                    obj.next_v(obj,i); % find v t+1 
                    obj.next_pos(obj,i); % cal next pos
                    obj.next_pos_ass(obj,i); %assign next v and p to current 
                    obj.use_formula(obj,i); % check pbest 
                    obj.compare_neibour(obj,i); % check nbest


                end


                temp=iteration+1;
                iteration=temp;
                %[xp(1) yp(2) xv(3) yv(4) pbest(5) nbest(6) xnbest(7) ynbest(8) xpbest(9) ypbest(10) xv+1(11) yv+1(12) xp+1(13) yp+1(14)]
                
                %{

             
                scatter3(obj.swarm(9,:),obj.swarm(10,:),obj.swarm(5,:)); %pbest
                hold on 
                scatter3(obj.swarm(7,:),obj.swarm(8,:),obj.swarm(6,:)); % nbest
                ax = gca;
                exportgraphics(ax,'myplots.pdf','Append',true)
                hold off
                %}


                % Fitness plot


              temp_pbst= obj.swarm(5,:);
              temp_gbest= obj.swarm(6,:);
              obj.fitness(1,iteration) =vpa(sum(temp_pbst,'All')./obj.swarm_num);
              obj.fitness(2,iteration) =vpa(min(temp_gbest)); % due to asyn update, all particle will have the same gbest at the end, althou they may not use the presented gbest to calculate their value


            end 

            %plot fitness 
            plot(obj.fitness(1,:));
            hold on;
            plot(obj.fitness(2,:)); 
            hold off;


        end


    end
end

