## Device Status Monitoring System
### Project Overview

This project involves the development of a Dockerized Python and Perl script that periodically reads data from CSV files and generates a detailed analysis based on specific instructions. The purpose of this analysis is to monitor device and card status across a system, identifying critical metrics related to device performance and potential overheating.

The analysis includes determining key metrics, such as:

- The total number of devices and cards.

- The maximum card temperature and the hottest card and device.

- Specific properties for each device, such as:

- - The number of cards.

- - The count of cards with a temperature above 70°C.

- - The maximum temperature for each card.

- - The average temperature across all cards.

The output of the analysis is generated in HTML format, providing a clear report with easy-to-read data visualizations. This solution is Dockerized to ensure consistency and ease of deployment across various environments.

### Features:

Automated Data Analysis: The script periodically reads CSV files and processes data related to device and card temperatures.

Temperature Monitoring: Highlights cards with temperatures above 70°C and provides insights into maximum and average temperatures.

Comprehensive Reporting: Generates an HTML report summarizing key findings, including metrics like the hottest device and card, temperature averages, and more.

Dockerized: The project is containerized using Docker, ensuring smooth deployment and consistent runtime environments.
