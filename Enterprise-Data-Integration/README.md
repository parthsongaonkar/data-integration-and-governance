# Enterprise Data Integration

## Overview
This section covers the design and implementation of a 
star schema data warehouse using MySQL, with an ETL 
pipeline built in Pentaho Data Integration.

## Folder Structure
| Folder | Contents |
|--------|----------|
| `mysql-files/` | All SQL scripts for database and queries |
| `dataset/` | Raw dataset used for analysis |
| `Report/` | Full written report |
| `Presentation/` | PowerPoint presentation |
| `Data-flow-architecture/` | Data flow architecture diagram |
| `Data-Strategy-Canvas/` | Data strategy canvas diagram |
| `Dimension-model-design/` | Dimension model design for all the tables |

## Tools Used
- MySQL 8.0
- Pentaho Data Integration (PDI)

## Key Findings
### Query 1 — Who are the key customers? 
•	The International market has the largest group of customers with the highest subscription revenue of USD 9,878.48 and the highest margin of USD 125,893.51.
•	The Rest of Australia is moderately contributing and Victoria has the least revenue and profitability among the three segments.
•	These findings imply that resources are to be allocated and marketing campaigns made towards international markets. The poor performance of Victoria as a segment offers the strategic chance of targeted improvement efforts to improve the overall organisational performance. 

### Query 2 — Which products are the most profitable?
•	The types of products that are most profitable are determined in this analysis to inform product investment and strategy.
•	Results indicate that the most profitable in absolute terms with the highest total margin of USD 52,427.74 are the Audio Books and then Films. Music shows the greatest percentage of margin but with a relatively lower total margin even with high order volume - a major difference that the management should look into when comparing the performance of the categories.
•	These results form a clear basis of prioritisation. The most important area to maximise absolute revenue and profit should be on the Audio Books. Music is one of the efficiency opportunities that the organisation should capitalise. Further drilling down to most lucrative types of Audio Books products will contribute to highest profitability.

### Query 3 — Which store locations are the most profitable?
•	The analysis identifies the most profitable stores in terms of their margin percentage in order to facilitate location based performance measurement and tactical decision making.
•	Findings indicate that Naples20 in Italy under the EMEA division is the most profitable store of the overall with the highest margin percentage of 50.01 indicating good performance of the EMEA region. Among Australian stores Perth6 is the best performer with a margin percentage of 48.90 and several other Perth stores also feature as the best stores in the country.
•	These results point to two strategic areas already performing well in terms of results, EMEA and Perth. The potential to repeat what is working in low performing stores and still take advantage of the high performing stores to push profitability at the organisational level is evident.

### Query 4 — Which time periods are the most profitable?
•	The analysis helps in determining the most profitable times to assist seasonal planning and performance measurement.
•	Results indicate that January was the most profitable month with the highest sales of USD 32,489.14 and high margin percentage. The highest sales of USD 60,822.75 is registered in Q1 on a quarterly basis showing a good year beginning. The percentage of margin is not significantly varied in all the four quarters implying that profitability differences are influenced by volume and not efficiency.
•	The findings allow the organisation to target marketing campaigns, promotions and inventory planning on the high performing months like January and Q1 and optimise the use of seasonal patterns to make the most of the resource utilisation during the low activity periods.

### Query 5 — Which market is the most profitable?
•	This analysis helps in determining the most profitable market to aid in strategic decisions in relation to market focus and resource allocation.
•	Unexpected outcomes indicate that the International market is the most lucrative that makes the highest sales of USD 282,929.92 and margin USD 125,893.51 by a large margin as compared to Rest of Australia and Victoria. Though the margin percentages are comparable in all the three markets, the International market has a very high sales volume which contributes to its high profitability.
•	These results suggest that the most direct way of maximising returns is through international expansion and investment. The rising domestic market performance can be another opportunity to improve the overall organisational profitability.
