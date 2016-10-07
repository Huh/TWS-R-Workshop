# TWS-R-Workshop
A progressive build of a Shiny application to simulate and fit linear models.

A link to the Shiny5 application can be found at: [popr.cfc.umt.edu](popr.cfc.umt.edu)

The purpose of this application is to demonstrate the use of Shiny while using some of the skills learned during the workshop.

### Use
1. To use the application define the number of observations to simulate.  Think of this as your sample size.
2. Define a formula, without the response variable
  + Most any valid R formula will do, but this application cannot handle random effects
  + If you need help with R formulas try ?formula at the console or google it
  + An example formula might be: ~snow*rain
3. Once you have defined the formula the application will create a series of numeric inputs that will allow you to put the true value of the coefficient(s)
  + Also, you will notice that your formula is pseudo-validated at the top of the screen the result of this quick check is shown to the user
  + At this time the model matrix is presented to the user as a data.table on the right side of the screen
4. The residual error distribution is fixed to Normal for the moment, but I could imagine including Binomial and others in the future
5. When the residual error choice is Normal then we need to define the standard deviation of the distribution, put that in the next box
6. When you are happy with the data and your formula click on the Fit Model button to run the model
  + You may notice a progress bar that appears ever so briefly in the bottom right corner of the screen
7. Now you can view the results of the fitting procedure by changing to the Model Fit tab near the top center of the screen

### Annoying bits
+ The primary annoying bit is that if you are looking at the Model Fit tab and make a change in the input panel at left the dynamic inputs cease to react to your inputs until you switch back to the Simulate Data tab.  

### Interesting Shiny bits
+ The application is built in a progressive manner, see the folders of this repository
+ Many of the really cool features of Shiny are built into this application
+ Dynamic UI components take two forms, conditional and uiOutput types
+ UI elements are created using a loop
+ The new modal dialog was incorporated
+ There is a progress bar
+ I made efforts to use many of the existing widgets
+ And much more...hope it is a good example of a the components of an application

### Bugs and feature request
+ Report bugs and feature requests to this repository's Issues page
  + [Click here for the Issues page](https://github.com/Huh/TWS-R-Workshop/issues)
  
By the way, for those of you in the workshop this is another example of Markdown.  The syntax is really close to that we used in R, but there are few differences.

Josh 
