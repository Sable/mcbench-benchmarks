function listTasks(j)

%listTasks(j)  Displays a summary of tasks belonging to a job, j

%by Phil Wade, University of Bristol, UK.  E-mail Phil.Wade@bristol.ac.uk

error(nargchk(1, 1, nargin));

dashes = '--------------------------------------------------------------------------------';
spaces = '                                                                                ';

tasks = findTask(j);

worker_col_width = 6;
function_name_col_width = 13;
for i = 1:length(tasks)
   if length(tasks(i).Worker)
      worker_col_width = max(worker_col_width, length(tasks(i).Worker(1).Hostname));
   end
   if isa(tasks(i).Function, 'function_handle')
      function_name_col_width = max(function_name_col_width, length(func2str(tasks(i).Function)));
   else
      function_name_col_width = max(function_name_col_width, length(tasks(i).Function));
   end
end

disp(sprintf(['Summary of tasks belonging to job ''%s'' (job ID %d, username %s):\n\n' ...
              'Task ID  Task state  Entered state  %sWorker  %sFunction name  Error identifier\n' ...
              '-------  ----------  -------------  %s------  %s-------------  ----------------'], ...
             j.Name, j.ID, j.UserName, spaces(1:worker_col_width-6), spaces(1:function_name_col_width-13), ...
             dashes(1:worker_col_width-6), dashes(1:function_name_col_width-13)));

for i = 1:length(tasks)

   if strcmp (tasks(i).State, 'pending')
      entered_state = tasks(i).CreateTime(5:16);
      error_identifier = '(task not started yet)';
   elseif strcmp (tasks(i).State, 'running')
      entered_state = tasks(i).StartTime(5:16);
      error_identifier = '(task still running)';
   elseif strcmp (tasks(i).State, 'finished')
      entered_state = tasks(i).FinishTime(5:16);
      error_identifier = tasks(i).ErrorIdentifier;
   else
      entered_state = '';
      error_identifier = '';
   end

   if length(tasks(i).Worker)
      worker = tasks(i).Worker(1).Hostname;
   else
      worker = '';
   end

   if isa(tasks(i).Function, 'function_handle')
      function_name = func2str(tasks(i).Function);
   else
      function_name = tasks(i).Function;
   end

   disp(sprintf(['%7d%12s%15s  %' num2str(worker_col_width) 's  %' num2str(function_name_col_width) 's  %s'], ...
                tasks(i).ID, tasks(i).State, entered_state, worker, function_name, error_identifier));

end

disp(' ');
