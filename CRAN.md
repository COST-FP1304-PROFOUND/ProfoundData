# Version 0.2.1


## Submission 4

Hi,

this is a new submission to CRAN. See reply / changes in response to pre-check below. 

The package tests without apparent problems under 

* local MAC OS 10.14.1 (Mojave), R 3.6.1
* http://win-builder.r-project.org/ - oldrelease / devel / release
* Linux (Travis CI) - oldrel / release / devel

There is a doi warning from WinBuilder, but this is for the vignette, and I couldn't see how 

Best,
Florian

=== response to pre-check comments === 

\dontrun{} should only be used if the example really cannot be executed (e.g. because of missing additional software, missing API keys, ...) by the user. That's why wrapping examples in \dontrun{} adds the comment ("# Not run:") as a warning for the user.
Does not seem necessary.
Please unwrap the examples if they are executable in < 5 sec, or replace \dontrun{} with \donttest{}.
I saw your comment about it, but please either change dontrun, or explain, because others cannot know what you wrote emails about...

  OK, I wrote with Swetlana Herbrandt about this previously, see Email conversation below
  
  Dear Florian,
  
  thanks for explanation. In this case, you can keep the \dontrun{} wrapper.
  
  Please fix the other issues and resubmit.
  
  Best,
  Swetlana
  
  On 19.03.2020 20:20, Florian Hartig wrote:
  > Hi Svetlana,
  >
  > thanks for looking at the package - I'm not quite sure what to do with:
  >
  > Please replace \dontrun{} by \donttest{} in your Rd-files if no API key is required.
  >
  > I have removed \dontrun{} in one example, where it was indeed completely unnecessary. The rest of the \dontrun{} commands make sense to me, because either
  >
  > * examples will only run if users have registered a database before (is that what you mean by API key?)
  >
  > * or something really time-consuming would happen, e.g. downloadDatabase could take hours on a slow internet connection.
  >
  > I think (but please correct me) that it would be better to set dontrun in this case. To make this more clear, I have added
  >
  > # example requires that a sql DB is registered via setDB(dbfile)
  > # when run without a registered DB, you will get a file query (depending on OS)
  >
  > At the top of all help files that require a DB connection.
  >
  > Is that an acceptable solution, or do you still want me to switch to donttest?
  >
  > Cheers,
  > Florian 


Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace (including the package directory and getwd()). That is not allowed by CRAN policies. Please only write/save files if the user has specified a directory in the function themselves. Therefore please omit any default path in writing functions.
In your examples/vignettes/tests you can write to tempdir().
e.g. reportDB.Rd, downloadDatabase(), ...

  Sorry, this was an oversight, I thought I had this fixed. I hope with https://github.com/COST-FP1304-PROFOUND/ProfoundData/commit/5f5309c5e0a0768505c7d875a8da44d1efd7d877 , I have now removed all paths.

Please fix and resubmit.

Best,
Martina Schmirl 

  Thanks!



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





