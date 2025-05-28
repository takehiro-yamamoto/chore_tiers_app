document.addEventListener("DOMContentLoaded", () => {
  const chores = document.querySelectorAll(".chore-card");
  const tiers = document.querySelectorAll(".task-list");

  chores.forEach(chore => {
    chore.addEventListener("dragstart", (e) => {
      e.dataTransfer.setData("choreId", chore.dataset.choreId);
    });
  });

  tiers.forEach(tier => {
    tier.addEventListener("dragover", (e) => {
      e.preventDefault();
    });

    tier.addEventListener("drop", (e) => {
      e.preventDefault();
      const choreId = e.dataTransfer.getData("choreId");
      const targetTierId = tier.dataset.tierId;
      const card = document.querySelector(`[data-chore-id='${choreId}']`);
      tier.appendChild(card);

      fetch(`/chores/${choreId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ chore: { tier_id: targetTierId } })
      });
    });
  });
});
