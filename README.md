---
title: "Project: Asteria"
---

{r include = F}
knitr::opts_chunk$set(include = F)

Preface

The following article is an introspective journey through my experiences in data analysis and designing analytics systems. It serves as the cornerstone of my chosen data analyst. In previous projects, I encountered challenges and difficulties that provided valuable lessons. Analyzing these experiences, I realized that the process of designing and implementing analytics systems requires a balance between theory and practice. And as with any craft, balance is achieved only after spending hundreds of hours on a work. Therefore, in order to give it more pragmatism a side effect of this work will also be the design of application, which will be an improved version of its predecessors.

The main aspects I will take into consideration are:

Problem understanding

Data analysis

UX/UI

How it all started

Final stage of implementation for the main Excel dashboard. Source: Own work, 2019

The first data analytics project I undertook had a very pragmatic background. Specifically, my growing passion for sports, particularly strength sports at that time, led to the need for recording training results. Since I belong to the species of naked apes [@moris] living in the era of digitization, it was not appropriate to use a sheet of paper for this purpose.

Dashboard of the app made with shiny Source: Own work, 2022

The most obvious solution in this situation was Excel, and that's what I turned to. Initially, it was just a simple table where I manually entered the data. Over time, analyzing tabular data proved to be less and less effective and inefficient when planning the training schedule. So, new charts were added to the worksheet one after another. Over time, the charts evolved into increasingly complementary and comprehensive sets, organized with filters and timelines. I would now describe it as a dashboard. The method of entering data also changed - during my training sessions, I used a touch screen, which motivated me to develop a more effective method of entering new training records - I started experimenting with VBA. After months of iterative ad hoc improvements of my excel application, I obtained a satisfying tool for that time.

Visualization of the third consecutive version of the training analysis tool - a blank slate </br> Source: Own work, 2024

During my third semester of studies, I heard that a "true analyst can only react to the word 'Excel' with a snort or pity." This is how I began learning programming in R. I learned the fundamentals of this language in a statistics course and liked it so much that I began a course on DataCamp and immediately started learning to create analytics applications. As my first project, which was supposed to encompass everything I had learned in the course, I chose to re-implement the excels' training tool . After a few weeks of reading documentation and rewriting functions line by line, I succeeded in accomplishing my goal.

Is it really Excel?

One of the key elements of Excel is its user interface, which is relatively intuitive and easy to use. It is undoubtedly the driving force behind Excel's phenomenal success and the era of spreadsheets. However, it is also Excel's Achilles' heel, as it prevents it from being taken seriously. When dealing with more complex data structures and mathematical models, one must either learn another analytic environment or engage in masochistic work and have prophetic nightmares of a corrupted workbook.

Close look up at the app - objective of analysis below.</br> Source: Own work, 2019

It's time to take a closer look at the unearthed desktop after years and try not to collapse under the influx of crimes that assault the eyes one after another. At first glance, the desktop appears relatively neat and promises a rich information pill that we will be able to read from visualizations time and time again. Nothing could be further from the truth!

Objective and ananalytic problem

In this case, the objective takes on an amorphous form resembling "The table is boring, let's change it." - quite close to previous thought. At this stage, it can already be concluded that the end product will take the form of an equally amorphous entity that fulfills essential needs.

Steve Jobs, citen in NYC The Guts of a New Machine

Design is not just what it looks like and feels like. Design is how it works.

Without a clearly defined objective, no subsequent puzzle piece will fit. Formulating questions to be answered will be done in a chaotic, unstructured manner. And although using this method of creative exploration, once every dozen... dozens... depending on luck and intuition, we ask a question that actually allows us to go in the right direction (i.e., one that satisfactorily fulfills our undefined needs), we can by no means talk about the effectiveness, let alone the high efficiency, of such an approach. Especially since at that stage, I didn't know that asking questions and formulating hypotheses is an iterative process based on gathering the right data, analyzing it, and then drawing conclusions that may eventually allow us to break out of this loop[@biecek2016].

Design Concerns

Design is a complex term, and in its most extensive definition, it includes defining business and analytical problems [@bigbook]. For the purposes of this article, however, it will be narrowed down to the following factors:

Information Architecture

UX & UI

Data Presentation

Information Architecture

As I mentioned, the application initially appears very aesthetic, but in this case, this does not align with any other desired factors. The information architecture (in this case, the layout of the charts) is fairly logical. The user, starting their analysis from the top-left corner, first sees the general progress in total training volume—a roughest measure of training effectiveness. Next, there is information available in a bar chart about the average load per training session. Here, the first inconvenience arises: the ability to correlate the first chart with the second is hindered by their different layouts and sizes. The next chart is a pie chart showing the distribution of exercises—while the idea behind this choice is understandable, the selection of location and type of chart is quite unfortunate. The penultimate chart shows the relationship between sets and repetitions in the form of line charts, which is relatively well positioned (i.e., on the side due to its secondary nature in the overall concept). Isolated from all other charts is the Hall of Fame with the best results by exercise, which actually deserves its own dashboard. Lastly, the filters—chaotically integrated into various parts of this mosaic—are the least effective feature.

Key observations

Unconsidered Layout of Key Information

Lack of Consistency in Filter Sections (failure to maintain a logical hierarchy of filtering)

Integration of Disparate Information

Inconsistency in Information Weight vs. Utilized Space

UX & UI

Despite many design errors, the app also contains many advantages, such as separate data entry form that ensure sonsistency and correctness. </br> Source: Own work, 2019

The interface uses a dark color palette contrasted with yellow and white elements. While this color scheme is visually striking, drawing attention to key data points, its actual functionality is questionable. The yellow accents are intended to highlight important information against the dark background, improving readability; however, this effect is weakened by the excess of other visual stimuli. The interface features various forms of data visualization, such as line, bar, and pie charts. Each of these forms is valid for presenting trends, distributions, or proportions, but their abundance and proximity mean the user needs to spend more time understanding the presented information. The use of simple, minimalist icons (e.g., dumbbells, medals) is intended for quick identification of the type of data presented. The gym-themed background adds thematic coherence but does not support data readability and may even be distracting.

Key observations

The color scheme draws attention to key points.

Yellow accents improve readability but are diminished by poor application.

Excess visual stimuli hinder information reception.

The abundance of charts requires more time for analysis.

The gym theme may distract from data readability.

Data Presentation

Paradoxically, this is the weakest point of the discussed application. Data is only partially labeled, creating illusions of drawing good conclusions. The minimalist style often means the only elements besides the title and a small auxiliary axis are the chart markers (bars, points, lines). Only by hovering over a specific value (which is neither intuitive nor simple) can detailed data be read. The choice of charts is generally good; however, the pie chart completely disrupts this aesthetic, introducing only chaos and focusing the user's attention on irrelevant elements.

Key observations

Lack of data labels

Lack of clear axes

Sparse descriptions

Unreadable icons

Minimal informational value per chart

Inconsistency in chart design

In summary, there is a lot of work ahead of me... :)

R Shiny - New Environment, Old Mistakes

Having already assessed the strengths and weaknesses of the Excel dashboard, I decided to develop a new, presumably better application using more advanced tools—functional, object-oriented, and reactive programming, in short - R.

The R application repeats nearly all the mistakes of its predecessor.. </br> Source: Own work, 2022

As shown in the attached image, I drew significant inspiration from the previous application, but I incorporated several minor improvements such as switches between charts, data drilling mechanisms, and a much better filtering section. However, the application still had a large number of errors, which affected its overall usability.

Another aspect that was evident with Excel is data management. In the spreadsheet, everything is clear—it serves as both a database and a sandbox for data processing. Power Query was obviously an overkill, as it doesn't work well with cloud solutions and its implementation in MS Excel is underdeveloped. On the other hand, R combined with Shiny offers virtually unlimited possibilities. Nevertheless, at this stage, I decided to simplify the project and create a local data source that will be overwritten each time.

A Bit of Theory and..

And so we arrive at the present moment (2024), after reviewing dozens of scientific articles, essays, and entire books, and acquiring invaluable practical knowledge, I am moving on to designing the third version of the dashboard.

Objectives

The new dashboard's task will be to support users in making decisions while planning their workouts. Therefore, the dashboard should be primarily understandable—presenting data as close to reality as possible, without being convoluted, but clear and readable. No excessive statistics, sophisticated graphics, or overwhelming amounts of data. Functionality should align with heuristics and motivate continued exercise. The assumption of a regular user also necessitates simple yet effective privacy and security mechanisms that do not compromise data accessibility and functionality.

The core requirements of the application will thus include the following functionalities:

Workout Data Overview

Basic Statistics: Displaying key information such as workout duration, intensity, calories burned, etc.

Workout History: Allowing users to review previous workout sessions with the ability to compare results.

Workout Goals: Visualizing progress towards set goals, such as the number of workouts per week or achieved fitness levels.

User Interface

Simple and Intuitive Design: The interface should be easy to navigate, with a clear layout of information and minimal data overload.

Data Readability: Using simple charts, diagrams, or progress bars to present data in an accessible manner.

Customizable View: Allowing users to adjust the dashboard view, e.g., selecting which data to display.

Motivation and Heuristics

Motivational Messages: Displaying positive messages and suggestions to encourage continued workouts.

Simple Indicators: Intuitive progress indicators without unhealthy mechanisms of instant progress.

Security and Accessibility

Secure Data Storage: User data should be stored securely, with encryption considerations.

Data Management: Allowing users to edit or delete personal and workout data.

Quick Access: Utilizing cloud solutions for data storage.

Technologies and Methodology

CRISP-DM (methodology):

CRISP-DM (Cross Industry Standard Process for Data Mining) is a standard methodology used in data analytics projects. It includes stages such as business understanding, data understanding, data preparation, modeling, evaluation, and deployment. Its application ensures a structured approach to the project, enabling more effective management of the data analysis process. [@crisp]

Shiny: Shiny is a framework in R that enables the creation of interactive web applications. Using Shiny allows for the rapid development of dashboards with an intuitive interface where users can interact with data in real-time. This is ideal for analyzing workout data, where flexibility in searching and visualizing data is required.

Bootstrap: Bootstrap is a popular CSS framework that facilitates the design of responsive and aesthetically pleasing user interfaces. Utilizing Bootstrap allows for the quick creation of elegant and functional UI elements on the dashboard, which is important for ensuring good usability of the application.

MongoDB: MongoDB is a popular database that handles data in JSON-like document format. It is particularly well-suited for storing large volumes of data with diverse structures, which can be useful for workout data. It allows for rapid data insertion and retrieval, as well as horizontal scaling, which is advantageous for growing datasets.

Llama 3.1: Llama 3.1 is a language model (Large Language Model) created by Meta that can be used for text generation or summarizing data. It is both lightweight and efficient, allowing for advanced text analysis with satisfactory levels of comprehension and repeatability.

Dashboard Mock-up

Given the previously mentioned aspects, we can proceed to the design of the dashboard. The first dashboard will be the data management dashboard. This is the most fundamental dashboard—therefore, it should primarily provide all the necessary information at this stage and be as user-friendly as possible.

The application design, based on the documented requirements, allows for determining the layout of information at a very high level.. </br> Source: Own work, 2024

Its core functionalities will include data management and simple analysis based on historical data to plan a workout session. The current workout session is a key element, so all functionalities should support this aspect to maximize its utility.

The final design has been slightly modified to include AI functionality as part of the workout history information. This maintains the continuity of the data hierarchy, and placing the functionality in the lower right corner indicates its lesser importance (as it is an enhancement, not a core feature) compared to the others. </br> Source: Own work, 2024

Here is how the design looks after implementation in the chosen environment. When defining a workout, a preview of historical data is available on the right, with a red-highlighted point representing the planned workout. This allows the user to easily relate to the context. Additionally, further to the right, there are two simple percentage indicators reflecting the progress of the workout in relation to the entire history—this keeps progress constantly visible and prevents the user from feeling pressured to continuously increase training intensity for progress. Breaking down progress into two factors further enhances motivation and awareness of progress. At the bottom, there is a queue where workouts from the current session are temporarily stored with the option to save them to the main training database.

The color scheme used is cohesive and highlights the most important elements of the dashboard. The current workout information stands out prominently, while historical data takes a secondary role. If there is a need to focus on individual visualizations, users always have the option to enlarge the visualization window.

From a technical perspective, data is stored in the MongoDB cloud, while the current session is saved locally. This approach ensures high performance and scalability by maintaining minimal latency, high availability, and user convenience. The two-step record addition sequence guarantees data accuracy by preventing accidental changes to the registry.

Additionally, the AI feature using Llama 3.1 allows for the analysis of workout data and the generation of recommendations by the AI agent. This way, users can be supported by a virtual trainer who can identify stagnation, risky increases in load, incorrect training patterns, or offer advice on improving technique or diversifying exercises, beyond just relying on raw numbers.

Other dashboards

tbd...

