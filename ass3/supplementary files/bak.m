
% description:
% Genetic Algorithm, with controlled parameter and their range as follows:
% Kp(2,18) ;Ti(1.05,9.42);Td(0.26, 2.37)
% Using elitism
% Represent individual by columns, first generation is randomly generated.

classdef Ga_algo1 < handle % a handle class makes copy by reference when a function is called to chnage properties.
    properties

        % user inputs 
         initial_pop = 10; % the initial population size; note that this must be divisible by two
         limit_generation % a termination condiction

         %parent slection
         crossover_rate=0.6
         %mutation
         mutation_probablitity=0.25
         sigma_mutation=1 % Guassain normal noise value generated from rand(mean_mutation, sigma_mutation)
         mean_mutation=0



        % controlled variable (Kp, Ti, Td) allowed range:
        % Kp(2,18) ;Ti(1.05,9.42);Td(0.26, 2.37)
        % y=[2.01;1.09;0.27];

        gen_fitness% sum of fitness indicator in selection fucntion
        generations
        parents % parent of the current generation (chosen under some function)
 
        pop_u % Genes; each columns stands an individual of a population of the current generation
        


        %parent selection parameters:
        scaFactor % A scaling factor for fitness goodness when selecting parents if needed
        temp % Store temporary fit value
        %crossover_rate=0.6
        parent_pop % a selected parent population
        temp2
        t4
        temp1
        new_order
        pin_portion_assign
        wheel_stop_at
        

        %Crossover parameters:
        child_pop % matrix of child population, (3, initial_pop); designed to reuse parent selection code

        %Elitism
        best_of_all
        gen_count
    
    end
  
     
    methods(Static) % static: indep. from an instance of a class, ie. dont need 
        % an instance of the class to run the function 
        
   % initialization only 
        % generating controlled variables. Eachs row represents one
        % inidivial. 
        function pop_int(obj) % side note: obj is like self in python

                % start generation count
                obj.generations=1

                % randomness using uniform distribution
                a_m=randi([200,1800],1,obj.initial_pop); %  1 by initial_pop matrix, 100*Kp
                b_m= randi([105,942],1,obj.initial_pop); %  1 by initial_pop matrix, 100*Ti
                c_m= randi([26,237],1,obj.initial_pop); %  1 by initial_pop matrix, 100*Td
               
               pop=1/100*[a_m;b_m;c_m]; % divided by 100 for 2 decimal precision
                   
               obj.pop_u= pop;
               obj.best_of_all= zeros(4, obj.initial_pop);
               obj.gen_count=1;
        end

     % %%%%%%%%%%%%%%% Start of FPS parent selection and its member function % %%%%%%%%%%%%%%%%%%

     %special note: Since larger value in fitness means worse solution, the
     %selection usesparent selection. Hence, fitness value is
     %portpoertionate to the likelyhood of parent outcome. Assume
     %uniform distrubution.
     % i.e. Idividual that are selected will be single, RIP."%
  
  % parent select memeber function: debug package, calling mutiple function at a time


  function ps_all(obj) % running parent selection
      obj.pop_int(obj);
      obj.ps_sum_fitness(obj); 
      obj.ps_scaFactor_fun(obj);
      obj.ps_assign_fit(obj);
      obj.ps_parents(obj);

  end
  

  % parent select memeber function: sum the generation's total fitness 
       function ps_sum_fitness(obj) 
           % initialize global fitness count
           obj.gen_fitness= 0;
           past_val=0;
           current_val=0;

           % sum all the fitness     
           for i= 1: width(obj.pop_u) % width of pop_u= columns of pop_u= population size
               current_val=past_val+ obj.f_eval(obj.pop_u(:, i));
               past_val=current_val; % since matlab doesnt have post and pre increment

           end
                    obj.gen_fitness=past_val; % inverse the sum of f_eval is the goodness (i.e. we are minimizing values)
  
       end

% parent select memeber function: establish scalaing factor
       function ps_scaFactor_fun(obj) 

            %obj.scaFactor = 100* obj.initial_pop/obj.gen_fitness

       end
% parent select memeber function: assigning inverse fitness * scalaing
% factor to each individual 
        function ps_assign_fit(obj) 

            %since  inverse and scalar factor will be applied to individual,
            %apply the same thing to total fitness too          

            obj.temp = zeros(1,obj.initial_pop); % create a row of pop size
            for i = 1: width(obj.pop_u)
                
                obj.temp(1,i)=100*obj.f_eval(obj.pop_u(:, i))/obj.gen_fitness; % apply inverse and scalar factor here
      
            end
         
            % combine
            % adding temp to the last row of pop 

            %obj.pop_u=[obj.pop_u; round(100*obj.temp)] % *100 again to get precison to two decimal place

            %~            for debug and faster running, use 
            
            obj.pop_u=[obj.pop_u; round(obj.temp)]; %adding crteria new table to the population

        end


   % parent select memeber function: selecting parents 
   % input: crossover rate and methods of selection
   function ps_parents(obj)
       % first extract last row (ie. the fitness row) syntax: a(n,:)
       extract_fit= obj.pop_u(4, :);
  
       [extract_fit_sorted,I] = sort(extract_fit,'descend');

        obj.temp2=extract_fit_sorted;

       % from extract, assume the columns are in order, 
       % thus, create new_order = int8(1):int8(population_size)

       order = int16(1):int16(obj.initial_pop);
     

       obj.new_order=order(I); % this array stores sort(extract) order change,
       % this will be use as a lookup table to access column of pop_u
       % ie., rank 1 individual is at column new_order(1,1).

        
       % ie. assign ranges on the wheel 
       % side notes of range assignmnets:
       % i.e. say individual I is at rank and 1 has fitness measure of 50 %, and we run on a wheel of
       % digit 1 to 100.
       % Say the pin lands on k, then I will be selected if 1 < or = k < or = 50. 
       
       % in code representation, 
       % we have order[i]= the upper bound of I's range and order[i-1] = the
       % lower bound of I such that I's range is defined as: 
       %  order[i-1] < and (!=) Range of I < or = order[i] as we impletemnt
       %  below:
       for i = 2: width(extract_fit)
           temp=extract_fit_sorted(1,i-1)+extract_fit_sorted(1,i);
           extract_fit_sorted(1,i)=temp;
       end 

       obj.pin_portion_assign=extract_fit_sorted ;  

       % generating random number, aka, rolling wheel.

       initial_temp=zeros(1, obj.initial_pop);
       obj.parent_pop=initial_temp;

     
       %~        Debug for faster run, use: 
     
      
       obj.wheel_stop_at= randi(100,1,10,"int16");

       p_temp=zeros(1, obj.initial_pop);

   for k =1: obj.initial_pop 
       
       
       %wheel_stop_at=randi(1,10000); % 1 to 100 (originally a percentage fitness) 00  (two zeros due to two decimal precision)
       if obj.wheel_stop_at (1,k) <= obj.pin_portion_assign(1,1) % if less than or equal to upper bound of rank 1 fitness then select rank 1 element,
           % rank 1 element is corresponf to order (1,1), so we store them
           % in a new array
           % using syntax: x = [x, newval]
           p_temp(1,k)= obj.new_order(1,1);

       else

           for j=2: obj.initial_pop 
           
            if obj.pin_portion_assign(1,j-1)< obj.wheel_stop_at(1,k)  & obj.wheel_stop_at(1,k) <= obj.pin_portion_assign(1,j)

                    p_temp(1,k)= obj.new_order(1,j); % putting the column number to the parent selection array
                    % obj.parent_pop(1,k)= extract_fit_sorted(1,j); for
                    % debug, this output should fall in corresponding
                    % range.

                    %side note: new_order stores the column correspond to
                    %pop_u, and parent_pop stores the column to constitute
                    %the parent population, note that the order of function
                    %calling matters, only use de() function to call these
                    %member functions. 
             
            end
           end

       end
   end 

   obj.parent_pop=p_temp;

   end
   %%%%%%%%%%%%%%%%%% End of  FPS parent selection and its member function  %%%%%%%%%%%%%%%%%%




   %%%%%%%%%%%%%%%%%% Start of Crossover and its member function  %%%%%%%%%%%%%%%%%%


   % Using whole arithmetic crossover with crossover:
   function co_all(obj) %initilaize of the child generation
       % we want to be able to resue the parent code, hence, create
       % initialze matrix condition with 3x pop_size 
       obj.child_pop= zeros(3,obj.initial_pop); 

       % pairing next index number for whole arithmetic crossover child=(ay +
       % (1-a)x) ; y and x are parents; another child uses the same way but
       % swap x and y position in the equation.
       for i=1:obj.initial_pop/2

        if i ~= obj.initial_pop/2 
           
           x= obj.pop_u(1:3,obj.parent_pop(1,2*i));
           y= obj.pop_u(1:3,obj.parent_pop(1,2*i+1));


           obj.child_pop(:,2*i)= obj.mutation_all(obj,obj.crossover_rate* x + (1-obj.crossover_rate)*y);
           obj.child_pop(:,2*i+1)= obj.mutation_all(obj,obj.crossover_rate* y + (1-obj.crossover_rate)*x);

           
       else % the case i == initial_pop/2
           x= obj.pop_u(1:3,obj.parent_pop(1,1));
           y= obj.pop_u(1:3,obj.parent_pop(1,obj.initial_pop));

           obj.child_pop(:,1)=obj.mutation_all(obj,obj.crossover_rate* x + (1-obj.crossover_rate)*y);
           obj.child_pop(:,obj.initial_pop)=obj.mutation_all(obj,obj.crossover_rate* y + (1-obj.crossover_rate)*x);
        end


    end

end 


   %%%%%%%%%%%%%%%%%% End of Crossover and its member function  %%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%% Start of Mutattion and its member function  %%%%%%%%%%%%%%%%%%
    %input, the target value to mutation
    function [value_out]=mutation_all(obj,value) 
        
        k=randi([1 100*obj.mutation_probablitity]);
        if(k<= 100*obj.mutation_probablitity) %apply mutation
            value_out= value+ normrnd(obj.mean_mutation, obj.sigma_mutation);
        else
            value_out=value;
        end

 end

    %%%%%%%%%%%%%%%%%% End of Mutattion and its member function  %%%%%%%%%%%%%%%%%%




    %%%%%%%%%%%%%%%%%% Start of Elitism and its member function  %%%%%%%%%%%%%%%%%%
function elit(obj)
    % Store the best of the parent generation  obj.new_order(1,1); takeing
    % all 3 parameter and its evaluated fitness.
    obj.best_of_all(1:4, obj.gen_count)=obj.pop_u(1:4, obj.new_order(1,1));
    temp=obj.gen_count+1;
    obj.gen_count=temp; %increment generation

    obj.pop_u= zeros(3, obj.initial_pop); 
    obj.pop_u= obj.child_pop;

end
 %%%%%%%%%%%%%%%%%% End of Elitism and its member function  %%%%%%%%%%%%%%%%%%
 


 %%%%%%%%%%%%%%%%%% Start of Pipeline and auto-run and its member function  %%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%% End of Pipeline and auto-run and its member function  %%%%%%%%%%%%%%%%%%




% fitness calls perfFCN(x) and returns the sum of 3 criteria ISE,t_r,t_s,M_p
        function fiteval= f_eval(x)
                
           [ISE,t_r,t_s,M_p]=perfFCN(x);
               
        %assume NaN is HIGH PENTALY (due to division by zero)
            if isnan(ISE)
                ISE=1000;
            end
            if isnan(t_r)
                t_r=1000;
            end
            if isnan(t_s)
                t_s=1000;
            end
            if isnan(M_p)
                M_p=1000;
            end
         
         % fitness is weight* criteria. Asssume all criteria are of wight
         % 1.
        fiteval=1/(ISE+t_r+t_s+M_p);
         
        end
    end
end
