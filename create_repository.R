# create repository
library(archivist.github)
load("github_token.rda");load("password.rda")
if (file.exists("eRum2016/gallery")) {
  deleteLocalRepo(repoDir = 'eRum2016', deleteRoot = TRUE)
  deleteGitHubRepo(repo = "eRum2016", github_token = github_token, user = "archivistR", deleteRoot = TRUE)
}


createGitHubRepo(repo = "eRum2016", 
                 user = "archivistR", 
                 password = password,
                 github_token = github_token,
                 default = TRUE)


aoptions("password", password)
aoptions("user", "archivistR") 
aoptions("repo", "eRum2016")
aoptions("github_token", github_token)

### Examples
# install.packages('survminer')
# source("https://bioconductor.org/biocLite.R")
# biocLite("RTCGA.clinical") # data for examples

library(RTCGA.clinical)
survivalTCGA(BRCA.clinical, OV.clinical,
             extract.cols = "admin.disease_code") -> BRCAOV.survInfo
library(survival)
fit <- survfit(Surv(times, patient.vital_status) ~ admin.disease_code,
               data = BRCAOV.survInfo)
library(survminer)


survplot <- ggsurvplot(
   fit,                     # survfit object with calculated statistics.
   risk.table = TRUE,       # show risk table.
   pval = TRUE,             # show p-value of log-rank test.
   conf.int = TRUE,         # show confidence intervals for 
                            # point estimaes of survival curves.
   xlim = c(0,2000),        # present narrower X axis, but not affect
                            # survival estimates.
   break.time.by = 500,     # break X axis in time intervals by 500.
   ggtheme = theme_RTCGA(), # customize plot and risk table with a theme.
 risk.table.y.text.col = T, # colour risk table text annotations.
  risk.table.y.text = FALSE # show bars instead of names in text annotations
                            # in legend of risk table
)

archive(survplot, alink = TRUE)



library(RTCGA.rnaseq); data(BRCA.rnaseq)
library(dplyr)
BRCA.rnaseq %a%
    select(`TP53|7157`, 
           bcr_patient_barcode) %a%
    # bcr_patient_barcode contains a key to 
    # merge patients between various datasets
    rename(TP53 = `TP53|7157`) %a%
    filter(substr(bcr_patient_barcode, 
                  14, 15) == "01" ) -> 
    # 01 at the 14-15th position tells 
    # these are cancer sample
    BRCA.rnaseq.TP53