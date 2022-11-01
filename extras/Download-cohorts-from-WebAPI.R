# This file contains cohort definitions update code and can't be run as is
# One should get valid JWT Atlas session token and store it in bearer variable.
# If script crashes try to update bearer variable with a new token.

# ROhdsiWebApi version to install:
# remotes::install_github("ohdsi/ROhdsiWebApi", ref="develop")

library(PioneerMetastaticTreatement)

# get this token from an active ATLAS web session
bearer <- "Bearer "

baseUrl <- "https://pioneer.hzdr.de/WebAPI"
ROhdsiWebApi::setAuthHeader(baseUrl, bearer)

cohortGroups <- read.csv(file.path("inst/settings/CohortGroups.csv"))
for(i in 1:nrow(cohortGroups)) {
  ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = file.path('inst', cohortGroups$fileName[i]),
                                                   baseUrl, packageName = getThisPackageName())
}


