'use client';

import { useState, useEffect } from 'react';

interface ApiStatus {
  message: string;
  status: string;
}

export default function ApiTest() {
  const [apiStatus, setApiStatus] = useState<ApiStatus | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchApiStatus = async () => {
      try {
        const response = await fetch('http://localhost:8000');
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setApiStatus(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch API status');
      } finally {
        setLoading(false);
      }
    };

    fetchApiStatus();
  }, []);

  if (loading) {
    return (
      <div className="p-4 border rounded-lg bg-gray-50 dark:bg-gray-800">
        <h3 className="font-semibold mb-2">API Connection Test</h3>
        <p className="text-sm text-gray-600 dark:text-gray-400">Loading...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4 border rounded-lg bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800">
        <h3 className="font-semibold mb-2 text-red-800 dark:text-red-200">API Connection Failed</h3>
        <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        <p className="text-xs text-red-500 dark:text-red-500 mt-1">
          Make sure the backend is running on port 8000
        </p>
      </div>
    );
  }

  return (
    <div className="p-4 border rounded-lg bg-green-50 dark:bg-green-900/20 border-green-200 dark:border-green-800">
      <h3 className="font-semibold mb-2 text-green-800 dark:text-green-200">API Connection Successful</h3>
      <p className="text-sm text-green-600 dark:text-green-400">
        <strong>Message:</strong> {apiStatus?.message}
      </p>
      <p className="text-sm text-green-600 dark:text-green-400">
        <strong>Status:</strong> {apiStatus?.status}
      </p>
    </div>
  );
}
