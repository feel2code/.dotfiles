#!/bin/bash

SESH="dev"

tmux has-session -t $SESH 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $SESH -n "term"
  tmux send-keys -t $SESH:term "clear" C-m

  tmux new-window -t $SESH -n "dags"
  tmux send-keys -t $SESH:dags "cd ~/projects/dags" C-m
  tmux send-keys -t $SESH:dags "source venv/bin/activate" C-m
  tmux send-keys -t $SESH:dags "vim" C-m

  tmux new-window -t $SESH -n "clickhouse"
  tmux send-keys -t $SESH:clickhouse "clickhouse-client" C-m

  tmux new-window -t $SESH -n "postgres"
  tmux send-keys -t $SESH:postgres "exec ~/.postgres-client/psql.sh" C-m

  tmux new-window -t $SESH -n "python"
  tmux send-keys -t $SESH:python "python" C-m

  tmux select-window -t $SESH:term

fi

tmux attach-session -t $SESH
