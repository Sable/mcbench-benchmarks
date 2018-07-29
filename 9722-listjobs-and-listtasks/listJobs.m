function listJobs(jm)

%listJobs(jm)  Displays a summary of jobs in the jobmanager, jm

%by Phil Wade, University of Bristol, UK.  E-mail Phil.Wade@bristol.ac.uk

error(nargchk(1, 1, nargin));

dashes = '--------------------------------------------------------------------------------';
spaces = '                                                                                ';

total_pending  = 0;
total_running  = 0;
total_finished = 0;

jobs = findJob(jm);

job_name_col_width = 8;
username_col_width = 8;
for i = 1:length(jobs)
   job_name_col_width = max(job_name_col_width, length(jobs(i).Name));
   username_col_width = max(username_col_width, length(jobs(i).UserName));
end

disp(sprintf(['Summary of jobs currently in job manager ''%s'':\n\n' ...
              '        %s          %s                                      Tasks    Tasks     Tasks\n' ...
              'Job ID  %sJob name  %sUsername  Job state  Entered state  pending  running  finished  Errors\n' ...
              '------  %s--------  %s--------  ---------  -------------  -------  -------  --------  ------'], ...
             jm.Name, spaces(1:job_name_col_width-8), spaces(1:username_col_width-8), spaces(1:job_name_col_width-8), ...
             spaces(1:username_col_width-8), dashes(1:job_name_col_width-8), dashes(1:username_col_width-8)));

for i = 1:length(jobs)

   if strcmp (jobs(i).State, 'pending')
      entered_state = jobs(i).CreateTime(5:16);
   elseif strcmp (jobs(i).State, 'queued')
      entered_state = jobs(i).SubmitTime(5:16);
   elseif strcmp (jobs(i).State, 'running')
      entered_state = jobs(i).StartTime(5:16);
   elseif strcmp (jobs(i).State, 'finished')
      entered_state = jobs(i).FinishTime(5:16);
   else
      entered_state = '';
   end

   tasks_pending  = length(findTask(jobs(i), 'State', 'pending'));
   tasks_running  = length(findTask(jobs(i), 'State', 'running'));
   tasks_finished = length(findTask(jobs(i), 'State', 'finished'));

   disp(sprintf(['%6d  %' num2str(job_name_col_width) 's  %' num2str(username_col_width) 's%11s%15s%9d%9d%10d%8d'], ...
                jobs(i).ID, jobs(i).Name, jobs(i).UserName, jobs(i).State, entered_state, ...
                tasks_pending, tasks_running, tasks_finished, ...
                length(jobs(i).Tasks) - length(findTask(jobs(i), 'ErrorMessage', ''))));

   total_pending  = total_pending  + tasks_pending;
   total_running  = total_running  + tasks_running;
   total_finished = total_finished + tasks_finished;

end

disp(sprintf(['                                                      %s%s-------  -------  --------\n' ...
              'Totals                                                %s%s%7d%9d%10d'], ...
             spaces(1:job_name_col_width-8), spaces(1:username_col_width-8), spaces(1:job_name_col_width-8), ...
             spaces(1:username_col_width-8), total_pending, total_running, total_finished));

disp(sprintf(['\n' ...
              'Job manager state:%14s\n' ...
              'Number of busy workers:%9d\n' ...
              'Number of idle workers:%9d\n' ...
              'Total number of workers:%8d\n'], ...
             jm.State, jm.NumberOfBusyWorkers, jm.NumberOfIdleWorkers, jm.NumberOfBusyWorkers + jm.NumberOfIdleWorkers));
