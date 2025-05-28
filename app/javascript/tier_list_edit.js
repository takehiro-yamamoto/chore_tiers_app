document.addEventListener("DOMContentLoaded", () => {
  const cards = document.querySelectorAll(".chore-card");
  const zones = document.querySelectorAll(".tier-drop-zone");

  cards.forEach(card => {
    card.addEventListener("dragstart", e => {
      card.classList.add("dragging");
      e.dataTransfer.setData("text/plain", card.dataset.choreId);
    });

    card.addEventListener("dragend", () => {
      card.classList.remove("dragging");
    });
  });

  zones.forEach(zone => {
  zone.addEventListener("dragover", e => e.preventDefault());

  // ⭐ アニメーション用：ドラッグがゾーンに入った時
  zone.addEventListener("dragenter", () => {
    zone.classList.add("drag-over");
  });

  // ⭐ アニメーション用：ドラッグがゾーンを離れた時
  zone.addEventListener("dragleave", () => {
    zone.classList.remove("drag-over");
  });

  zone.addEventListener("drop", e => {
    e.preventDefault();
    zone.classList.remove("drag-over"); // ⭐ ドロップ時にも削除

    const choreId = e.dataTransfer.getData("text/plain");
    const targetZone = e.currentTarget;
    const newTierId = targetZone.dataset.tierId || null;

    const card = document.querySelector(`[data-chore-id='${choreId}']`);
    if (card) {
      targetZone.appendChild(card);

      fetch(window.location.pathname.replace(/\/edit_tiers$/, "/update_tiers"), {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({
          chore_updates: [
            { id: parseInt(choreId), tier_id: newTierId ? parseInt(newTierId) : null }
          ]
        })
      });
    }
  });
});

});
// ⭐ ドラッグアンドドロップのスタイルを追加