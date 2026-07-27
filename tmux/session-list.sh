#!/bin/sh
tmux list-sessions -F '#{session_name} #{session_attached}' | sort -f | awk '{if($2==1) printf "#[bold,fg=yellow][%s]#[default] ", $1; else printf "[%s] ", $1}'
