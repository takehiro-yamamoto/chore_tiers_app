document.addEventListener('turbo:load', () => {
  document.querySelector('.calendar-grid')?.addEventListener('click', event => {
    const cell = event.target.closest('.calendar-cell');
    if (!cell) return;

    document.querySelectorAll('.calendar-cell').forEach(c => c.classList.remove('selected'));
    cell.classList.add('selected');

    const selectedDate = cell.dataset.date;
    const choreList = document.querySelectorAll('.calendar-task-item');

    choreList.forEach(task => {
      task.style.display = task.dataset.date === selectedDate ? 'block' : 'none';
    });

    const title = document.querySelector('.calendar-detail-title');
    if (title) {
      const dateObj = new Date(selectedDate);
      title.textContent = `${dateObj.getMonth() + 1}月${dateObj.getDate()}日の予定家事`;
    }
  });
});
