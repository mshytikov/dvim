FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ack-grep \
    build-essential \
    git \
    libncurses5-dev \
    libpython3.6 \
    python3-dev \
    python3-pip \
    ruby \
    ruby-dev \
    tmux

RUN gem install rake \
    && gem install rubocop \
    && pip3 install flake8

RUN git clone --depth 1 https://github.com/vim/vim.git \
 && cd vim && ./configure \
   --with-features=huge \
   --enable-rubyinterp \
   --enable-python3interp \
   --enable-perlinterp \
   --enable-luainterp\
   make VIMRUNTIMEDIR=/usr/share/vim/vim81 && \
   make install \
 && cd .. && rm -rf vim

RUN adduser --disabled-password --gecos "" -uid 1001 rat

USER rat
WORKDIR /home/rat

RUN git clone --depth 1 --recursive \
    https://github.com/carlhuda/janus.git .vim \
    && cd .vim && rake && rm -rf .git/

RUN mkdir .janus && cd .janus && git clone https://github.com/benmills/vimux.git

RUN ln -s  /dotfiles/vim/.vimrc.after   /home/rat/.vimrc.after  && \
    ln -s  /dotfiles/vim/.vimrc.before  /home/rat/.vimrc.before && \
    ln -s  /dotfiles/ack/.ackrc         /home/rat/.ackrc

USER root
RUN apt-get remove -y \
    build-essential \
    libncurses5-dev \
    python3-dev \
    python3-pip \
    ruby-dev \
    && apt-get autoremove -y

CMD vim
