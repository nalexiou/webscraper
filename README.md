# webscraper

This Ruby program scrapes Wikipedia for all Academy Award Winners for Best Picture. It will print out to the terminal the film info (year, title, budget) as well as output this information to a text file. It calculates the average budget using all films for which the budget amount is given in the summary table of each film. Please note that when only a UK Pound budget was provided, the amount was converted to US Dollars using a standard exhange rate.

This program assumes that you will be using Mac OS. To run the code, download/clone the repository and follow the steps below:

        # Open a terminal window and navigate to the directory where you downloaded source code

        	cd /path/to/sourcecode/directory

        #Run the program

        	ruby webscraper.rb

REQUIREMENTS

Please note that this program requires the nokogiri gem (version 1.6.6.2). To install it, run this command:

        gem install nokogiri -v 1.6.6.2

Also, code was written using Ruby 2.1.3

To install Ruby 2.1.3, run this command:
		
		rvm install 2.1.3

and then switch to Ruby 2.1.3 using this command:

		rvm use 2.1.3

If you do not have RVM installed, do so by following instructions here: [RVM](https://rvm.io/rvm/install)
