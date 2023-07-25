###################################
# Dockerfile for the app container 
###################################

# Use an official Python runtime as the base image
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port on which the FastAPI application will run
EXPOSE 8000

# Run the FastAPI application using Uvicorn when the container starts
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
