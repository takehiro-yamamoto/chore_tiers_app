document.addEventListener("turbo:load", function () {
  console.log("turbo:load fired ✅");

  const typeSelect = document.getElementById("chore_frequency_type"); // ← ここ修正
  const weeklySection = document.getElementById("weekly_days_section");
  const onceSection = document.getElementById("once_date_section");

  console.log("frequency_type_select:", typeSelect);
  console.log("weeklySection:", weeklySection);
  console.log("onceSection:", onceSection);

  function toggleSections() {
    const val = typeSelect?.value;
    console.log("選択値:", val);

    if (!val || val === "") {
      weeklySection.style.display = "none";
      onceSection.style.display = "none";
    } else if (val === "daily") {
      weeklySection.style.display = "none";
      onceSection.style.display = "none";
    } else if (val === "weekly") {
      weeklySection.style.display = "flex";
      onceSection.style.display = "none";
    } else if (val === "once") {
      weeklySection.style.display = "none";
      onceSection.style.display = "block";
    }
  }

  if (typeSelect) {
    typeSelect.addEventListener("change", toggleSections);
    toggleSections(); // 初期表示
  }
});
