#!/bin/bash
# https://github.com/puma/puma/blob/master/docs/restart.md#hot-restart

source $HOME/.rvm/scripts/rvm

pumactl="bundle exec pumactl -F $HOME/consul/current/config/puma/production.rb -e production"

$pumactl status

read -p "Press enter for restarting the service"

$pumactl restart
