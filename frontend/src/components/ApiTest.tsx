"use client";

import { useState, useEffect } from "react";

export default function ApiTest() {
  const [message, setMessage] = useState("");
  const [status, setStatus] = useState("");

  useEffect(() => {
    const testApi = async () => {
      try {
        const response = await fetch("http://localhost:8000");
        const data = await response.json();
        setMessage(data.message);
        setStatus("API Connection Successful");
      } catch (error) {
        setMessage("Failed to connect to API");
        setStatus("Connection Failed");
      }
    };

    testApi();
  }, []);

  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
      <h3 className="text-lg font-semibold mb-2">API Test</h3>
      <p className="text-sm">
        <strong>Status:</strong> {status}
      </p>
      <p className="text-sm">
        <strong>Message:</strong> {message}
      </p>
    </div>
  );
}