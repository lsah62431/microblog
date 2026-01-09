##  Docker Architecture & Design Decisions



This project was designed to reflect real-world Docker usage in production.

### Container Design
- Each service runs in its own isolated container
- Stateless application container
- Externalized configuration using environment variables

### Networking
- Two Docker networks were used:
  - frontend: exposed to the internet via Nginx
  - backend: private network for internal communication only
- Database and cache are never exposed publicly

### Reverse Proxy Pattern
- Nginx acts as the single entry point
- TLS termination handled at the proxy level
- Application containers are unaware of the public internet

### Security
- No secrets baked into images
- HTTPS enforced at the proxy
- Secure headers configured
- Minimal container exposure

### Production Readiness
- Gunicorn used instead of Flask dev server
- Containers designed to restart safely
- Database migrations handled on startup
