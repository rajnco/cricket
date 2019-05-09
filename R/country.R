library(rvest)
library(stringr)

player_ids <- function(countrycode) {
    print(countrycode)
    country_base_page <- "http://www.espncricinfo.com/india/content/player/country.html?country=__CID__"
    country_base_page <- stringr::str_replace(country_base_page, "__CID__", countrycode)

    country_page <- xml2::read_html(country_base_page)

    list_of_player <- rvest::html_nodes(country_page, "div#ciHomeContent div#ciMainContainer div#ciHomeContentlhs div.pnl650M div div#rectPlyr_Playerlistall table.playersTable")
    list_of_ahrefs <- rvest::html_nodes(list_of_player, "tr td a")
    list_of_href <- rvest::html_attr(list_of_ahrefs, "href")

    matched <- regexpr("\\d+", list_of_href, perl=TRUE)
    player_oids <- regmatches(list_of_href, matched)

    return(player_oids)
}


