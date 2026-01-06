// src/store/useMedicineStore.js
import { create } from 'zustand';
import * as api from '../services/api';

const useMedicineStore = create((set, get) => ({
  medicines: [],
  loading: false,
  error: null,

  // Fetch medicines from API
  fetchMedicines: async () => {
    set({ loading: true, error: null });
    try {
      const medicines = await api.fetchMedicines();
      // Transform backend data to match frontend format
      const transformedMedicines = medicines.map((med) => ({
        id: med.id,
        name: med.name,
        times: med.times,
        posology: med.posology,
        duration: med.duration,
        startDate: med.start_date || new Date().toISOString().split('T')[0],
        takenTimes: med.taken_times || {},
        lastNotified: med.last_notified || {},
        completed: med.completed || false,
      }));
      set({ medicines: transformedMedicines, loading: false });
    } catch (error) {
      set({ error: error.message, loading: false });
      console.error('Error fetching medicines:', error);
    }
  },

  // Add a new medicine
  addMedicine: async (medicine) => {
    set({ loading: true, error: null });
    try {
      const newMedicine = await api.createMedicine(medicine);
      // Transform backend response to match frontend format
      const transformed = {
        id: newMedicine.id,
        name: newMedicine.name,
        times: newMedicine.times,
        posology: newMedicine.posology,
        duration: newMedicine.duration,
        startDate: newMedicine.start_date || new Date().toISOString().split('T')[0],
        takenTimes: newMedicine.taken_times || {},
        lastNotified: newMedicine.last_notified || {},
        completed: newMedicine.completed || false,
      };
      set((state) => ({
        medicines: [...state.medicines, transformed],
        loading: false,
      }));
      return transformed;
    } catch (error) {
      set({ error: error.message, loading: false });
      console.error('Error adding medicine:', error);
      throw error;
    }
  },

  // Remove a medicine
  removeMedicine: async (id) => {
    set({ loading: true, error: null });
    try {
      await api.deleteMedicine(id);
      set((state) => ({
        medicines: state.medicines.filter((m) => m.id !== id),
        loading: false,
      }));
    } catch (error) {
      set({ error: error.message, loading: false });
      console.error('Error removing medicine:', error);
      throw error;
    }
  },

  // Mark a medicine time as taken
  markTaken: async (id, time) => {
    set({ loading: true, error: null });
    try {
      const updatedMedicine = await api.markMedicineTaken(id, time);
      // Transform backend response
      const transformed = {
        id: updatedMedicine.id,
        name: updatedMedicine.name,
        times: updatedMedicine.times,
        posology: updatedMedicine.posology,
        duration: updatedMedicine.duration,
        startDate: updatedMedicine.start_date || new Date().toISOString().split('T')[0],
        takenTimes: updatedMedicine.taken_times || {},
        lastNotified: updatedMedicine.last_notified || {},
        completed: updatedMedicine.completed || false,
      };
      set((state) => ({
        medicines: state.medicines.map((m) => (m.id === id ? transformed : m)),
        loading: false,
      }));
      window.speechSynthesis.cancel();
    } catch (error) {
      set({ error: error.message, loading: false });
      console.error('Error marking medicine as taken:', error);
      throw error;
    }
  },

  // Mark a medicine as completed
  markCompleted: async (id) => {
    set({ loading: true, error: null });
    try {
      const updatedMedicine = await api.markMedicineCompleted(id);
      // Transform backend response
      const transformed = {
        id: updatedMedicine.id,
        name: updatedMedicine.name,
        times: updatedMedicine.times,
        posology: updatedMedicine.posology,
        duration: updatedMedicine.duration,
        startDate: updatedMedicine.start_date || new Date().toISOString().split('T')[0],
        takenTimes: updatedMedicine.taken_times || {},
        lastNotified: updatedMedicine.last_notified || {},
        completed: updatedMedicine.completed || false,
      };
      set((state) => ({
        medicines: state.medicines.map((m) => (m.id === id ? transformed : m)),
        loading: false,
      }));
    } catch (error) {
      set({ error: error.message, loading: false });
      console.error('Error marking medicine as completed:', error);
      throw error;
    }
  },
}));

export default useMedicineStore;