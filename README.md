# cricket


Usage:
The below code pulls country-wise player profile. 

Country code from below url. 
http://www.espncricinfo.com/story/_/id/18791072/all-cricket-teams-index

Country-wise player list from below url.
http://www.espncricinfo.com/india/content/player/country.html?country=<country code>



library(cricket)

countries <- countries()


for (country in countries) 

{

    players <- player_ids(country)
    
    for (player in players)
    
    {
    
        player_profile("<file path to store player profile>", player)
        
    }
    
}

