#!/bin/bash
set -e

echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting Django server..."
exec gunicorn todo_list.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120
