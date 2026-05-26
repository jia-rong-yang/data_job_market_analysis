# Introduction
As someone new to the data field, I want to build a solid plan for a career-transition strategy: as a career changer, what should I know before actively hunting for a job? This analysis helps career changer like me to gain a overview of the Belgian Data Analyst and Business Analyst job market. 

SQL queries? Check them out of here: [sql_analysis](sql_analysis/)

# Background
I am mainly interested in Data Analyst (DA) and Business Analyst (BA) roles. This portfolio focuses on DA/BA roles in the Belgian market.
The questions I want to answer through my analysis are:
1. How many DA and BA job postings are there in Belgium, and how are these postings distributed across time and cities?
2. What skills are most commonly listed in DA and BA postings in Belgium, and how does the number of listed skills relate to degree requirements?
3. How complete is the salary information in Belgium DA/BA job postings, and is the available salary data sufficient for meaningful salary analysis?
4. Who are the top employers for DA and BA roles in Brussels and Leuven, and how concentrated are job opportunities among these employers?

# 🛠️Tools Used
In this project, all analytical decisions and interpretations are my own. AI tools were used to generate charts from my CSV outputs and chart instructions, and to support discussion during the analysis process.
- **SQL:** The core of this analysis, allowing me to query database and uncover critical insights
- **PostgreSQL:**  database building
- **Visual Studio Code:**  SQL file editing
- **ChatGPT and Anthropic Claude:**  troubleshooting, generating charts from CSV outputs, and discussing analysis logic. 
- **Git & GitHub:** version control 


# Data Preparation 
**Quality checks:** I show how I uploaded my dataset and performed quality checks before beginning the analysis. During this stage, many salary-related fields were identified as missing values. This is taken into account before further analysis.

**Time coverage:**
This dataset covers 2023-01-01 to 2025-06-30, so this portfolio focuses on that past period. The findings cannot represent the current moment, but they remain valuable for building an overall understanding of the market.


# 🔎Main Analysis
## 1. Market Overview 
### How many DA and BA job postings are there in Belgium?

| job_title_short | job_count | pct_of_sample |
|---|---:|---:|
| Business Analyst (BA) | 2101 | 22.06 |
| Data Analyst (DA) | 7421 | 77.94 |
| Total | 9522 | 100.00 |

 >*The dataset contains 9,522 DA and BA postings in total in Belgium. DA opportunities are more than three times those of BA. Scope note: All findings, shares, and percentages in the main analysis are based solely on DA and BA postings in Belgium.*

![quarterly job postings](assets\figure_01_quarterly_postings_bar_chart.png)
>**Quarterly trends:**
For quarterly trends, job postings remained relatively stable throughout 2023 and into Q1 2024. From Q2 2024 onward, postings declined. October and November 2024 show zero postings within this dataset. The reason for this gap is unclear. Q1 2025 returned to a similar level as 2023, but Q2 2025 dropped sharply, suggesting a decline after early 2025.

![monthly job postings](assets\figure_02_monthly_postings_bar_chart.png)

>**Monthly trends:**
For monthly trends, job postings are more active at the beginning of each year. To ensure that months with zero postings still appear in the bar chart, I created a complete calendar CTE and joined it with the job postings fact table based on the target roles.

### City-Level Distribution

The location format in the dataset is not uniform. Grouping directly by location name would produce messy and indistinguishable categories, so I used `CASE` to create clearly defined category labels.

| location_type | job_count | pct_per_location_type |
|---|---:|---:|
| city_level_location | 7874 | 82.69 |
| city_unspecified | 1324 | 13.90 |
| missing_location | 7 | 0.07 |
| region_or_province_level_location | 110 | 1.16 |
| remote_job | 207 | 2.17 |

>Most postings have identified city-level locations, which is sufficient to support city-level analysis. Some postings only indicate Belgium (13.9%) or a region (1.16%) without specifying a city; these groups are handled separately rather than removed. Remote jobs account for only 2.17% of postings, indicating that fully remote DA / BA roles are limited in this dataset.

| rank | cleaned_location | job_count | pct_per_city |
|---:|---|---:|---:|
| 1 | Brussels, Belgium | 2964 | 38.0 |
| 2 | Antwerp, Belgium | 781 | 10.0 |
| 3 | Mechelen, Belgium | 308 | 4.0 |
| 4 | Ghent, Belgium | 302 | 4.0 |
| 5 | Leuven, Belgium | 243 | 3.0 |
| 6 | Zaventem, Belgium | 181 | 2.0 |
| 7 | Saint-Gilles, Belgium | 102 | 1.0 |
| 8 | Liège, Belgium | 99 | 1.0 |
| 9 | Bruges, Belgium | 91 | 1.0 |
| 10 | Kortrijk, Belgium | 85 | 1.0 |

>Among city-level postings, Brussels accounts for 38% of DA/BA postings, nearly four times the share of Antwerp (10%), making it the primary hub for DA / BA roles in Belgium. Leuven ranks fifth with a 3% share, meaning it is visible in the rankings but limited in volume.


## 2. Common listed Skills And The Relationship Between Degree Requirement 
Since DA postings are more than three times those of BA, comparing the two roles by job volume alone could create a misleading impression. This comparison therefore focuses on distribution patterns and percentage-based indicators.
![job count per skill bin](assets\figure_03_job_count_per_skill_bin_pie_chart.png)
>**Share of listed skills:**
Both roles have the majority of postings in the first two skill count bins (0 and 1–3), suggesting that most postings list no more than 3 skills. The pie chart shows that both roles follow a similar distribution pattern across skill bins.

![job count and with degree job per bin](assets\figure_04_job_count_and_with_degree_job_per_bin.png)
>**Degree requirement across bins:**
For DA roles, the percentage of postings requiring a degree generally increases from bin 0 to bin 7–9, suggesting that postings listing more skills tend to have higher degree requirements. BA roles show a flatter trend, suggesting that the number of listed skills has a weaker relationship with degree requirements for BA than for DA. In the 7–9 bin, both roles approach a similar percentage. Beyond that point they diverge: the DA percentage drops in the 10+ bin, which might indicate some highly technical positions place more focus on practical skills than on formal education, while the BA percentage continues to rise slightly.

![Top_10_skills_per_role](assets\figure_05_top_10_skills_per_role.png)
>The ranking on the Y-axis follows the total skill count across both DA and BA roles, so the most frequently listed skills appear at the top. Both roles share a core foundation: SQL, Excel, and Power BI. For those planning to transition into a data-driven career, these three skills are highly valuable to learn. Overall, both roles require a shared data foundation, but with slightly different emphases: people targeting DA roles should prioritize SQL, Excel, Python, and Power BI; people targeting BA roles should prioritize SQL, Power BI, Excel, and SAP-related knowledge.


## 3. Salary Analysis

Salary information is largely absent from Belgium DA/BA postings, consistent with the earlier data quality check.

| salary_rate | count | percentage |
|---|---:|---:|
| hour | 1 | 0.01% |
| year | 28 | 0.29% |
| NULL | 9,493 | 99.70% |

Over 99% of postings contain no salary information. In this dataset, a NULL salary_rate always indicates the complete absence of salary data. With only 28 annual salary postings (0.29% of the total), the sample is too small to reliably represent the market. Salary analysis is therefore excluded from the main findings of this portfolio.


## 4. Top Employers by City

| cleaned_location | company_name | job_count_per_company | company_rank |
|---|---|---:|---:|
| Brussels, Belgium | Smals | 125 | 1 |
| Brussels, Belgium | AXA | 89 | 2 |
| Brussels, Belgium | Sandbag Climate Campaign | 80 | 3 |
| Brussels, Belgium | ENTSO-E | 62 | 4 |
| Brussels, Belgium | Belfius | 45 | 5 |
| Brussels, Belgium | Eyetech Solutions | 39 | 6 |
| Brussels, Belgium | NMBS-SNCB | 38 | 7 |
| Brussels, Belgium | Connect Consulting | 34 | 8 |
| Brussels, Belgium | Cream Consulting | 28 | 9 |
| Brussels, Belgium | Belfius Bank | 27 | 10 |

> Note: Sandbag Climate Campaign is a climate policy NGO. Its relatively high posting count may appear unexpected compared to its organizational profile, but the data is presented as-is from the source dataset.

| cleaned_location | company_name | job_count_per_company | company_rank |
|---|---|---:|---:|
| Leuven, Belgium | TOMRA | 21 | 1 |
| Leuven, Belgium | USG Professionals | 20 | 2 |
| Leuven, Belgium | Datashift | 13 | 3 |
| Leuven, Belgium | Telenet | 11 | 4 |
| Leuven, Belgium | Donaldson | 7 | 5 |
| Leuven, Belgium | Medpace, Inc. | 6 | 6 |
| Leuven, Belgium | SNCB | 6 | 7 |
| Leuven, Belgium | DPhi Tech | 6 | 8 |
| Leuven, Belgium | MEDPACE | 6 | 9 |
| Leuven, Belgium | beBee Careers | 5 | 10 |
> Note: Company names are based on the original dataset and may contain naming variations (e.g., Belfius / Belfius Bank, Medpace, Inc. / MEDPACE). Therefore, the employer counts should be interpreted as an approximate view of the market rather than a fully deduplicated company-level analysis.

![postings_per_company](assets\figure_06_postings_per_company.png)

>Brussels has a significantly larger DA / BA job market than Leuven. In the dataset, Brussels has 926 employers and 2,964 job postings, while Leuven has 97 employers and 243 job postings. The volume difference between the two cities is also visible in the bar chart: the top employer in Leuven, TOMRA, has 21 postings, still fewer than the 10th-ranked employer in Brussels, Belfius Bank, with 27 postings. 



![company_rank_long_tail_line_chart](assets\figure_07_company_rank_long_tail_line_chart.png)
>The long-tail chart supports this pattern: in both cities, a small number of employers post many jobs while the majority post only a few.
 - **In Brussels**, the top 10 companies account for 567 postings, representing 19.1% of all Brussels postings, with the remaining 80.9% distributed across other employers. 

 - **In Leuven**, the top 10 companies account for 101 postings, representing 41.6% of all Leuven postings. This suggests that opportunities in Brussels are spread across a much larger and more diversified employer base, while Leuven has a smaller and more concentrated market where a few employers have stronger influence. 


# What I Learned
Through this project, I strengthened both fundamental SQL skills and several more analytical techniques. The points below highlight the key skills that were most relevant to this analysis:
- Build a PostgreSQL database from raw CSV files and prepare the data for analysis.
- Use data quality checks to understand whether the dataset contains enough information to support meaningful insights and identify missing values and data gaps.
- Create a complete calendar CTE to make sure months with zero postings still appear in the trend analysis.
- Use `REGEXP_REPLACE` to clean unwanted text and standardize location strings.
- Use `CASE` expressions to create clearer location categories for analysis.
- Use window functions such as `ROW_NUMBER()OVER()` to rank job counts based on different grouped columns.


# Conclusion
- Data Analyst roles provide broader opportunities than Business Analyst roles in this dataset. DA postings account for a much larger share of the Belgian DA/BA job market.

- Brussels is the strongest job market for DA/BA roles in Belgium. It has the highest number of postings and offers the broadest range of opportunities, making it an important city for job seekers to consider.

- Remote work is limited in this dataset. Most DA/BA postings are tied to specific locations, so job seekers should pay attention to city-level job availability.

- Job seekers can use the city-level distribution query to check how many DA/BA postings are available in their own city. [Click here](https://github.com/jia-rong-yang/data_job_market_analysis/blob/main/sql_analysis/01_market_overview.sql#L130-L177)

- The top-employer query can also be reused for other cities. Although this project compares Brussels and Leuven, the same query can help job seekers identify major employers in their target location. [Click here](sql_analysis\04_top_employers_by_city.sql)

- SQL, Excel, and Power BI appear as common core skills for both DA and BA roles. For people transitioning into data-driven roles, these are the most worthwhile skills to prioritize first.

- Most postings list no more than three skills, suggesting that a focused foundation in the core skills may already be useful for exploring opportunities.


# Data Source

The dataset was provided by Luke Barousse. The data was collected systematically over two years using SerpApi, which retrieves structured job posting data from search engines across multiple platforms including LinkedIn, Indeed, and ZipRecruiter. The collection methodology is explained in his course video [SQL for Data Engineering](https://www.youtube.com/watch?v=UjhFbq4uU2Y&t=904s). The original dataset links [check here](https://github.com/lukebarousse/SQL_Data_Engineering_Course/blob/main/Projects/2_WH_Mart_Build/02_load_schema_dw.sql).
I would like to thank him for making this dataset freely available for learning and practice.