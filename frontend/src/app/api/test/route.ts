import { NextRequest, NextResponse } from 'next/server';

export async function GET() {
  try {
    // Use the API_URL environment variable or default to backend container name
    const apiUrl = process.env.API_URL || 'http://backend-dev:8000';
    
    
    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    
    return NextResponse.json(data);
  } catch (error) {
    console.error('API proxy error:', error);
    return NextResponse.json(
      { 
        message: 'Failed to connect to backend API',
        status: 'Connection Failed',
        error: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    );
  }
}