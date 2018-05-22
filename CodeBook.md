Code Book for mean_data
-----------------------

mean_data holds a tidy data set with the average of each variable for each activity and each subject.
For running the script run_analysis.R please make sure to set your working directory appropriately.


description of columns:
-----------------------

$ subject :  
1..30  
identifier of the subject who carried out the experiment   
$ activity :   
"LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"  
activity performed  
$ fBodyAcc-mean()-X and following  
numeric  
mean of feature value  
	
description of transformations carried out:
-------------------------------------------

1. combine given information for training data:  
* file "subject_train.txt" contains the identifier of the subject which carried out the activity
* file "y_train.txt" contains the label, which activity was carried out 
* file "x_train.txt" contains the measured values
	
One observation results in entries in all of the files. That is why we can combine these files via column bind.  
	
2. combine given information for test data:  
* file "subject_test.txt" contains the identifier of the subject which carried out the activity
* file "y_test.txt" contains the label, which activity was carried out 
* file "x_test.txt" contains the measured values  
	
One observation results in entries in all of the files. That is why we can combine these files via column bind.  
	
3. combine test data and training data:  
Both data sets include the same information, but for different subjects. That is why we combine this data sets via row bind.
	
4. change column names:  
We need to change the column names, because the information was lost while cbinding the different files  
We change the column names according to the order in which we column binded  
The columns from files "x_train.txt" and "x_test.txt" correspond to the features given in file "features.txt". That is why we choose these as column names.  
	
5. Melt the data set:  
As we want to analyze the column names a melt operation is carried out.  
The names of the columns holding the values form a new column variable, the values are in a column called value.  

6. Filter for mean() and std() variables:  
As we only want the measurements on the mean and standard deviation, we filter the variable names.  
If either "mean()" or "std()" is included in the name, we keep the variable.  
This is done by:  
* adding a new column called only_mean_or_std holding a binary variable, which is TRUE, if the variable name includes "mean()" or "std()"
* filtering the data frame data, only_mean_or_std must be true  

7. Add descriptive activity labels:  
  we merge the data data.frame with the data.frame called activity by column activity_id and remove the column activity_id afterwards  
	
8. Summarize data by averaging:  
We dcast the data data.frame to obtain a data.frame holding the average feature value by subject and activity  

9. Remove the variables not needed anymore:  
We remove all variables except data and mean_data  
	
	


