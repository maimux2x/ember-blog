export default function formatDatetime(string, format = 'datetime') {
  const date = new Date(string);

  const opts =
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
