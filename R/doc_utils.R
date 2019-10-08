doc_url <- function(service) {
  paste0("https://openrouteservice.org/dev/#/api-docs/", service)
}

doc_link <- function(service, label=service) sprintf("[%s](%s)", label, doc_url(service))

signup_url <- function (label) {
  url <- "https://openrouteservice.org/dev/#/sign-up"
  if ( missing(label) )
    url
  else
    sprintf("[%s](%s)", label, url)
}
