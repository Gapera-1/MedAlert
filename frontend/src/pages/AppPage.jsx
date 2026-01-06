
import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import MedicineForm from '../components/MedicineForm';
import MedicineList from '../components/MedicineList';
import Snackbar from '../components/Snackbar';
import ReminderChecker from '../ReminderChecker';
import useMedicineStore from '../store/useMedicineStore';

function AppPage({ setIsAuthenticated }) {
  const navigate = useNavigate();
  const fetchMedicines = useMedicineStore((state) => state.fetchMedicines);
  const loading = useMedicineStore((state) => state.loading);
  const error = useMedicineStore((state) => state.error);

  useEffect(() => {
    // Fetch medicines from API when component mounts
    fetchMedicines();
  }, [fetchMedicines]);

  const handleLogout = () => {
    setIsAuthenticated(false);
    navigate('/');
  };

  return (
    <div className="fixed inset-0 min-h-screen bg-blue-500 p-10"
    style={{
      backgroundImage: "url('/images/AppPage-image.jpg')"
    }}
    >

  {/* Logout button */}
  <button
    className="fixed bottom-4 right-4 bg-red-500 hover:bg-red-600 text-white font-semibold py-1 px-4 rounded transition"
    onClick={handleLogout}
  >
    Log Out
  </button>

  <h1 className="text-2xl font-bold mb-6 text-black">Medicine Reminder</h1>

  {error && (
    <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
      Error: {error}
    </div>
  )}

  {loading && (
    <div className="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded mb-4">
      Loading medicines...
    </div>
  )}

  {/* ✅ Two-column layout wrapper */}
  <div className="flex gap-6 max-w-5xl mx-auto">

   <div className="w-1/2"><MedicineForm /> </div>
    <div className="w-1/2"><MedicineList /></div>

  </div>

  <Snackbar />
  <ReminderChecker />
</div>
  )}
export default AppPage;
