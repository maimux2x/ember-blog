export default function formatDatetime(
  date?: Date,
  format: 'date' | 'datetime' = 'datetime',
) {
  const opts: Intl.DateTimeFormatOptions =
    format === 'date'
      ? {
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }
      : {
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
          hour: 'numeric',
          minute: 'numeric',
        };

  return new Intl.DateTimeFormat('ja-JP', opts).format(date);
}
