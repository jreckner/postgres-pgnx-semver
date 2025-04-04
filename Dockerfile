# Use the latest official PostgreSQL image
ARG PG_MAJOR=17
FROM postgres:${PG_MAJOR}

# Install dependencies for PGXN Client
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    postgresql-server-dev-${PG_MAJOR} \
    pgxnclient

# Install semver extension using PGXN Client
RUN pgxn install semver

# Clean up
RUN apt-get remove -y \
    build-essential \
    postgresql-server-dev-${PG_MAJOR} \
    pgxnclient && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the extensions to the PostgreSQL configuration
RUN echo "shared_preload_libraries = 'semver'" >> /usr/share/postgresql/postgresql.conf.sample

# Set the default command to run PostgreSQL
CMD ["postgres"]