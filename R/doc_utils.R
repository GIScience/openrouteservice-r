doc_url <- function(service) {
  url_template <- switch(service,
                         directions =, isochrones =, matrix =, snap = "https://openrouteservice.org/dev/#/api-docs/v2/%s/{profile}/post",
                         pois =, optimization = "https://openrouteservice.org/dev/#/api-docs/%s/post",
                         "https://openrouteservice.org/dev/#/api-docs/%s")
  sprintf(url_template, service)
}

doc_link <- function(service, label=service) sprintf("[%s](%s)", label, doc_url(service))

signup_url <- function (label) {
  url <- "https://openrouteservice.org/dev/#/signup"
  if ( missing(label) )
    url
  else
    sprintf("[%s](%s)", label, url)
}
