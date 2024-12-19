# Use Rocker Shiny as base image
FROM rocker/shiny:latest

# Set environment variable to suppress interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required system dependencies (if needed)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages in one layer to optimize caching
RUN R -e "install.packages(c('shiny', 'dplyr', 'ggplot2', 'jsonlite'), repos='https://cloud.r-project.org/')"

# Copy project files to the Shiny Server directory
COPY . /srv/shiny-server/

# Set permissions for the Shiny Server directory
RUN chown -R shiny:shiny /srv/shiny-server

# Expose the default Shiny Server port
EXPOSE 3838

# Use the default Shiny Server run command
CMD ["/usr/bin/shiny-server"]
