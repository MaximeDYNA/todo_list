# 1️⃣ Base image
FROM python:3.11-slim

# 2️⃣ Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3️⃣ Set working directory
WORKDIR /app

# 4️⃣ Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# 5️⃣ Copy project files
COPY . .

# 6️⃣ Expose Django port
EXPOSE 8000

# 7️⃣ Run Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
