FROM ruby:3.0

WORKDIR /rubackse
COPY . /rubackse
RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
