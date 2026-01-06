// API service for communicating with Django backend
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api';

/**
 * Helper function to handle API responses
 */
async function handleResponse(response) {
  if (!response.ok) {
    let errorData;
    const contentType = response.headers.get('content-type');
    
    // Try to parse JSON response
    if (contentType && contentType.includes('application/json')) {
      try {
        errorData = await response.json();
      } catch (e) {
        errorData = { detail: `Server error (${response.status}): ${response.statusText}` };
      }
    } else {
      // If not JSON, try to get text
      try {
        const text = await response.text();
        errorData = text ? { detail: text } : { detail: `HTTP error! status: ${response.status}` };
      } catch (e) {
        errorData = { detail: `HTTP error! status: ${response.status}` };
      }
    }
    
    // Handle Django REST Framework validation errors
    if (errorData.detail) {
      throw new Error(errorData.detail);
    }
    
    // Handle field-specific validation errors
    if (typeof errorData === 'object' && errorData !== null) {
      const errorMessages = [];
      for (const [field, messages] of Object.entries(errorData)) {
        if (field === 'detail') continue; // Already handled above
        if (Array.isArray(messages)) {
          errorMessages.push(`${field}: ${messages.join(', ')}`);
        } else if (typeof messages === 'string') {
          errorMessages.push(`${field}: ${messages}`);
        } else if (messages !== null && typeof messages === 'object') {
          errorMessages.push(`${field}: ${JSON.stringify(messages)}`);
        }
      }
      if (errorMessages.length > 0) {
        throw new Error(errorMessages.join('; '));
      }
    }
    
    throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
  }
  
  // Handle successful response
  const contentType = response.headers.get('content-type');
  if (contentType && contentType.includes('application/json')) {
    return response.json();
  } else {
    // If response is not JSON, return text or empty object
    const text = await response.text();
    return text ? { message: text } : {};
  }
}

/**
 * Fetch all medicines
 */
export async function fetchMedicines() {
  const response = await fetch(`${API_BASE_URL}/medicines/`);
  return handleResponse(response);
}

/**
 * Create a new medicine
 */
export async function createMedicine(medicine) {
  const response = await fetch(`${API_BASE_URL}/medicines/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: medicine.name,
      times: medicine.times,
      posology: medicine.posology,
      duration: medicine.duration,
    }),
  });
  return handleResponse(response);
}

/**
 * Update a medicine
 */
export async function updateMedicine(id, updates) {
  const response = await fetch(`${API_BASE_URL}/medicines/${id}/`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(updates),
  });
  return handleResponse(response);
}

/**
 * Delete a medicine
 */
export async function deleteMedicine(id) {
  const response = await fetch(`${API_BASE_URL}/medicines/${id}/`, {
    method: 'DELETE',
  });
  if (!response.ok) {
    const error = await response.json().catch(() => ({ detail: 'An error occurred' }));
    throw new Error(error.detail || error.message || `HTTP error! status: ${response.status}`);
  }
  return null;
}

/**
 * Mark a specific time as taken for a medicine
 */
export async function markMedicineTaken(id, time) {
  const response = await fetch(`${API_BASE_URL}/medicines/${id}/mark_taken/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ time }),
  });
  return handleResponse(response);
}

/**
 * Mark a medicine as completed
 */
export async function markMedicineCompleted(id) {
  const response = await fetch(`${API_BASE_URL}/medicines/${id}/mark_completed/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
  });
  return handleResponse(response);
}

/**
 * Register a new user
 */
export async function signup(username, password, email = '') {
  // Only include email if it's not empty
  const body = { username, password };
  if (email && email.trim()) {
    body.email = email.trim();
  }
  
  const response = await fetch(`${API_BASE_URL}/auth/signup/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  return handleResponse(response);
}

/**
 * Login a user (can use username or email)
 */
export async function login(username, password, email = '') {
  // Only include email if it's provided and not empty
  const body = { password };
  if (username && username.trim()) {
    body.username = username.trim();
  }
  if (email && email.trim()) {
    body.email = email.trim();
  }
  
  const response = await fetch(`${API_BASE_URL}/auth/login/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  return handleResponse(response);
}

