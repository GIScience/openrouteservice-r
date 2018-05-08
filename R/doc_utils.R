doc_url <- function(service) {
  if (service=="pois")
    "https://github.com/GIScience/openpoiservice#api-documentation"
  else
    sprintf("https://openrouteservice.org/documentation/#/reference/%s/%s", service, service)
}

doc_link <- function(service) sprintf("[%s](%s)", service, doc_url(service))

signup_url <- function (label) {
  url <- "https://openrouteservice.org/sign-up"
  if ( missing(label) )
    url
  else
    sprintf("[%s](%s)", label, url)
}
