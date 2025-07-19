"use client";

import { useState, useEffect } from "react";

export default function ApiTest() {
  const [message, setMessage] = useState("");
  const [status, setStatus] = useState("");
  const [error, setError] = useState<boolean | true>(true);


  useEffect(() => {
    const testApi = async () => {
      try {
        const response = await fetch("/api/test");
        const data = await response.json();
        setMessage(data.message);
        setStatus("API Connection Successful");
        setError(false);
      } catch (e) {
        setMessage("Failed to connect to API");
        setStatus("Connection Failed");
        setError(true);
      }
    };

    testApi();
  }, []);

  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold mb-2">API Test</h3>
        <svg className="w-4 h-4" viewBox="0 0 20 20">
          {/* Simple circle to indicate status */}
          <circle cx="10" cy="10" r="10" fill={error ? "red" : "green"} />
        </svg>
      </div>
      <p className="text-sm">
        <strong>Status:</strong> {status}
      </p>
      <p className="text-sm">
        <strong>Message:</strong> {message}
      </p>
    </div>
  );
}