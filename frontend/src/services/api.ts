import axios, { AxiosResponse } from 'axios';

// API response type definitions
interface DashboardData {
  [key: string]: any; // Adjust specific types to match actual API responses
}

interface ConsoleResponse {
  result?: string;
  error?: string;
  [key: string]: any;
}

const apiClient = axios.create({
  baseURL: '/api', // Set API base URL
  timeout: 1000, // Set timeout
  headers: {
    'Content-Type': 'application/json',
  },
});

// Function to fetch dashboard data
export const fetchDashboardData = async (): Promise<DashboardData> => {
  try {
    const response: AxiosResponse<DashboardData> = await apiClient.get('/dashboard');
    return response.data;
  } catch (error) {
    console.error('Error fetching dashboard data:', error);
    throw error;
  }
};

// Function to execute Rails console commands
export const executeConsoleCommand = async (command: string): Promise<ConsoleResponse> => {
  try {
    const response: AxiosResponse<ConsoleResponse> = await apiClient.post('/console/execute', { command });
    return response.data;
  } catch (error) {
    console.error('Error executing console command:', error);
    throw error;
  }
};
