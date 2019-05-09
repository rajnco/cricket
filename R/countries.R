library(rvest)

countries <- function() {
    country_index_url <- xml2::read_html("http://www.espncricinfo.com/story/_/id/18791072/all-cricket-teams-index")
    list_of_ahref <- rvest::html_nodes(country_index_url, "div#global-viewport.espncricinfo section#pane-main section#main-container div.main-content.layout-cb section#article-feed.col-b article.article div.container div.article-body p a")
    list_of_href <- rvest::html_attr(list_of_ahref, "href")
    matched <- regexpr("\\d+", list_of_href, perl=TRUE)
    country_oids <- regmatches(list_of_href, matched)
    return(country_oids)
}
