# Version 0.2.1


## Submission 3

Hi,

this is a re-submission of a new submission to CRAN, with some changes due to suggestions by Swetlana Herbrandt (see comments below)

The package tests without apparent problems under 

* local MAC OS 10.14.1 (Mojave), R 3.6.1
* http://win-builder.r-project.org/ - oldrelease / devel / release
* Linux (Travis CI) - oldrel / release / devel

Best,
Florian


--- comments to pre-check ---


Thanks, please add a web reference for the PROFOUND Database in your Description text in the form
<http:...> or <https:...>
with angle brackets for auto-linking and no space after 'http:' and 'https:'.

--> DONE

Please replace \dontrun{} by \donttest{} in your Rd-files if no API key is required.

--> AFTER EMAIL CONVERSATION, I KEPT DONTRUN IN MOST CASES

You are changing the user's par() settings in your functions. Please ensure with an immediate call of on.exit() that the settings are reset. E.g.
    opar <- par(no.readonly =TRUE)       # code line i
    on.exit(par(opar))                   # code line i+1
    
--> DONE

Same issue for setwd().

--> THIS WOULDN'T HAVE WORKED BECAUSE PATHS ARE LATER USED, I JUST REMOVED THE SETWD

Please ensure that your functions do not modify (save or delete) the user's home filespace in your examples/vignettes/tests. That is not allow by CRAN policies. Please only write/save files if the user has specified a directory. In your examples/vignettes/tests you can write to tempdir(). E.g. folder = tempdir() instead of folder = "ISI-MIP".

--> DONE


## Submission 2

Hi,

this is a new submission to CRAN. As suggested earlier today in the pre-checks, I have 

* changed the title to title case
* reduced description
* to have an url to the databse in the description is a good idea, but we have a doi and it looks a bit weird. The databse is linked under the package url

The package tests without apparent problems under 

* local MAC OS 10.14.1 (Mojave), R 3.6.1
* http://win-builder.r-project.org/ - oldrelease / devel / release
* Linux (Travis CI) - oldrel / release / devel

Best,
Florian


## Submission 1

Hi,

this is a new submission to CRAN. The package tests without apparent problems under 

* local MAC OS 10.14.1 (Mojave), R 3.6.1
* http://win-builder.r-project.org/ - oldrelease / devel / release
* Linux (Travis CI) - oldrel / release / devel

I have checked the winbuilder messages. The only notes related to spelling, which I believe is correct. 

Best,
Florian





