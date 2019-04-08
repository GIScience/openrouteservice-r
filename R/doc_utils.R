doc_url <- function(service) {
  paste0("https://openrouteservice.org/dev/#/api-docs/", service)
}

doc_link <- function(service) sprintf("[%s](%s)", service, doc_url(service))

signup_url <- function (label) {
  url <- "https://openrouteservice.org/sign-up"
  if ( missing(label) )
    url
  else
    sprintf("[%s](%s)", label, url)
}
