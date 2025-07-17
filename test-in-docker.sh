#!/bin/bash

echo "🐳 Building and starting Docker test environment..."
echo ""
echo "This will create a fresh Ubuntu container to test the devbox setup."
echo "Your actual system will not be affected."
echo ""

# Build and start the container
docker-compose up -d --build

echo ""
echo "✅ Container is ready! Connecting to test environment..."
echo ""
echo "You are now in a test Ubuntu system as user 'testuser'"
echo "To test the setup, run: ./bootstrap"
echo ""
echo "To exit: type 'exit'"
echo "To destroy the test environment: docker-compose down -v"
echo ""
echo "----------------------------------------"

# Connect to the container
docker exec -it devbox-test /bin/bash 2>/dev/null || echo "
To connect to the test environment, run:
docker exec -it devbox-test /bin/bash"