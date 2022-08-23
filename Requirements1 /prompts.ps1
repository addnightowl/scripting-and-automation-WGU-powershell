# Anthony Davis, student-id

clear

#Apply exception handling using try-catch for System.OutOfMemoryException.
try {Do {
$input = (Read-Host "Please Enter a Number From 1-5 to Complete the Following Administrative Task.");

switch ($input) {

    1 { #Get the date and add it to DailyLog.txt.
        Get-Date | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append;
        #Get all files in Requirements 1 folder matching the filter ".log" (log files) and append the list to DailyLog.txt.
        Get-ChildItem $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append;
        #Task 1 complete
        Write-Host -foreGroundColor Green "Task 1 complete, check DailyLog.txt in Requirements1 folder."
        break}
    
    2 { #Assign all files in Requirements 1 folder to C916contents.txt.
        Get-ChildItem -Path $PSScriptRoot | Out-File -FilePath $PSScriptRoot\C916contents.txt -Append;
        #Task 2 complete
        Write-Host -foreGroundColor Cyan "Task 2 complete, check C916contents.txt in Requirements1 folder." 
        break}
    
    3 { #Use counters to list the current CPU % Processing Time/Physical Memory usage.
        #Collect 4 samples of CPU % processing time with each sample being 5 second intervals. 
        Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 5 -MaxSamples 4;
        #Collect 4 samples of memory usage with each sample being 5 second intervals. 
        Get-Counter -Counter "\memory\% committed bytes in use" -SampleInterval 5 -MaxSamples 4;
        #Task 3 complete
        Write-Host -foreGroundColor Yellow "Task 3 complete, record TimeStamps in Requirements1 folder."
        break}
    
    4 { #List all running processes inside the system. 
        #Sort output by processor time in seconds (s) greatest to least. 
        #Display in grid format.
        #'ogv' is alias for "Out-GridView"
        Get-Process | Sort-Object -Property CPU -Descending | ogv;
        #Task 4 complete
        Write-Host -foreGroundColor Magenta "Task 4 complete, record GridView in Requirements1 folder."
        break}

     5 {#Exit Script. 
        Write-Host -foreGroundColor Red "Exiting the Script. Have a nice day!"
        break}

                }

   } until ($input -eq 5)

   }

   #Apply exception handling using try-catch for System.OutOfMemoryException.
   catch [System.OutOfMemoryException] {
            Write-Host "A system out of memory exception has occurred. Please review this error!"
   }