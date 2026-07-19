export function minutesToDurationLabel(minutes = 0) {
  const safeMinutes = Number(minutes) || 0;
  const hours = Math.floor(safeMinutes / 60);
  const remainingMinutes = safeMinutes % 60;

  if (hours <= 0) {
    return `${remainingMinutes}m`;
  }

  if (remainingMinutes === 0) {
    return `${hours}h`;
  }

  return `${hours}h ${remainingMinutes}m`;
}

export function minutesToHoursLabel(minutes = 0) {
  return `${((Number(minutes) || 0) / 60).toFixed(1)}h`;
}

export function todayIsoDate() {
  return new Date().toISOString().slice(0, 10);
}

export function currentMonthValue() {
  return new Date().toISOString().slice(0, 7);
}

export function toTimeInputValue(value) {
  return value ? value.slice(0, 5) : "";
}

export function calculateDurationMinutes(startTime, endTime) {
  if (!startTime || !endTime) {
    return null;
  }

  const [startHour, startMinute] = startTime.split(":").map(Number);
  const [endHour, endMinute] = endTime.split(":").map(Number);
  const startTotal = startHour * 60 + startMinute;
  const endTotal = endHour * 60 + endMinute;
  const duration = endTotal - startTotal;

  return duration > 0 ? duration : null;
}

export function displayDate(value) {
  if (!value) {
    return "-";
  }

  return new Date(`${value}T00:00:00`).toLocaleDateString(undefined, {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
}