library("rvest")

player_profile <- function(filepath, player_id) {

    player_id <- as.character(player_id)
    player_profile_base_url <- "http://www.espncricinfo.com/india/content/player/__PID__.html"
    player_profile_url <- stringr::str_replace(player_profile_base_url, "__PID__", player_id)

    player_profile_html <- xml2::read_html(player_profile_url)

    x=""
    x <- rvest::html_nodes(player_profile_html, "div#ciHomeContent div#ciMainContainer div#ciHomeContentlhs div.pnl490M div.ciPlayernametxt div h1")
    x <- as.character(rvest::html_text(x))
    shortname <- stringr::str_trim(stringr::str_remove_all(x, "[\n\r\t]"))

    x=""
    x <- rvest::html_nodes(player_profile_html, "div#ciHomeContent div#ciMainContainer div#ciHomeContentlhs div.pnl490M div.ciPlayernametxt div h3.PlayersSearchLink b")
    country <- as.character(rvest::html_text(x))

    x=""
    x <- rvest::html_nodes(player_profile_html, "div#ciHomeContent div#ciMainContainer div#ciHomeContentlhs div.pnl490M div div p.ciPlayerinformationtxt span")
    x <- rvest::html_text(x)
    x <- stringr::str_trim(stringr::str_remove_all(x, "[\n\r\t]"))

    fullname <- x[1]
    dob_place <- stringr::str_replace_all(x[2], ",", "|")
    age <- x[3]
    role <- x[length(x)-2]
    batting_style <- x[length(x)-1]
    bowling_style <- x[length(x)]

    #list2env( setNames(as.list(x[1], x[2], x[3], x[length(x)-2], x[length(x)-1], x[length(x)]),
    #                   as.list(fullname, stringr::str_replace_all(dob_place, ",", "|"), age, role, batting_style, bowling_style)),
    #          envir = .GlobalEnv)

    x=""
    x <- rvest::html_nodes(player_profile_html, "div#ciHomeContent div#ciMainContainer div#ciHomeContentlhs div.pnl490M table.engineTable tbody tr.data1 td")
    x <- rvest::html_text(x)

    batting_fielding_Test   <- x[2:15]
    batting_fielding_ODI    <- x[17:30]
    batting_fielding_T20I   <- x[32:45]
    batting_fielding_1st    <- x[47:60]
    batting_fielding_listA  <- x[62:75]
    batting_fielding_T20S   <- x[77:90]

    bowling_Test    <- x[92:104]
    bowling_ODI     <- x[106:118]
    bowling_T20I    <- x[120:132]
    bowling_1st     <- x[134:146]
    bowling_listA   <- x[148:160]
    bowling_T20s    <- x[162:174]

    player_profile_header   <- c("ShortName", "Country", "FullName", "DOB_Place", "Age", "Role", "Batting_Style", "Bowling_Style")
    batting_fielding_header <- c("Batting-Mat", "Batting-Inns", "Batting-NO", "Batting-Runs", "Batting-HS", "Batting-Ave", "Batting-BF", "Batting-SR", "Batting-100", "Batting-50", "Batting-4s", "Batting-6s", "Batting-Ct", "Batting-St")
    bowling_header          <- c("Bowling-Mat", "Bowling-Inns", "Bowling-Balls", "Bowling-Runs", "Bowling-Wkts", "Bowling-BBI", "Bowling-BBM", "Bowling-Ave", "Bowling-Econ", "Bowling-SR", "Bowling-4w", "Bowling-5w", "Bowling-10")

    x=""
    x <- tibble::data_frame("player_id" = rep(player_id, 27),
                            "short_name" = rep(shortname, 27),
                            "country" = rep(country, 27),
                            # "dob_place" = rep(dob_place, 27),
                            "age" = rep(age, 27),
                            "role" = rep(role, 27),
                            "batting_style" = rep(batting_style, 27),
                            "bowling_style" = rep(bowling_style, 27),
                            "feature" = c(batting_fielding_header, bowling_header),
                            "test"=c(batting_fielding_Test, bowling_Test),
                            "odi" = c(batting_fielding_ODI, bowling_ODI),
                            "t20i" = c(batting_fielding_T20I, bowling_T20I),
                            "firstclass" = c(batting_fielding_1st, bowling_1st),
                            "listA" = c(batting_fielding_listA, bowling_listA ),
                            "t20s" = c(batting_fielding_T20S, bowling_T20s)
    )
    readr::write_csv(x, filepath, append = TRUE, col_names = FALSE)
}
