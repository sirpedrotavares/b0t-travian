#!/bin/bash 
kill -9 $(ps aux | grep 'ruby b0t.rb' | awk '{print $2}')
