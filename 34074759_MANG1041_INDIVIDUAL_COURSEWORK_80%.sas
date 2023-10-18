 /*The aim of this program is to analyse data on amphibians at 189 sites surrounding two planned motorways in Poland. This includes importing the excel file into SAS,
summarising the number of sites each species has been observed, creating new variables that describe the data set. There are also descriptive statistics such as
frequency tables and correlation coefficients, as well as a logistic regression model to determine the probability of a site being rich in amphibians. Finally,
a report that displays the sites that are richest in amphibians. */

/* Q1. I am importing the excel file 'amphibians.xlsx' into sas and identify what type of database this file is using the 'dbms'command,
as it is an XLSX file using the PROC step */
proc import datafile='C:\Users\hashe\OneDrive\Documents\Southampton Uni\Semester 2\MANG1041 - Analytics Programming 1\Coursework - 80%\amphibians.xlsx'
	out=amphibians
	dbms=xlsx;
run;
/* Q2. I am summing the number of sites that each species has been observed using the 'means' command, as well as telling sas 'noprint' as I am only interested in retrieving
the sum. I am also specifying the variables of all the frog species using the 'var' command, as well as summing the number each species was observed
using the 'sum' command, and creating it as a seperate sheet called 'Number_Of_Species_Observed' and titling it using the 'title' command, all while using the PROC step */
proc means data=amphibians sum nolabels maxdec=0;
	var Green_frogs Brown_frogs Common_toad Fire_bellied_toad
		Tree_frog Common_newt Great_crested_newt;
	title "Number of Species Observed";
run;
/*Q3. Through this print procedure, I can deduce that the species most often observed is 'Brown_frogs' with 148 observations */
/*Q4. This print procedure can also allow me to deduce that the species least often observed is 'Great_crested_newt' with 21 observations */
/*Q5. I am using the 'set' command to ensure that this new variable is created in the original amphibians file, after this, I use the  'sum' command to create a new 
variable that is the sum of all the seven different species, and giving it an easy to read label using the 'label' command using the DATA step*/
data amphibians;
	set amphibians;
	species=sum(Green_frogs, Brown_frogs, Common_toad, Fire_bellied_toad,
				Tree_frog, Common_newt, Great_crested_newt);
	label species='Total number of different species at each site';
run;
/*Q6. I am using the 'proc freq' procedure to produce a table displaying the frequencies, this is done by using the 'tables' statement to produce a frequency list
of all values of the variable species, by motorway, using the '*' notation to allow this, to make the frequency table easier to read, I am supressing unneeded 
results such as col and percent using the statements 'nocol' and 'nopercent' respectively*/
proc freq data=amphibians;
	tables species*motorway / nocol nopercent nocum;
	title 'Frequency of all species by motorway';
run;
/*Q7. Through the proc freq procedure used in Q6, I can deduce that the largest number of different species at any A1 site is 6 */
/*Q8. Through the proc freq procedure used in Q6, I can deduce that the largest number of different species at any S52 site is 7*/
/*Q9. Here I add the variable 'rich_site' in the data set 'amphibians' by using the 'if, then' statement to classify rich_site as a value of 1 when the variable
'species' is greater than 3, and using the 'else' statement to allow the variable 'rich_site' to take a value of 0 otherwise using the DATA step*/
data amphibians;
	set amphibians;
	if species>3 then rich_site=1;
	else rich_site=0;
	label rich_site='Sites richest in amphibians';
run;
/*Q10. Here I use the proc freq procedure in the data set 'amphibians' to show the frequency of rich sites in the data set 'amphibians' and identifying the variable to
measured with the 'tables' statement*/
proc freq data=amphibians;
	tables rich_site / nocol nopercent nocum;
	title 'Frequency of all sites rich in amphibians';
run;
/*Q11. Through the proc freq procedure used in Q10, I can deduce that the number of sites that are rich in amphibians is 70,
as that is the frequency of the value '1' for the variable 'rich_site' which suggests the site is rich in amphibians as it has
more than 3 amphibians */
/*Q12. Here I use the proc corr procedure to calculate the correlation coefficient between the variables 'SR' and 'NR', these 2 variables have been
identified using the 'var' statement*/
proc corr data=amphibians;
	var SR NR;
	title 'Correlation coefficient between surface of water reservoir in m^2 (SR)';
	title2 'and number of water reservoirs in habitat (NR)';
run;
/*Q13. Through the proc corr procedure used in Q12, the correlation coefficient is shown to be 0.65276, I can deduce that this correlation is positive,
and its strength is moderate. */
/*Q14. Here I use the proc logistic statement in the data set 'amphibians', I use the 'model' statement without the 'class' statement as all the independent
variables are numerical data and not categorical, with rich_site on the left-hand site of the equality as it is the dependent variable, here I also use the 'event'
statement to show the probability that the variables 'NR,SR,FR,RR' can predict the variable 'rich_site' */
proc logistic data=amphibians;
	model rich_site(event='1')= NR SR FR RR;
	title 'Logistic Regression model predicting Rich Site'; 
	title2 'probability using the variables NR, SR, FR, and RR';
run;
/*Q15. Through the proc logistic procedure used in Q14, this logistic regression model has a C-statistic of 0.661, this suggests the model is not much better
at classifying which sites are rich in amphibians or not than random chance as, a value closer to 1 will suggest a better logistic regression model */
/*Q16. Here I use the proc print procedure to print a results table from the data set 'amphibians' where the Total number of different species in a given site,
is greater or equal to 6, using the 'where' command and only include the variables 'ID' 'Motorway' and the 7 amphibian species using the 'var' command, also, to
ensure the observation number coloumn is suppressed, I use the command 'noobs'*/
ods pdf file="C:\Users\hashe\OneDrive\Documents\Southampton Uni\Semester 2\MANG1041 - Analytics Programming 1\Coursework - 80%\sites richest in amphibians.pdf" style=ocean;
proc print data=amphibians noobs;
	var ID Motorway species;
	where species>=6;
	title "Sites Richest in Amphibians";
run;
ods pdf close;
