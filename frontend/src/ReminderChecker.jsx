// src/ReminderChecker.jsx
import { useEffect } from 'react';
import useMedicineStore from './store/useMedicineStore';
import useMessageStore from './store/useMessageStore';

function ReminderChecker() {
  const medicines = useMedicineStore((s) => s.medicines);
  const setMessage = useMessageStore((s) => s.setMessage);

  useEffect(() => {
    if ('Notification' in window && Notification.permission !== 'granted') {
      Notification.requestPermission();
    }

    const interval = setInterval(() => {
      const now = new Date();
      const currentTime = now.toTimeString().slice(0, 5); // HH:MM
      const today = now.toISOString().split('T')[0];

      medicines.forEach((med) => {
        if (med.completed) return;
        if (!med.times?.includes(currentTime)) return;
        if (med.takenTimes?.[currentTime]) return;

        // Duration auto-remove (optional)
        if (med.duration && med.startDate) {
          const start = new Date(med.startDate);
          const daysPassed = Math.floor(
            (now - start) / (1000 * 60 * 60 * 24)
          );
          if (daysPassed >= med.duration) {
            useMedicineStore.getState().removeMedicine(med.id).catch((err) => {
              console.error('Error auto-removing expired medicine:', err);
            });
            return;
          }
        }

        const text = `Please take ${med.posology} of ${med.name}`;

        // UI Snackbar
        setMessage(text, 'info');

        // Voice
        if ('speechSynthesis' in window && !window.speechSynthesis.speaking) {
          const utterance = new SpeechSynthesisUtterance(text);
          window.speechSynthesis.speak(utterance);
        }

        // Browser notification
        if (Notification.permission === 'granted') {
          new Notification('Medicine Reminder', { body: text });
        }
      });
    }, 10000); // 🔁 every 10 seconds until taken

    return () => clearInterval(interval);
  }, [medicines, setMessage]);

  return null;
}

export default ReminderChecker;
