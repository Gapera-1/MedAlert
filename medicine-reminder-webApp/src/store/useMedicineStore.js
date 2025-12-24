// src/store/useMedicineStore.js
import { create } from 'zustand';

const useMedicineStore = create((set) => ({
  medicines: JSON.parse(localStorage.getItem('medicines')) || [],

  addMedicine: (medicine) => {
    set((state) => {
      const newMeds = [
        ...state.medicines,
        {
          ...medicine,
          id: Date.now(),
          startDate: new Date().toISOString().split('T')[0], // YYYY-MM-DD
          takenTimes: {},
          lastNotified: {},
          completed: false,
        },
      ];
      localStorage.setItem('medicines', JSON.stringify(newMeds));
      return { medicines: newMeds };
    });
  },

  removeMedicine: (id) => {
    set((state) => {
      const newMeds = state.medicines.filter((m) => m.id !== id);
      localStorage.setItem('medicines', JSON.stringify(newMeds));
      return { medicines: newMeds };
    });
  },

  markTaken: (id, time) => {
    set((state) => {
      const newMeds = state.medicines.map((m) =>
        m.id === id
          ? {
              ...m,
              takenTimes: { ...m.takenTimes, [time]: true },
            }
          : m
      );
      localStorage.setItem('medicines', JSON.stringify(newMeds));
      return { medicines: newMeds };
    });

    window.speechSynthesis.cancel();
  },

  markCompleted: (id) => {
    set((state) => {
      const newMeds = state.medicines.map((m) =>
        m.id === id ? { ...m, completed: true } : m
      );
      localStorage.setItem('medicines', JSON.stringify(newMeds));
      return { medicines: newMeds };
    });
  },
}));

export default useMedicineStore;