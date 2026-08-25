document.addEventListener("DOMContentLoaded", () => {
  const password = document.getElementById("user_password");
  const show = document.getElementById("show-password");

  if (!password || !show) return;

  show.addEventListener("click", () => {
    if (password.type === "password") {
      password.type = "text";
      show.textContent = "Hide";
    } else {
      password.type = "password";
      show.textContent = "Show";
    }
  });
});
