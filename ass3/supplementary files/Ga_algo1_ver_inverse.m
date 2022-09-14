
% description:
% Genetic Algorithm, with controlled parameter and their range as follows:
% Kp(2,18) ;Ti(1.05,9.42);Td(0.26, 2.37)
% Using elitism
% Represent individual by columns, first generation is randomly generated.

classdef Ga_algo1 < handle % a handle class makes copy by reference when a function is called to chnage properties.
    properties
        gen_fitness% sum of fitness indicator in selection fucntion
        generations
        parents % parent of the current generation (chosen under some function)
        limit_generation % a termination condiction
        initial_pop = 5; % the initial population size
        
        pop_u % Genes; each columns stands an individual of a population of the current generation
        
        % controlled variable (Kp, Ti, Td) allowed range:
        % Kp(2,18) ;Ti(1.05,9.42);Td(0.26, 2.37)
        % y=[2.01;1.09;0.27];

        %parent selection parameters:
        scaFactor % A scaling factor for fitness goodness when selecting parents if needed
        temp % Store temporary fit value
    
    end
  
     
    methods(Static) % static: indep. from an instance of a class, ie. dont need 
        % an instance of the class to run the function 
        
   % initialization only 
        % generating controlled variables. Eachs row represents one
        % inidivial. 
        function pop= pop_int(obj) % side note: obj is like self in python

                % start generation count
                obj.generations=1

                % randomness using uniform distribution
                a_m=randi([200,1800],1,obj.initial_pop) %  1 by initial_pop matrix, 100*Kp
                b_m= randi([105,942],1,obj.initial_pop) %  1 by initial_pop matrix, 100*Ti
                c_m= randi([26,237],1,obj.initial_pop) %  1 by initial_pop matrix, 100*Td
               
               pop=1/100*[a_m;b_m;c_m]  % divided by 100 for 2 decimal precision
                   
               obj.pop_u= pop
        end

     % %%%%%%%%%%% FPS parent selection and its member function % %%%%%%%%%%%%%%%%%%

     %special note: Since larger value in fitness means worse solution, the
     %selection uses "Not" parent selection. Hence, fitness value is
     %portpoertionate to the likelyhood of "Not" parent outcome. Assume
     %uniform distrubution.
     % i.e. Idividual that are selected will be single, RIP."%
  
  % parent select memeber function: debug package, calling mutiple function at a time

  function de(obj)
      obj.pop_int(obj)
      obj.ps_sum_fitness(obj); 
      obj.ps_scaFactor_fun(obj);
      obj.ps_assign_fit(obj);

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
             
            %obj.inversed_scal_gen_fitness= obj.scaFactor*1/obj.gen_fitness  % using  inversed_scal_gen_fitness since minimizing 


            obj.temp = zeros(1,obj.initial_pop); % create a row of pop size
            for i = 1: width(obj.pop_u)
                
                obj.temp(1,i)=100*obj.f_eval(obj.pop_u(:, i))/obj.gen_fitness % apply inverse and scalar factor here

                %= 100* temp_inverse_scalar/obj.gen_fitness  % place individual goodness upon sum of goodness and calulate %
            end
         
            % combine
            % adding temp to the last row of pop 

            obj.pop_u=[obj.pop_u; obj.temp]


        end


   %%%%%%%%%%%%%%%%%% end of  FPS parent selection and its member function  %%%%%%%%%%%%%%%%%%

% fitness calls perfFCN(x) and returns the sum of 3 criteria ISE,t_r,t_s,M_p
        function fiteval= f_eval(x)
                
           [ISE,t_r,t_s,M_p]=perfFCN(x);
               
        %assume NaN is 0
            if isnan(ISE)
                ISE=0;
            end
            if isnan(t_r)
                t_r=0;
            end
            if isnan(t_s)
                t_s=0;
            end
            if isnan(M_p)
                M_p=0;
            end
         
         % fitness is weight* criteria. Asssume all criteria are of wight
         % 1.
        fiteval=(ISE+t_r+t_s+M_p);
         
        end
    end
end
