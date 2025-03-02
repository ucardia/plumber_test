FROM rocker/tidyverse

RUN apt-get update && apt-get upgrade -y && apt-get clean

RUN apt-get install -y \
            libssl-dev \
            libcurl4-openssl-dev \
            libsecret-1-dev \
            libsodium23 \
            libmagick++-dev \
            && apt-get clean


# Install Packages
RUN install2.r devtools plumber RMariaDB DBI tidyverse glue lubridate httr ggplot2 cowplot gridExtra ggtext magick ggwordcloud

RUN R -e "devtools::install_github('teunbrand/elementalist')"


# Copies  files in this directory to files in container
COPY ["./", "./"]

EXPOSE 8080

# Start R-powered service
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(rev(commandArgs())[1]); args <- list(host = '0.0.0.0', port = 8080); if (packageVersion('plumber') >= '1.0.0') { pr$setDocs(FALSE) } else { args$swagger <- FALSE }; do.call(pr$run, args)"]

# Run
CMD ["main.R"]