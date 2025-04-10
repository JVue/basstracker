FROM ruby:latest

# set timezone to central usa
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN gem install pg json sinatra sinatra-contrib sinatra-namespace redis rackup puma

RUN mkdir /basstracker

# Copy necessary files to container
COPY . /basstracker

WORKDIR /basstracker

# Set entry point
ENTRYPOINT ["/usr/local/bin/ruby"]

# Command to execute
CMD ["./app.rb"]

EXPOSE 8081
