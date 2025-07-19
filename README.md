# Next.js + FastAPI Dockerized Template

A modern, dockerized template for building full-stack web applications with Next.js (frontend) and FastAPI (backend).

## 🚀 Quick Start

### Development Environment

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd nextjs-fastapi-dockerized-template
   ```

2. **Start development environment**
   ```bash
   ./dev.sh
   ```
   Or manually:
   ```bash
   docker-compose -f docker-compose.dev.yml up --build -d
   ```

3. **Access the applications**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs

### Production Environment

1. **Start production environment**
   ```bash
   ./prod.sh
   ```
   Or manually:
   ```bash
   docker-compose up --build -d
   ```

## 📁 Project Structure

```
nextjs-fastapi-dockerized-template/
├── backend/                    # FastAPI backend
│   ├── api/
│   │   └── main.py            # Main FastAPI application
│   ├── Dockerfile             # Production Dockerfile
│   ├── Dockerfile.dev         # Development Dockerfile
│   └── requirements.txt       # Python dependencies
├── frontend/                   # Next.js frontend
│   ├── app/                   # Next.js app directory
│   │   ├── globals.css        # Global styles
│   │   ├── layout.tsx         # Root layout
│   │   └── page.tsx          # Home page
│   ├── public/               # Static assets
│   ├── Dockerfile.dev        # Development Dockerfile
│   ├── Dockerfile.prod       # Production Dockerfile
│   ├── package.json          # Node.js dependencies
│   ├── next.config.js        # Next.js configuration
│   ├── tailwind.config.js    # Tailwind CSS configuration
│   └── tsconfig.json         # TypeScript configuration
├── docker-compose.yml         # Production docker compose
├── docker-compose.dev.yml     # Development docker compose
├── dev.sh                     # Development startup script
├── prod.sh                    # Production startup script
└── README.md                  # This file
```

## 🛠 Technology Stack

### Frontend
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **ESLint** - JavaScript linting

### Backend
- **FastAPI** - Modern, fast web framework for Python
- **Python 3.11** - Programming language
- **Uvicorn** - ASGI server

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

## 🔧 Development

### Backend Development

The backend runs on port 8000 with hot reload enabled in development mode.

**Key endpoints:**
- `GET /` - Health check
- `GET /health` - Service status
- `GET /docs` - Swagger API documentation

**Adding new endpoints:**
Edit `backend/api/main.py` to add new API routes.

### Frontend Development

The frontend runs on port 3000 with hot reload enabled in development mode.

**Key files:**
- `frontend/app/page.tsx` - Main page component
- `frontend/app/layout.tsx` - Root layout component
- `frontend/app/globals.css` - Global styles

### Environment Variables

**Development:**
- `API_URL=http://backend:8000` (for frontend container communication)

**Production:**
- `NEXT_PUBLIC_API_URL=http://backend:8000` (for frontend to backend communication)

## 📦 Adding Dependencies

### Frontend Dependencies
```bash
# Enter the frontend container
docker exec -it <frontend-container-name> /bin/bash

# Install packages
npm install <package-name>

# Or add to package.json and rebuild
```

### Backend Dependencies
```bash
# Add to requirements.txt
echo "new-package==1.0.0" >> backend/requirements.txt

# Rebuild containers
docker-compose down
docker-compose up --build
```

## 🚢 Deployment

The production configuration is optimized for deployment with:
- Multi-stage Docker builds
- Optimized Next.js builds
- Production-ready FastAPI server

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in both development and production modes
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

1. **Port conflicts**: Make sure ports 3000 and 8000 are not in use
2. **Docker permission errors**: Ensure Docker daemon is running
3. **Module not found**: Rebuild containers after adding dependencies

### Useful Commands

```bash
# View container logs
docker-compose logs frontend-dev
docker-compose logs backend

# Rebuild specific service
docker-compose up --build frontend-dev

# Clean up containers and volumes
docker-compose down -v
docker system prune -a
```
