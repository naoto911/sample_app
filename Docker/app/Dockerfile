FROM ruby:2.6.5

# 必要なライブラリインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
  apt-get install nodejs

# imagemagickをインストール
RUN apt-get update -qq && apt-get install -y imagemagick 

# vimをインストール
RUN apt-get install -y vim

RUN mkdir /sample_app
WORKDIR /sample_app
COPY Gemfile /sample_app/Gemfile
COPY Gemfile.lock /sample_app/Gemfile.lock
RUN bundle install
COPY . /sample_app

# 2/17 追記
RUN mkdir -p tmp/sockets

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]