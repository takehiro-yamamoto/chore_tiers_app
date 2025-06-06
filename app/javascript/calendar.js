document.addEventListener('DOMContentLoaded', () => {
  const calendarCells = document.querySelectorAll('.calendar-cell');

  calendarCells.forEach(cell => {
    cell.addEventListener('click', () => {
      document.querySelectorAll('.calendar-cell').forEach(c => c.classList.remove('selected'));
      cell.classList.add('selected');

      const selectedDate = cell.dataset.date;
      const choreList = document.querySelectorAll('.calendar-task-item');

      choreList.forEach(task => {
        task.style.display = task.dataset.date === selectedDate ? 'block' : 'none';
      });

      // 選択日表示の更新
      const title = document.querySelector('.calendar-detail-title');
      if (title) {
        const dateObj = new Date(selectedDate);
        title.textContent = `${dateObj.getMonth() + 1}月${dateObj.getDate()}日 の予定された家事`;
      }
    });
  });
});
