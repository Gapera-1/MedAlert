import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/auth.css";
import * as api from "../services/api";

import LoginForm from "../components/LoginForm";
import SignupForm from "../components/SignupForm";

function AuthPage({ setIsAuthenticated }) {
  const navigate = useNavigate();

  const [isSignup, setIsSignup] = useState(false);

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [email, setEmail] = useState("");
  const [loginEmail, setLoginEmail] = useState("");

  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  // ✅ LOGIN
  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    if ((!username && !loginEmail) || !password) {
      setError("Username/Email and password are required");
      return;
    }

    try {
      const response = await api.login(username, password, loginEmail);
      // Authentication successful - user is now logged in via backend
      setIsAuthenticated(true);
      navigate("/app"); // ✅ Smooth navigation
    } catch (error) {
      console.error("Login error:", error);
      const errorMessage = error.message || "An error occurred during login. Please try again.";
      setError(errorMessage);
      setSuccess("");
    }
  };

  // ✅ SIGNUP
  const handleSignup = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    if (!username || !password || !confirmPassword || !email) {
      setError("All fields are required");
      return;
    }

    if (password !== confirmPassword) {
      setError("Passwords do not match");
      return;
    }

    if (password.length < 8) {
      setError("Password must be at least 8 characters long");
      return;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      setError("Please enter a valid email address");
      return;
    }

    try {
      const response = await api.signup(username, password, email);
      setSuccess("Signup successful! You can now log in.");
      setError("");

      // Clear form
      setUsername("");
      setPassword("");
      setConfirmPassword("");
      setEmail("");

      setTimeout(() => {
        setSuccess("");
        setIsSignup(false);
      }, 2000);
    } catch (error) {
      setError(error.message || "Signup failed. Please try again.");
      setSuccess("");
    }
  };

  return (
   <div
  className="fixed inset-0 flex justify-center items-center min-h-screen bg-cover bg-center bg-no-repeat"
  style={{
    backgroundImage: "url('/images/Login_background.jpg')"  // use your real extension
  }}
>

      <div className={`auth-container ${isSignup ? "active" : ""}`}>
        
        <div className="form-box login">
          <LoginForm
            username={username}
            password={password}
            email={loginEmail}
            error={error}
            setUsername={setUsername}
            setPassword={setPassword}
            setEmail={setLoginEmail}
            handleLogin={handleLogin}
            setIsSignup={setIsSignup}
          />
        </div>

        <div className="form-box signup">
          <SignupForm
            username={username}
            password={password}
            confirmPassword={confirmPassword}
            email={email}
            error={error}
            success={success}
            setUsername={setUsername}
            setPassword={setPassword}
            setConfirmPassword={setConfirmPassword}
            setEmail={setEmail}
            handleSignup={handleSignup}
            setIsSignup={setIsSignup}
          />
        </div>

      </div>
    </div>
  );
}

export default AuthPage;