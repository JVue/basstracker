# basstracker

A web app for tracking bass fishing tournament weights.

## Running with Docker Compose

### Prerequisites
- Docker
- Docker Compose

### Setup

1. Copy the Docker env file and fill in your values:
   ```
   cp env.docker env.docker
   ```
   Edit `env.docker` with your credentials before starting.

2. Start all services (app, PostgreSQL, Redis):
   ```
   docker compose up --build
   ```
   The app will be available at http://localhost:8081/basstracker/submit.

3. To run in the background:
   ```
   docker compose up --build -d
   ```

4. To stop:
   ```
   docker compose down
   ```

5. To stop and wipe the database volumes:
   ```
   docker compose down -v
   ```

### Environment Files

| File | Purpose |
|------|---------|
| `env.docker` | Used by Docker Compose — points to `postgres` and `redis` service hostnames |
| `env.local` | Used for running the app locally — points to `localhost` and your local Redis IP |

### Building the image only

```
docker build -t basstracker .
```

### Rebuilding after code changes

```
docker compose up --build
```
