# NHL Home Ice Advantage Analysis
# Leo Fowler
# This project analyzes NHL home ice advantage using 2024-25 season data.
# It examines team-level home vs away performance, travel distance,
# and attendance as possible contributing factors.

library(dplyr)
library(ggplot2)
library(readr)
library(tibble)
library(scales)

# -------------------------
# Load data
# -------------------------
season_2024 <- read.csv("2024-25nhlseason.csv")

# Preview data
head(season_2024, 10)

# -------------------------
# Calculate team home and away wins
# -------------------------
season_2024 <- season_2024 %>%
  mutate(Winner = ifelse(G > G.1, Visitor, Home))

home_wins <- season_2024 %>%
  group_by(Home) %>%
  summarise(Home_Wins = sum(G.1 > G, na.rm = TRUE), .groups = "drop")

away_wins <- season_2024 %>%
  group_by(Visitor) %>%
  summarise(Away_Wins = sum(G > G.1, na.rm = TRUE), .groups = "drop")

team_wins <- full_join(home_wins, away_wins, by = c("Home" = "Visitor")) %>%
  rename(Team = Home) %>%
  mutate(
    Home_Wins = ifelse(is.na(Home_Wins), 0, Home_Wins),
    Away_Wins = ifelse(is.na(Away_Wins), 0, Away_Wins),
    Total_Wins = Home_Wins + Away_Wins
  ) %>%
  arrange(desc(Total_Wins))

head(team_wins, 10)

# -------------------------
# Calculate home and away win percentages
# -------------------------
team_wins <- team_wins %>%
  mutate(
    Home_Win_Pct = Home_Wins / 41,
    Away_Win_Pct = Away_Wins / 41,
    Home_Advantage = Home_Win_Pct - Away_Win_Pct
  )

team_wins %>%
  arrange(desc(Home_Advantage)) %>%
  select(
    Team, Home_Wins, Away_Wins, Total_Wins,
    Home_Win_Pct, Away_Win_Pct, Home_Advantage
  ) %>%
  head(10)

# -------------------------
# League-wide summary
# -------------------------
league_summary <- team_wins %>%
  summarise(
    League_Home_Win_Pct = mean(Home_Win_Pct),
    League_Away_Win_Pct = mean(Away_Win_Pct),
    Avg_Home_Advantage = mean(Home_Advantage)
  )

print(league_summary)

# -------------------------
# Plot: Home ice advantage by team
# -------------------------
ggplot(team_wins, aes(x = reorder(Team, Home_Advantage), y = Home_Advantage)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Home Ice Advantage by Team (Home - Away Win Percentage)",
    x = "Team",
    y = "Difference in Win Percentage (Home - Away)"
  ) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  theme_minimal(base_size = 12)

# -------------------------
# Travel distance data
# -------------------------
travel_dist <- tribble(
  ~Team, ~Travel_Miles,
  "Dallas Stars", 56700,
  "Florida Panthers", 51100,
  "Anaheim Ducks", 51000,
  "Edmonton Oilers", 50000,
  "Utah Hockey Club", 48700,
  "Seattle Kraken", 48200,
  "Winnipeg Jets", 48200,
  "Vegas Golden Knights", 45900,
  "Tampa Bay Lightning", 44500,
  "Calgary Flames", 44400,
  "Los Angeles Kings", 44100,
  "San Jose Sharks", 43400,
  "Montreal Canadiens", 43300,
  "Vancouver Canucks", 42500,
  "Buffalo Sabres", 42400,
  "Minnesota Wild", 42200,
  "Boston Bruins", 41600,
  "Colorado Avalanche", 41300,
  "Nashville Predators", 41100,
  "Chicago Blackhawks", 40700,
  "New Jersey Devils", 39900,
  "St. Louis Blues", 38700,
  "Toronto Maple Leafs", 37700,
  "Carolina Hurricanes", 36800,
  "New York Islanders", 36300,
  "Detroit Red Wings", 36100,
  "Washington Capitals", 35600,
  "Philadelphia Flyers", 35500,
  "New York Rangers", 35300,
  "Columbus Blue Jackets", 33400,
  "Ottawa Senators", 32800,
  "Pittsburgh Penguins", 31700
)

nhl_full <- team_wins %>%
  left_join(travel_dist, by = "Team")

nhl_away_dist <- nhl_full %>%
  select(Team, Away_Win_Pct, Travel_Miles)

head(nhl_away_dist, 10)

# -------------------------
# Plot: Away win percentage vs travel distance
# -------------------------
correlation <- cor(
  nhl_away_dist$Travel_Miles,
  nhl_away_dist$Away_Win_Pct,
  use = "complete.obs"
)

ggplot(nhl_away_dist, aes(x = Travel_Miles, y = Away_Win_Pct)) +
  geom_point(size = 3, color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red", linewidth = 1) +
  labs(
    title = "NHL Away Win Percentage vs Travel Distance (2024-25 Season)",
    subtitle = paste("Correlation =", round(correlation, 2)),
    x = "Total Travel Distance (Miles)",
    y = "Away Win Percentage"
  ) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray"),
    axis.title = element_text(face = "bold")
  )

# -------------------------
# Attendance analysis
# -------------------------
season_2024 <- season_2024 %>%
  mutate(Attendance_num = parse_number(as.character(Attendance)))

attendance_summary <- season_2024 %>%
  group_by(Home) %>%
  summarise(
    Avg_Attendance = mean(Attendance_num, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  rename(Team = Home)

nhl_attendance <- team_wins %>%
  left_join(attendance_summary, by = "Team")

cor_adv_att <- cor(
  nhl_attendance$Avg_Attendance,
  nhl_attendance$Home_Advantage,
  use = "complete.obs"
)

# -------------------------
# Plot: Attendance vs home advantage
# -------------------------
ggplot(nhl_attendance, aes(x = Avg_Attendance, y = Home_Advantage)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    title = "Home Advantage vs Average Home Attendance (2024-25 NHL Season)",
    subtitle = paste("Correlation =", round(cor_adv_att, 2)),
    x = "Average Home Attendance",
    y = "Home Advantage (Home Win Percentage - Away Win Percentage)"
  ) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray"),
    axis.title = element_text(face = "bold")
  )