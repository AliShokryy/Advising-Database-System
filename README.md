![image](https://www.pwcs.edu/userfiles/servers/server_340140/image/student-services/school-counseling/academic_advising.png)

A comprehensive platform designed to serve both students and their advisors, providing multiple privileges to streamline the advising experience, all monitored through a sufficient admin dashboard.

## Table of Contents

- 🧑‍💻 [Tech Stack](#tech-stack)
- 🛫 [Main Features](#main-features)
  - [Admin Panel](#admin-panel)
  - Student Panel
  - Advisor Panel
- 🔨 [Try it on your Machine](#try-it-on-your-machine)

## Tech Stack🧑‍💻

![DOTNET](https://img.shields.io/badge/.NET_8-%20%23512BD4?style=for-the-badge&logo=dotnet&logoColor=white&labelColor=%23512BD4&color=%23512BD4)
![Static Badge](https://img.shields.io/badge/MSSQL-%23CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white&labelColor=%23CC2927&color=%23CC2927)
![Static Badge](https://img.shields.io/badge/Razor%20Pages-%23512BD4?style=for-the-badge&logo=blazor&logoColor=white&labelColor=%23512BD4&color=%23512BD4)

Here's a brief high-level overview of the tech stack the Well app uses:

- This project utilizes **ASP.NET** Core with .NET 8 as the target framework to manage the backend and route different HTTP requests.
- For the **DataBase**, we opted for Microsoft SQL Server to handle various CRUD operations (Create, Read, Update, and Delete) using SQL stored procedures and functions.
- **Razor Pages** were employed to streamline page-focused scenarios, offering enhanced productivity compared to using controllers and views due to the relative simplicity of the website.
- On the **FrontEnd**, we employed HTML, CSS, and Bootstrap, leveraging the Razor syntax to integrate C# instead of JavaScript, thus facilitating a smoother development process.

## Main Features🛫

The website offers various features and functionalities through the main three panels.

### Admin Panel

To access the admin panel, click on **Admin** in the bottom left corner, then log in with **ID = 1** and **Password = admin**, both of which are hardcoded.

![ACEESS_ADMIN]()

From the home page, the admin can navigate through the different sections via the top menu bar.

![SECTIONS]()

The admin can easily access different sets of information and view them in an organized tabular form.

![TABLES]()

Admin can also alter and modify the existing data by specifying the required parameters through the corresponding forms.

![FORMS]()

### Stduent Panel

### Advisor Panel

## Try it on your Machine🔨

1. cloning the repo on your local machine

   ``` bash
   git clone https://github.com/AliShokryy/Advising-Database-System
   ```