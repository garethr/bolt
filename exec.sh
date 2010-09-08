#! /bin/sh
echo "Running ls"
ls 2>&1

echo "Sleeping for 5 seconds"
sleep 5

echo "Running ps"
ps 2>&1

