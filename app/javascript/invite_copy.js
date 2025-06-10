document.addEventListener("DOMContentLoaded", () => {
  const copyButton = document.getElementById("copy-button");
  const inviteInput = document.getElementById("invite-link");
  const successMsg = document.getElementById("copy-success");

  if (copyButton && inviteInput) {
    copyButton.addEventListener("click", () => {
      inviteInput.select();
      document.execCommand("copy");

      successMsg.style.display = "inline";
      setTimeout(() => {
        successMsg.style.display = "none";
      }, 1500);
    });
  }
});
