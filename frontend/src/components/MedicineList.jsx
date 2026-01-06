import { useState } from 'react';
import useMedicineStore from '../store/useMedicineStore';
import useMessageStore from '../store/useMessageStore';
import { Link } from "react-router-dom";

function MedicineList() {
  const medicines = useMedicineStore((state) => state.medicines);
  const removeMedicine = useMedicineStore((state) => state.removeMedicine);
  const markTaken = useMedicineStore((state) => state.markTaken);
  const setMessage = useMessageStore((state) => state.setMessage);
  const [processingId, setProcessingId] = useState(null);

  const handleRemove = async (id) => {
    if (window.confirm('Are you sure you want to remove this medicine?')) {
      setProcessingId(id);
      try {
        await removeMedicine(id);
        setMessage('Medicine removed successfully', 'success');
      } catch (error) {
        setMessage(`Error removing medicine: ${error.message}`, 'error');
      } finally {
        setProcessingId(null);
      }
    }
  };

  const handleMarkTaken = async (id, time) => {
    setProcessingId(`${id}-${time}`);
    try {
      await markTaken(id, time);
    } catch (error) {
      setMessage(`Error marking as taken: ${error.message}`, 'error');
    } finally {
      setProcessingId(null);
    }
  };

  return (
    <div className="flex flex-col p-4 bg-gray-50 rounded h-[400px] overflow-y-auto ">
      <h2 className="font-bold mb-2">Medicine List</h2>
      <ul>
        {medicines.map((med) => (
          <li key={med.id} className="mb-4">
            <div className="mb-1 font-semibold">
              {med.name} — {med.posology}
            </div>

            <div className="flex gap-2 flex-wrap">
              {med.times.map((time) => (
                <div key={time} className="flex flex-row items-center gap-2">
                  <span>{time}</span>
                  {med.takenTimes?.[time] ? (
                    <span className="text-green-600 font-bold">Taken ✅</span>
                  ) : (
                    <button
                      onClick={() => handleMarkTaken(med.id, time)}
                      disabled={processingId === `${med.id}-${time}`}
                      className="bg-blue-600 text-white px-2 py-1 rounded disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {processingId === `${med.id}-${time}` ? 'Processing...' : 'Mark as Taken'}
                    </button>
                  )}
                </div>
              ))}
            </div>

            {/* ✅ NEW BUTTON — View Contra‑Indications */}
            <Link
              to={`/contra-indications/${encodeURIComponent(med.name)}`}
              className="inline-block bg-purple-600 text-white px-3 py-1 rounded mt-2 hover:bg-purple-700"
            >
              View Contra‑Indications
            </Link>

            <button
              onClick={() => handleRemove(med.id)}
              disabled={processingId === med.id}
              className="flex flex-row bg-red-600 text-white p-1 rounded mt-2 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {processingId === med.id ? 'Removing...' : 'Remove Medicine'}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default MedicineList;