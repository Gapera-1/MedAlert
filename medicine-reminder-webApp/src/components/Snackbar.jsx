// src/components/Snackbar.jsx
import { useEffect, useState } from 'react';
import useMessageStore from '../store/useMessageStore';

function Snackbar() {
  const [message, setMessage] = useState('');
  const [type, setType] = useState('');

  useEffect(() => {
    let timer;

    const unsubscribe = useMessageStore.subscribe((state) => {
      setMessage(state.message);
      setType(state.messageType);

      if (timer) clearTimeout(timer);

      if (state.message) {
        timer = setTimeout(() => {
          setMessage('');
          setType('');
        }, 3000);
      }
    });

    return () => {
      if (timer) clearTimeout(timer);
      unsubscribe();
    };
  }, []);

  if (!message) return null;

  const bg =
    type === 'success'
      ? 'bg-green-700'
      : type === 'info'
      ? 'bg-blue-700'
      : 'bg-red-700';

  return (
    <div
      className={`fixed bottom-4 left-1/2 -translate-x-1/2 ${bg} bg-opacity-90 p-4 rounded text-white shadow-lg`}
    >
      {message}
    </div>
  );
}

export default Snackbar;
