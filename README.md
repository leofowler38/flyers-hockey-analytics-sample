# Flyers Hockey Analytics Sample

## Overview
This project analyzes home ice advantage in the NHL using 2024-25 season data. The analysis focuses on team-level home versus away performance and explores whether travel distance, fan attendance, and rule-based factors help explain differences in outcomes.

## Motivation
I am interested in hockey analytics because hockey has been a major part of my life for years, and I want to build a career applying statistics and data science to the sport. This project reflects that interest by using data to investigate a strategic question that is directly relevant to team performance.

## Research Question
To what extent does home ice advantage affect NHL games, and to what extent do travel, fans, and rule-based advantages contribute to that effect?

## Data Sources
- NHL game-level data from the 2024-25 season
- Attendance data from Hockey Reference
- Team travel distance data
- Faceoff data from Hockey Elo Ratings

## Methods
- Cleaned and analyzed NHL game-level data in R
- Calculated home wins, away wins, and team-level win percentages
- Created a home advantage metric based on the gap between home and away win percentage
- Joined travel distance and attendance data to team performance data
- Used exploratory visualizations to evaluate team-level patterns
- Applied a Bradley-Terry model to study attendance and home win probability
- Used logistic regression to evaluate whether travel distance affected away win probability
- Analyzed faceoff win percentage differences when players put their stick down first versus last

## Key Findings
- Home ice advantage clearly exists in the NHL
- Home teams won at a higher rate than away teams across recent seasons
- Travel distance showed only a small and statistically insignificant relationship with away win probability
- Attendance showed a weak relationship in exploratory analysis, but the Bradley-Terry model suggested a measurable home advantage when teams are evenly matched
- Faceoff rules provided a small but meaningful edge to the team putting its stick down last, which is often the home team

## Repository Contents
- `home-ice-advantage-analysis.R` — cleaned R script for the project
- `home-ice-advantage-analysis.Rmd` — R Markdown version showing the workflow and analysis
- `NHL-Home-Ice-Advantage-Deck.pdf` — presentation summarizing the project
- `home-ice-advantage-report.pdf` — written report with full methodology and conclusions

## Future Work
A natural next step would be extending this project with player and puck tracking data to study how positioning, spacing, and off-puck movement influence possession quality, offensive zone efficiency, and scoring probability.

## Author
Leo Fowler
