from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
import os
import csv
import json
from pathlib import Path
from typing import List, Dict, Optional

app = FastAPI(title="Next.js FastAPI Template API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://frontend-dev:3000", "*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Hello from FastAPI!", "status": "API is running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "backend"}


@app.get("/")
async def root():
    return {"message": "Tiles API is running"}



@app.get("/health")
async def health_check():
    return {
        "status": "healthy!", 
        "service": "backend",
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)